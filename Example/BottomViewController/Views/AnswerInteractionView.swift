//
//  AnswerInteractionView.swift
//  omni
//
//  Created by psm on 2024/7/22.
//

import Foundation
import UIKit

class AnswerInteractionView: UIView {
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    private lazy var commentCountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCustomUI() {
        self.addSubview(likeCountLabel)
        self.addSubview(commentCountLabel)
    }
    
    func bind(_ interaction: InteractionModel?) {
        guard let interaction = interaction else {
            return
        }
        
        if interaction.likeCount > 0 {
            likeCountLabel.text = "\(interaction.likeCount) 喜欢"
        }
        
        if interaction.commentCount > 0 {
            commentCountLabel.text = "\(interaction.commentCount) 评论"
        }
        
    }
    
}
