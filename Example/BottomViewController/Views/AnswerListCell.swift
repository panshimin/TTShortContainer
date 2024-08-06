//
//  AnswerListCell.swift
//  ShortContainer
//
//  Created by psm on 2024/7/22.
//

import Foundation
import UIKit

class AnswerListCell: UICollectionViewCell {
    
    private struct Layout {
        
        static let leftPadding: CGFloat = 16
        static let rightPadding: CGFloat = 16
        static let topPadding: CGFloat = 14
        static let bottomPadding: CGFloat = 16
        static let interactionViewHeight: CGFloat = 25
        static let authorViewHeight: CGFloat = 36
        static let imageViewHeight: CGFloat = 60
    }

    private lazy var authorView: AnswerAuthorView = {
        let authorView = AnswerAuthorView(frame: .zero)
        return authorView
    }()
    
    private lazy var excerptLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var showNativeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "从这里开始就是 native 列表了"
        label.textColor = .red
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var interactionView: AnswerInteractionView = {
        let interactionView = AnswerInteractionView(frame: .zero)
        return interactionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomUI() {
        
        self.contentView.addSubview(showNativeLabel)
        showNativeLabel.frame = CGRect(x: 16, y: 0, width: self.width - 32, height: 16)
        showNativeLabel.isHidden = true
        self.contentView.addSubview(excerptLabel)
        self.backgroundColor = .white
    }
    
    func bind(_ answer: AnswerModel?, index: Int) {
        guard let answer = answer else {
            return
        }
        
        
        if index == 0 {
            showNativeLabel.isHidden = false
        } else {
            showNativeLabel.isHidden = true
        }
        
        excerptLabel.text = answer.except
        
        excerptLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
