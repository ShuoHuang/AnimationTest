//
//  ViewController.swift
//  AnimationTest
//
//  Created by 黄朔 on 2019/3/16.
//  Copyright © 2019 Prophet. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var animView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animView = AnimationView(frame: CGRect(x: (UIScreen.main.bounds.width - 200.0) / 2.0, y: 250, width: 200, height: 200))
        animView.text = "AB"
        animView.layer.cornerRadius = 100
        animView.layer.masksToBounds = true
        animView.layer.borderColor = UIColor.lightGray.cgColor
        animView.layer.borderWidth = 0.5
        view.addSubview(animView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animView.startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animView.text = "RD"
            self.animView.color = UIColor.orange
        }
    }
    
}

