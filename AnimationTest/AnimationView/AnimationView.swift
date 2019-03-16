//
//  AnimationView.swift
//  AnimationTest
//
//  Created by 黄朔 on 2019/3/16.
//  Copyright © 2019 Prophet. All rights reserved.
//

import UIKit

class AnimationView: UIView {

    private lazy var waveLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = color.cgColor
        return layer
    }()
    
    private var bottomTextLabel: UILabel! {
        didSet {
            bottomTextLayer.mask = bottomTextLabel.layer
        }
    }
    
    private lazy var bottomTextLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    private var topTextLabel: UILabel! {
        didSet {
            topTextLayer.mask = topTextLabel.layer
        }
    }
    private lazy var topTextLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = color.cgColor
        return layer
    }()
    
    lazy var timer: CADisplayLink = {
        let timer = CADisplayLink(target: self, selector: #selector(animtionTime))
        return timer
    }()
    
    /// 偏移量
    private var offset: CGFloat = 0.0
    /// 波浪速度，可抛出，让用户设置
    private var speed: CGFloat = 2.0
    /// 中间显示的文字
    var text: String = "RD" {
        didSet {
            bottomTextLabel = createTextLabel()
            topTextLabel = createTextLabel()
        }
    }
    
    var color: UIColor = UIColor.red {
        didSet {
            waveLayer.fillColor = color.cgColor
            topTextLayer.fillColor = color.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottomTextLabel = createTextLabel()
        topTextLabel = createTextLabel()
        layer.addSublayer(waveLayer)
        layer.addSublayer(bottomTextLayer)
        layer.addSublayer(topTextLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bottomTextLabel = createTextLabel()
        topTextLabel = createTextLabel()
        layer.addSublayer(waveLayer)
        layer.addSublayer(bottomTextLayer)
        layer.addSublayer(topTextLayer)
    }
    
    func startAnimation() {
        timer.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc private func animtionTime() {
        
        let waveHeight: CGFloat = 12.0

        offset = offset + speed;
     
        let path = CGMutablePath()
        let turnPath = CGMutablePath() // 反向path
        
        let startOffsetY = waveHeight * CGFloat(sinf(Float(offset * CGFloat(Double.pi) * 2 / bounds.width)))
        path.move(to: CGPoint(x: 0, y: startOffsetY))
        
        turnPath.move(to: CGPoint(x: 0, y: startOffsetY))
        
        var orignOffsetY: CGFloat = 0
        for x in 0...Int(bounds.width) {
            let currOffset = sinf(Float(2 * CGFloat(Double.pi) / bounds.width * CGFloat(x) + offset * CGFloat(Double.pi) * 2 / bounds.width))
            orignOffsetY = waveHeight * CGFloat(currOffset) + bounds.height / 2.0
            
            path.addLine(to: CGPoint(x: CGFloat(x), y: orignOffsetY))
            turnPath.addLine(to: CGPoint(x: CGFloat(x), y: orignOffsetY))
        }
        // 闭合path
        path.addLine(to: CGPoint(x: bounds.width, y: orignOffsetY))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: startOffsetY))
        path.closeSubpath()
        
        // 闭合turnPatn
        turnPath.addLine(to: CGPoint(x: bounds.width, y: orignOffsetY))
        turnPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        turnPath.addLine(to: CGPoint(x: 0, y: 0))
        turnPath.addLine(to: CGPoint(x: 0, y: startOffsetY))
        turnPath.closeSubpath()
        
        bottomTextLayer.path = path
        waveLayer.path = path
        topTextLayer.path = turnPath
    }
    
}

extension AnimationView {
    /// 生成文本Layer，简单起见，直接用UILabel实现，性能可能稍微差一点点
    /// 另外字体大小可以抛一个属性给用户，这里没做，直接写死的
    private func createTextLabel() -> UILabel {
        let label = UILabel(frame: bounds)
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        label.textAlignment = .center
        label.text = text
        return label
    }
}
