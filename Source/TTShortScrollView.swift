//
//  TTShortScrollView.swift
//
//  Created by psm on 2022/8/2.
//

import UIKit

public class TTShortScrollView: UIScrollView {
    
    @objc dynamic public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer, pan == panGestureRecognizer else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        let v = pan.translation(in: self)
        return abs(v.x) <= abs(v.y)
    }
    
    @objc dynamic public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        // Make sure the first touch event in scrolling, can only stop scrolling, not deliver to the content view in
        // the wrappered scrollview.
        if (isDragging || isDecelerating), view?.isDescendant(of: self) == true {
            return self
        }
        return view
    }
}
