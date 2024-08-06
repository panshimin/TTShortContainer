//
//  AnswerListSectionController.swift
//  ShortContainer
//
//  Created by psm on 2024/7/22.
//

import Foundation
import IGListKit

class AnswerListSectionController: ListSectionController {
    
    private var answer: AnswerModel?
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext,
              let model = answer else {
            return .zero
        }
        
        return CGSize(width: context.containerSize.width, height: model.cardHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: AnswerListCell.self, for: self, at: index) as? AnswerListCell else {
            fatalError("cellForItem.")
        }
        
        cell.bind(answer,index: section)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        guard let object = object as? AnswerModel else {
            return
        }
        
        answer = object
    }
}
