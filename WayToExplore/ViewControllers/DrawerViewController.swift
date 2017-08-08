//
//  DrawerViewController.swift
//  WayToExplore
//
//  Created by shen on 2017/8/7.
//  Copyright © 2017年 shen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//Could not perform segue with identifier 'left'. A segue must either have a performHandler or it must override -perform.'
class DarwerSegue: UIStoryboardSegue {
    override func perform() {
        
    }
}

class DrawerViewController: UIViewController {

    var leftDrawerWidth: CGFloat = 250.0
    
    var leftViewController: UIViewController?
    var centerViewController: UIViewController?
    
    var centerOverlayView: UIView?
    
    private let disposeBag = DisposeBag()
    
    private var isAnimatingDrawer = false
    private var startingPanX: CGFloat = 0
    
    lazy var panGesture = UIPanGestureRecognizer()
    
    var isOpenDrawer = false {
        willSet{
            guard let leftViewController = leftViewController, let centerViewController = centerViewController else {
                return
            }
            
            isAnimatingDrawer = true
            
            var leftRect = leftViewController.view.frame
            var centerRect = centerViewController.view.frame
            
            leftRect.size.height = centerRect.size.height
            leftRect.origin.x = newValue ? 0.0 : -leftDrawerWidth
            centerRect.origin.x += newValue ? leftDrawerWidth : -leftDrawerWidth
            
            UIView.animate(withDuration: 0.35, animations: { 
                leftViewController.view.frame = leftRect
                centerViewController.view.frame = centerRect
                
                self.centerOverlayView?.alpha = newValue ? 0.3 : 0.0
            }) { finished in
                self.isAnimatingDrawer = false
            }
        }
    }
    
    override func awakeFromNib() {
        guard let _ = storyboard else {
            return
        }
        performSegue(withIdentifier: "left", sender: self)
        performSegue(withIdentifier: "center", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        panGesture.rx.event.subscribe(onNext: { [weak self ] sender in
            guard let `self` = self else {
                return
            }
            
            guard let leftViewController = self.leftViewController, let centerViewController = self.centerViewController else {
                return
            }
            switch sender.state {
            case .began:
                if self.isAnimatingDrawer {
                    sender.isEnabled = false
                    break
                }else {
                    self.startingPanX = centerViewController.view.frame.minX
                }
            case .changed:
                let point = sender.translation(in: sender.view)
                
                var leftFrame = leftViewController.view.frame
                var centerFrame = centerViewController.view.frame
                centerFrame.origin.x = min(self.leftDrawerWidth, max(self.startingPanX + point.x,0.0))
                leftFrame.origin.x = centerFrame.origin.x - leftFrame.width
                leftFrame.size.height = centerFrame.size.height
                
                leftViewController.view.frame = leftFrame
                centerViewController.view.frame = centerFrame
                
                self.centerOverlayView?.alpha = centerFrame.minX / self.leftDrawerWidth * 0.3
            
            case .ended, .cancelled:
                let velocity = sender.velocity(in: centerViewController.view)
                let animationTreshold: CGFloat = 200.0
                let animationVelocity = max(abs(velocity.x), animationTreshold * 2)
                
                let oldFrame = centerViewController.view.frame
                var newFrame = oldFrame
                if newFrame.minX <= self.leftDrawerWidth / 2.0 {
                    newFrame.origin.x = 0.0
                } else {
                    newFrame.origin.x = self.leftDrawerWidth
                }
                
                var leftFrame = leftViewController.view.frame
                leftFrame.origin.x = newFrame.origin.x - leftFrame.width
                leftFrame.size.height = oldFrame.size.height
                
                let distance = abs(oldFrame.minX - newFrame.origin.x)
                let minimumAnimationDuration: CGFloat = 0.15
                let duration: TimeInterval = TimeInterval(max(distance/abs(animationVelocity), minimumAnimationDuration))
                
                let alpha = (newFrame.minX / self.leftDrawerWidth) * 0.3
                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: animationVelocity / distance, options: [], animations: { 
                    self.centerOverlayView?.alpha = alpha
                    leftViewController.view.frame = leftFrame
                    centerViewController.view.frame = newFrame
                }, completion: { (_) in
                    self.isAnimatingDrawer = false
                })
                
            default: break
            }
            
        }, onError: { e in
            
        }, onCompleted: { 
            print("pan gesture finished");
        }) { 
            print("dispose")
        }.addDisposableTo(disposeBag)
        
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { (tap) in
            print("bottom view tapped")
        }).addDisposableTo(disposeBag)
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is DarwerSegue {
            addChildViewController(segue.destination)
            view.addSubview(segue.destination.view)
            segue.destination.didMove(toParentViewController: self)
            
            if segue.destination is ProfileViewController {
                let controller = segue.destination as! ProfileViewController
                var rect = controller.view.frame
                rect.origin.x = -leftDrawerWidth
                rect.size.width = leftDrawerWidth
                controller.view.frame = rect
                leftViewController = controller
            }else if segue.destination is UINavigationController {
                centerViewController = segue.destination
                (centerViewController as! UINavigationController).delegate = self
                
                centerOverlayView = UIView()
                centerOverlayView?.translatesAutoresizingMaskIntoConstraints = false
                centerOverlayView?.backgroundColor = UIColor.black
                centerOverlayView?.alpha = 0.0
                centerViewController!.view.addSubview(centerOverlayView!)
                
                centerOverlayView?.leadingAnchor.constraint(equalTo: (centerViewController?.view.leadingAnchor)!).isActive = true
                centerOverlayView?.trailingAnchor.constraint(equalTo: (centerViewController?.view.trailingAnchor)!).isActive = true
                centerOverlayView?.topAnchor.constraint(equalTo: (centerViewController?.view.topAnchor)!).isActive = true
                centerOverlayView?.bottomAnchor.constraint(equalTo: (centerViewController?.view.bottomAnchor)!).isActive = true
                
                let tap = UITapGestureRecognizer()
                tap.rx.event.subscribe(onNext: { (_) in
                    self.isOpenDrawer = false
                }).addDisposableTo(disposeBag)
                centerOverlayView?.addGestureRecognizer(tap)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension DrawerViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            if view.gestureRecognizers?.contains(panGesture) != true {
                 view.addGestureRecognizer(panGesture)
            }
        } else {
            if view.gestureRecognizers?.contains(panGesture) == true {
                view.removeGestureRecognizer(panGesture)
            }
        }
    }
}

extension UIViewController {
    var drawerViewController: DrawerViewController? {
        var drawer = parent
        while drawer != nil {
            if let drawer = drawer as? DrawerViewController {
                return drawer
            }
            drawer = parent?.parent
        }
        
        if let controller = drawer as? DrawerViewController {
            return controller
        }
        if let controller = presentingViewController as? DrawerViewController {
            return controller
        }
        return drawer as? DrawerViewController
    }
}
