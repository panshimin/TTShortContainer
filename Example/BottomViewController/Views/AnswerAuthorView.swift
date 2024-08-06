//
//  AnswerAuthorView.swift
//  omni
//
//  Created by zxy on 2024/7/22.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class AnswerAuthorView: UIView {
    
    private struct Layout {
        static let leftPadding: CGFloat = 16
        static let rightPadding: CGFloat = 16
        static let topPadding: CGFloat = 8
        static let bottomPadding: CGFloat = 8
        static let avatarWH: CGFloat = 20
    }
    
    private lazy var avaterView: UIImageView = {
        let frame = CGRect(x: 0, y: 0, width: Layout.avatarWH, height: Layout.avatarWH)
        let imageView = UIImageView(frame: frame)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCustomUI() {
        self.addSubview(avaterView)
        self.addSubview(nickNameLabel)
        
        avaterView.snp.makeConstraints { make in
            make.left.equalTo(Layout.leftPadding)
            make.top.equalTo(Layout.topPadding)
            make.width.height.equalTo(Layout.avatarWH)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(avaterView.snp.right).offset(6)
            make.centerY.equalTo(avaterView.snp.centerY)
            make.height.equalTo(17)
            make.right.lessThanOrEqualToSuperview().offset(-Layout.rightPadding)
        }
    }
    
    func bind(_ author: AuthorModel?) {
        guard let author = author else {
            return
        }
        
        if let avatarUrl = author.avatarUrl {
            avaterView.sd_setImage(with: URL(string: avatarUrl), completed: nil)
        }
        
        if let nickName = author.name {
            nickNameLabel.text = nickName
        }
    }
    
}
