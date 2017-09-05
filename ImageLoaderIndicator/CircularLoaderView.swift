//
//  CircularLoaderVIew.swift
//  ImageLoaderIndicator
//
//  Created by Dmitriy Roytman on 05.09.17.
//  Copyright © 2017 Rounak Jain. All rights reserved.
//

import UIKit

final class CircularLoaderView: UIView {
  // mark: private constants
  private let circlePathLayer = CAShapeLayer()
  private let circleRadius: CGFloat = 20
  
  // mark: computed property
  var progress: CGFloat {
    get { return circlePathLayer.strokeEnd }
    set {
      guard newValue <= 1 else {
        circlePathLayer.strokeEnd = 1
        return
      }
      guard newValue >= 0 else {
        circlePathLayer.strokeEnd = 0
        return
      }
      circlePathLayer.strokeEnd = newValue
    }
  }
  
  
  // MARK: Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  // helper method
  private func configure() {
    progress = 0
    circlePathLayer.frame = bounds
    circlePathLayer.lineWidth = 2
    circlePathLayer.fillColor = UIColor.clear.cgColor
    circlePathLayer.strokeColor = UIColor.red.cgColor
    layer.addSublayer(circlePathLayer)
    backgroundColor = .white
  }
  
  // MARK: Lifecycle
  override func layoutSubviews() {
    super.layoutSubviews()
    circlePathLayer.frame = bounds
    circlePathLayer.path = circlePath.cgPath
  }
  
  func reveal() {
    backgroundColor = .clear
    progress = 1
    circlePathLayer.removeAnimation(forKey: "strokeEnd")
    circlePathLayer.removeFromSuperlayer()
    superview?.layer.mask = circlePathLayer
    
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    let finalRadius = sqrt((center.x*center.x) + (center.y*center.y))
    let radiusInset = finalRadius - circleRadius
    let outerRect = circleFrame.insetBy(dx: -radiusInset, dy: -radiusInset)
    let toPath = UIBezierPath(ovalIn: outerRect).cgPath
    
    let fromPath = circlePathLayer.path
    let fromLineWidth = circlePathLayer.lineWidth
    
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    circlePathLayer.lineWidth = 2*finalRadius
    circlePathLayer.path = toPath
    CATransaction.commit()
    
    let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
    lineWidthAnimation.fromValue = fromLineWidth
    lineWidthAnimation.toValue = 2*finalRadius
    let pathAnimation = CABasicAnimation(keyPath: "path")
    pathAnimation.fromValue = fromPath
    pathAnimation.toValue = toPath
    
    let groupAnimation = CAAnimationGroup()
    groupAnimation.duration = 1
    groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    groupAnimation.animations = [pathAnimation, lineWidthAnimation]
    groupAnimation.delegate = self
    circlePathLayer.add(groupAnimation, forKey: "strokeWidth")
  }
  
  // MARK: Private computed properties, helping to layout subviews
  private var circleFrame: CGRect {
    let side = 2*circleRadius
    var circleFrame = CGRect(x: 0, y: 0, width: side, height: side)
    let bounds = circlePathLayer.bounds
    circleFrame.origin.x = bounds.midX - circleFrame.midX
    circleFrame.origin.y = bounds.midY - circleFrame.midY
    return circleFrame
  }
  
  private var circlePath: UIBezierPath { return UIBezierPath(ovalIn: circleFrame) }
}

extension CircularLoaderView: CAAnimationDelegate {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    superview?.layer.mask = nil
  }
}
