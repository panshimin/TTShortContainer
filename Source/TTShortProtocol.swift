//
//  TTShortProtocol.swift
//
//  Created by psm on 2022/7/7.
//

import Foundation
import UIKit

public typealias TTShortContentViewController = UIViewController & TTShortScrollViewProvider

public protocol TTShortScrollViewProvider: AnyObject {
    /// Return the scrollView in the target content view controller.
    func shortScrollView() -> UIScrollView?
}


public protocol TTShortViewControllerDataSource: AnyObject {
    
    func shortViewController(_ shortViewController: TTShortViewController,
                                viewControllerAfter viewController: TTShortContentViewController) -> TTShortContentViewController?
}

public protocol TTShortViewControllerDelegate: AnyObject {
    
    func shortViewController(_ shortViewController: TTShortViewController,
                             didScrollToBottomContainer viewController: TTShortContentViewController)
    
    func shortViewController(_ shortViewController: TTShortViewController,
                             bottomVCDidShow viewController: TTShortContentViewController)
    
    func shortViewController(_ shortViewController: TTShortViewController,
                             topVCDidAppear viewController: TTShortContentViewController)
    
    func shortViewController(_ shortViewController: TTShortViewController,
                             topVCWillDisappear viewController: TTShortContentViewController)
    
    func shortViewController(_ shortViewController: TTShortViewController,
                             topVCDidDisappear viewController: TTShortContentViewController)
    
    func shortViewController(_ shortViewController: TTShortViewController,
                             didScrollViewScroll scrollView: UIScrollView,
                             with direction: TTShortScrollDirection)
    
    func shortViewController(_ shortViewController: TTShortViewController,
                             scrollViewDidEndScrolling scrollView: UIScrollView)
}
