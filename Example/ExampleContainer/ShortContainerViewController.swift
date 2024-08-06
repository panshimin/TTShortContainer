//
//  ShortContainerViewController.swift
//  ShortContainer
//
//  Created by zxy on 2024/8/5.
//

import Foundation
import UIKit
import SnapKit

class ShortContainerViewController: UIViewController {
    
    var shortViewController: TTShortViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShortViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupShortViewController() {
        view.backgroundColor = UIColor.white
        
        let topVC = TopViewController()
        
        shortViewController = TTShortViewController(viewController: topVC)
        
        guard let shortViewController = shortViewController else {
            return
        }
        
        shortViewController.dataSource = self
        shortViewController.delegate = self
        shortViewController.view.backgroundColor = UIColor.white
        
        let statusBarHeight = Self.calculateStatusBarHeight()
        let navigtionBarHeight = Self.calculateNavitationBarHeight()
        shortViewController.view.frame = CGRect(x: 0,
                                                y: statusBarHeight + navigtionBarHeight,
                                                width: self.view.width,
                                                height: self.view.height)
        
        addChild(shortViewController)
        view.addSubview(shortViewController.view)
        shortViewController.didMove(toParent: self)
    }
    
    static func calculateStatusBarHeight() -> CGFloat {
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                guard let scene = scene as? UIWindowScene,
                      let sceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                      let window = sceneDelegate.window as? UIWindow else {
                    fatalError()
                }
                
                return window.safeAreaInsets.top
            }
        }
        
        return 0
    }
    
    static func calculateNavitationBarHeight() -> CGFloat {
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                guard let scene = scene as? UIWindowScene,
                      let statusBarFrame = scene.statusBarManager?.statusBarFrame else {
                    fatalError()
                }
                
                return statusBarFrame.size.height
            }
        }
        
        return 0
    }
}

extension ShortContainerViewController: TTShortViewControllerDataSource {
    func shortViewController(_ shortViewController: TTShortViewController,
                             viewControllerAfter viewController: any TTShortContentViewController) -> (any TTShortContentViewController)? {
        return BottomViewController()
    }

}

extension ShortContainerViewController: TTShortViewControllerDelegate {
    
    func shortViewController(_ shortViewController: TTShortViewController, didScrollToBottomContainer viewController: any TTShortContentViewController) {
        
    }
    
    func shortViewController(_ shortViewController: TTShortViewController, bottomVCDidShow viewController: any TTShortContentViewController) {
        
    }
    
    func shortViewController(_ shortViewController: TTShortViewController, topVCDidAppear viewController: any TTShortContentViewController) {
        
    }
    
    func shortViewController(_ shortViewController: TTShortViewController, topVCWillDisappear viewController: any TTShortContentViewController) {
        
    }
    
    func shortViewController(_ shortViewController: TTShortViewController, topVCDidDisappear viewController: any TTShortContentViewController) {
        
    }
    
    func shortViewController(_ shortViewController: TTShortViewController, didScrollViewScroll scrollView: UIScrollView, with direction: TTShortScrollDirection) {
        
    }
    
    func shortViewController(_ shortViewController: TTShortViewController, scrollViewDidEndScrolling scrollView: UIScrollView) {
        
    }

}
