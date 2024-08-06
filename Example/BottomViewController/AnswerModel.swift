//
//  AnswerModel.swift
//  ShortContainer
//
//  Created by psm on 2024/7/22.
//

import Foundation
import IGListDiffKit
import CoreText

class AnswerModel: NSObject {
    
    var author: AuthorModel?
    var except: String?
    var imageUrl: String?
    var cardHeight: CGFloat = 0
}

extension AnswerModel: ListDiffable {
    
    func diffIdentifier() -> any NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: (any ListDiffable)?) -> Bool {
        guard let object = object as? AnswerModel else {
            return false
        }
        
        return self.except == object.except
    }
    
    static func calculateCardHeight(model: AnswerModel?) -> CGFloat {
        guard let model = model else {
            return 0
        }
        
        let topPadding: CGFloat = 16
        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 16
        let bottomPadding: CGFloat = 16
        let screenWidth = UIScreen.main.bounds.width
        let maxWidth = screenWidth - leftPadding - rightPadding
        
        var cardHeight: CGFloat = topPadding
        var exceptHeight = 0.0
        if let except = model.except {
            let exceptAttributedText = NSAttributedString(string: except, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
            let msg = Self.measureAttributedText(attributedText: exceptAttributedText, limitWidth: maxWidth, limitRows: 10)
            exceptHeight = msg.size.height
        }
        
        cardHeight += exceptHeight
        
        cardHeight += bottomPadding
        
        return cardHeight
    }
    
    static func measureAttributedText(attributedText: NSAttributedString?,
                                  limitWidth: CGFloat,
                                  limitRows: UInt) -> (size: CGSize, rows: Int, textRows: Int) {
        guard let processedText = attributedText,
              processedText.length > 0,
              limitRows >= 0 else {
            return (.zero, 0, 0)
        }
        
        let cfText = processedText as CFAttributedString
        let framesetter = CTFramesetterCreateWithAttributedString(cfText)
        
        let limitBox = CGRect(x: 0, y: 0, width: limitWidth, height: .greatestFiniteMagnitude)
        let path = CGPath(rect: limitBox, transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame)
        var rows = CFArrayGetCount(lines)
        
        /// 保存原始的文本行数
        let textRows = rows
        
        if limitRows > 0, rows > limitRows {
            rows = CFIndex(limitRows)
        }
        
        var boundingW: CGFloat = 0
        var boundingH: CGFloat = 0
        
        (0 ..< rows).forEach { idx in
            let lineP = CFArrayGetValueAtIndex(lines, idx)
            let line = unsafeBitCast(lineP, to: CTLine.self)
            var lineAscent: CGFloat = 0
            var lineDescent: CGFloat = 0
            var leading: CGFloat = 0
            let lineW = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &leading)
            
            if rows == 1 {
                boundingW = lineW
            }
            
            boundingH += lineAscent + abs(lineDescent) // + leading
        }
        
        let w = limitRows == 1 ? boundingW : limitWidth
        return (CGSize(width: ceil(w), height: ceil(boundingH)), rows, textRows)
    }
}

struct AuthorModel {
    /// 昵称
    var name: String?
    /// 用户头像
    var avatarUrl: String?
}

struct InteractionModel {

    var likeCount: Int
    var commentCount: Int
    
}
