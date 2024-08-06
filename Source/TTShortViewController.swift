//
//  TTShortViewController.swift
//
//  Created by psm on 2024/5/24.
//

import UIKit

public enum TTShortScrollDirection {
    case idle, up, down
}

public class TTShortViewController: UIViewController {
        
    public lazy var mainScrollView: TTShortScrollView = {
        let scrollView = TTShortScrollView(frame: self.view.bounds)
        scrollView.contentInset = .zero
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        return scrollView
    }()
        
    private var topScrollView: UIScrollView?
    private var bottomScrollView: UIScrollView?
    
    public var topViewController: TTShortContentViewController?
    public var bottomViewController: TTShortContentViewController?
    
    private var lastTopScrollViewContentHeight: CGFloat = 0
    private var lastBottomScrollViewContentHeight: CGFloat = 0

    private var contentOffsetObserverMain: NSKeyValueObservation?
    private var contentSizeObserverMain: NSKeyValueObservation?
    
    private var contentOffsetObserverTop: NSKeyValueObservation?
    private var contentSizeObserverTop: NSKeyValueObservation?

    private var contentOffsetObserverBottom: NSKeyValueObservation?
    private var contentSizeObserverBottom: NSKeyValueObservation?

    lazy var contentView: UIView = {
        let contentView = UIView(frame: self.view.bounds)
        return contentView
    }()
        
    public weak var dataSource: TTShortViewControllerDataSource?
    public weak var delegate: TTShortViewControllerDelegate?
        
    public init(viewController: TTShortContentViewController?) {
        self.topViewController = viewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc dynamic public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mainScrollView)
        mainScrollView.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        mainScrollView.addSubview(contentView)
        contentView.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height * 2)
        
        setupMainScrollViewKVO(scrollView: mainScrollView)

        loadViewControllers()
    }
    
   public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
        
    
    private func loadViewControllers() {
        setupTopViewController(topViewController)
        bottomViewController = lazyBottomController
        setupBottomViewController(bottomViewController)
    }
    
    /// 配置短容器上半部分整屏的 hybrid-VC 视图
    public func setupTopViewController(_ viewController: TTShortContentViewController?, simulateAnimation: Bool = false) {
        guard let topVC = viewController else {
            return
        }
        
        topVC.willMove(toParent: self)
        contentView.addSubview(topVC.view)
        topVC.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        addChild(topVC)
        topVC.didMove(toParent: self)

        
        guard let scrollView = topVC.shortScrollView() else {
            return
        }
        
        topScrollView = scrollView
        setupTopScrollViewKVO(scrollView: scrollView)
    }
        
    private func setupBottomViewController(_ viewController: TTShortContentViewController?) {
        guard let bottomVC = viewController else {
            return
        }
        
        bottomVC.willMove(toParent: self)
        contentView.addSubview(bottomVC.view)
        bottomVC.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        addChild(bottomVC)
        bottomVC.didMove(toParent: self)
        
        guard let scrollView = bottomVC.shortScrollView() else { return }
        bottomScrollView = scrollView
        setupBottomScrollViewKVO(scrollView: scrollView)
    }
    
    private func setupMainScrollViewKVO(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        
        contentOffsetObserverMain = scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (view, change) in
            self?.omniScrollViewDidScroll(scrollView, with: change)
        })
        
        contentSizeObserverMain = scrollView.observe(\.contentSize, options: [.new, .old], changeHandler: { [weak self] (view, change) in
            self?.omniScrollView(scrollView, didContentSizeChanged: change)
        })
    }
    
    private func setupTopScrollViewKVO(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        
        scrollView.isScrollEnabled = false
        scrollView.panGestureRecognizer.require(toFail: mainScrollView.panGestureRecognizer)

        contentOffsetObserverTop = scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (view, change) in
            self?.omniScrollViewDidScroll(scrollView, with: change)
        })
        
        contentSizeObserverTop = scrollView.observe(\.contentSize, options: [.new, .old], changeHandler: { [weak self] (view, change) in
            self?.omniScrollView(scrollView, didContentSizeChanged: change)
        })
    }
    
    private func setupBottomScrollViewKVO(scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }
        
        scrollView.isScrollEnabled = false
        scrollView.panGestureRecognizer.require(toFail: mainScrollView.panGestureRecognizer)

        contentOffsetObserverBottom = scrollView.observe(\.contentOffset, options: [.new, .old], changeHandler: { [weak self] (view, change) in
            self?.omniScrollViewDidScroll(scrollView, with: change)
        })

        contentSizeObserverBottom = scrollView.observe(\.contentSize, options: [.new, .old], changeHandler: { [weak self] (view, change) in
            self?.omniScrollView(scrollView, didContentSizeChanged: change)
        })
    }

    private var lazyBottomController: TTShortContentViewController? {
        if let topVC = topViewController {
            return dataSource?.shortViewController(self, viewControllerAfter: topVC)
        }
        return nil
    }
}

extension TTShortViewController {
        
