//
//  ViewController.swift
//  ShortContainer
//
//  Created by 潘世民 on 2024/8/4.
//

import UIKit

class ViewController: UIViewController {
    
    var testBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("查看demo", for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        testBtn.addTarget(self, action: #selector(didClickedShowBtn), for: .touchUpInside)
        self.view.addSubview(testBtn)
        testBtn.frame = CGRect(x: 150, y: 400, width: 96, height: 48)
    }
    
    @objc
    func didClickedShowBtn() {
        let shorContainerVC = ShortContainerViewController()
        self.navigationController?.pushViewController(shorContainerVC, animated: true)
    }
}

