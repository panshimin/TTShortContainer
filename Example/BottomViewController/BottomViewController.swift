//
//  BottomViewController.swift
//  ShortContainer
//
//  Created by psm on 2024/7/22.
//

import Foundation
import UIKit
import IGListKit
import SnapKit

class BottomViewController: UIViewController {
    
    // 布局约束
    struct BottomViewLayout {
        
        static let leftPadding: CGFloat = 16
        static let rightPadding: CGFloat = 16
        static let topPadding: CGFloat = 14
        static let bottomPadding: CGFloat = 16
    }
    
    private var bottomInset: CGFloat {
        return Self.calculateBottomSafeArea()
    }

    private lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        return layout
    }()
    
        
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        return collectionView
    }()
    
    private var itemList: [ListDiffable] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readLocalData()
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        collectionView.backgroundColor = UIColor.systemGray6
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func readLocalData() {
        for i in 0 ..< 64 {
            let item = AnswerModel()
            item.except = getLocalInfo(index: i)
            item.cardHeight = AnswerModel.calculateCardHeight(model: item)
            itemList.append(item)
        }
    }
    
    static func calculateBottomSafeArea() -> CGFloat {
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                guard let scene = scene as? UIWindowScene,
                      let sceneDelegate = scene.delegate as? UIWindowSceneDelegate,
                      let window = sceneDelegate.window as? UIWindow else {
                    fatalError()
                }
                
                return window.safeAreaInsets.bottom
            }
        }
        
        return 0
    }
}

extension BottomViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [any ListDiffable] {
        return itemList
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let object = object as? AnswerModel {
            return AnswerListSectionController()
        } else {
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension BottomViewController: TTShortScrollViewProvider {
    
    func shortScrollView() -> UIScrollView? {
        return collectionView
    }
}