    func omniScrollViewDidScroll(_ scrollView: UIScrollView, with change: NSKeyValueObservedChange<CGPoint>) {
                
        guard scrollView == mainScrollView else {
            return
        }
        
        guard let new = change.newValue, let old = change.oldValue else {
            return
        }
        
        let diff = new.y - old.y

        let direction: TTShortScrollDirection = diff == 0 ? .idle : (diff > 0 ? .up : .down)
                
        let offsetY = scrollView.contentOffset.y
        let topScrollViewHeight = topScrollView?.height ?? 0
        let bottomScrollViewHeight = bottomScrollView?.height ?? 0
        let topScrollViewContentHeight = topScrollView?.contentSize.height ?? 0
        let bottomScrollViewContentHeight = bottomScrollView?.contentSize.height ?? 0
        
        guard let topViewController = topViewController else { return }

        if offsetY < 0 {
            self.contentView.top = 0
            self.topScrollView?.contentOffset = .zero
            self.bottomScrollView?.contentOffset = .zero
        } else if offsetY == 0 {
            self.contentView.top = 0
            self.bottomScrollView?.contentOffset = .zero
            
            /// 详情页阅读自动定位，详情页的 contentOffset 发生了变化，但是外面的 main scrollView 没有感知到
            /// 所以在这里把详情页的 contentOffset 值同步给 main scrollView

            if let topOffsetY = topScrollView?.contentOffset.y, topOffsetY > 0 {
                self.mainScrollView.setContentOffset(CGPoint(x: 0, y: topOffsetY), animated: false)
            }
                        
            delegate?.shortViewController(self, topVCDidAppear: topViewController)
        } else if offsetY <= topScrollViewContentHeight - topScrollViewHeight {
            self.contentView.top = offsetY
            self.topScrollView?.contentOffset = CGPoint(x: 0, y: offsetY)

            self.bottomScrollView?.contentOffset = .zero
            /// top vc 距离底部的距离
            let distance = topScrollViewContentHeight - topScrollViewHeight - offsetY
            if direction == .up {
                delegate?.shortViewController(self, topVCWillDisappear: topViewController)
            }
            
            if direction == .down {
                delegate?.shortViewController(self, topVCDidAppear: topViewController)
            }
        } else if offsetY <= topScrollViewContentHeight {
            self.contentView.top = topScrollViewContentHeight - topScrollViewHeight
            self.bottomScrollView?.contentOffset = .zero
            self.topScrollView?.contentOffset = CGPoint(x: 0, y: topScrollViewContentHeight - topScrollViewHeight)
            
            guard let bottomViewController = bottomViewController else { return }
            delegate?.shortViewController(self, bottomVCDidShow: bottomViewController)
        } else if offsetY <= topScrollViewContentHeight + bottomScrollViewContentHeight - bottomScrollViewHeight {
            self.contentView.top = offsetY - topScrollViewHeight
            self.bottomScrollView?.contentOffset = CGPoint(x: 0, y: offsetY - topScrollViewContentHeight)
            self.topScrollView?.contentOffset = CGPoint(x: 0, y: topScrollViewContentHeight - topScrollViewHeight)
            
            guard let bottomViewController = bottomViewController else { return }
            delegate?.shortViewController(self, topVCDidDisappear: bottomViewController)
            
        } else if offsetY <= topScrollViewContentHeight + bottomScrollViewContentHeight {
            self.contentView.top = mainScrollView.contentSize.height - self.contentView.height
            self.topScrollView?.contentOffset = CGPoint(x: 0, y: topScrollViewContentHeight - topScrollViewHeight)
            self.bottomScrollView?.contentOffset = CGPoint(x: 0, y: bottomScrollViewContentHeight - bottomScrollViewHeight)
        } else {
            /// 如果还有其他的 subView 可以在这里继续接入~
        }
                
        delegate?.shortViewController(self, didScrollViewScroll: scrollView, with: direction)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.3)
    }
    
    func omniScrollView(_ scrollView: UIScrollView, didContentSizeChanged change: NSKeyValueObservedChange<CGSize>) {
        
        if scrollView == mainScrollView {
            return
        }
        
        let topScrollViewContentHeight: CGFloat = self.topScrollView?.contentSize.height ?? 0
        var bottomScrollViewContentHeight: CGFloat = self.bottomScrollView?.contentSize.height ?? 0

        if topScrollViewContentHeight == lastTopScrollViewContentHeight &&
            bottomScrollViewContentHeight == lastBottomScrollViewContentHeight {
            return
        }
        
        lastTopScrollViewContentHeight = topScrollViewContentHeight
        lastBottomScrollViewContentHeight = bottomScrollViewContentHeight
        
        mainScrollView.contentSize = CGSize(width: self.view.width, height: topScrollViewContentHeight + bottomScrollViewContentHeight)
        
        var topScrollViewHeight = topScrollViewContentHeight < self.view.height ? topScrollViewContentHeight : self.view.height
                
        let bottomScrollViewHeight = bottomScrollViewContentHeight < self.view.height ? bottomScrollViewContentHeight : self.view.height

        contentView.height = topScrollViewHeight + bottomScrollViewHeight
        topViewController?.view.height = topScrollViewHeight
        bottomViewController?.view.height = bottomScrollViewHeight
        
        if let topViewBottom = topViewController?.view.bottom {
            bottomViewController?.view.top = topViewBottom
        } else {
            bottomViewController?.view.top = 0
        }
    }
}

extension TTShortViewController: UIScrollViewDelegate {
    
    @objc dynamic public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        delegate?.shortViewController(self, scrollViewDidEndScrolling: mainScrollView)
    }
}
