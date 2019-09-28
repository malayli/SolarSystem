//
//  ViewController.swift
//  SolarSystem
//
//  Created by Malik Alayli on 17/10/2018.
//  Copyright © 2018 Malik Alayli. All rights reserved.
//

import UIKit

final class SolarSystemViewController: UIViewController {
    private enum Sun {
        static let radius: CGFloat = 50
    }
    
    private enum Earth {
        static let radius: CGFloat = 20
        static let key = "earthOrbit"
        
        enum Ellipse {
            static let radius: CGFloat = 120
        }
    }
    
    private enum Moon {
        static let radius: CGFloat = 15
        static let key = "moonOrbit"
        
        enum Ellipse {
            static let radius: CGFloat = 40
        }
    }
    
    private func sphereLayer(radius: CGFloat, color: UIColor, at point: CGPoint) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: radius*2, height: radius*2), cornerRadius: radius).cgPath
        circleLayer.position = point
        circleLayer.fillColor = color.cgColor
        return circleLayer
    }
    
    private func addRotation(to layer: CAShapeLayer, ellipseRadius: CGFloat, duration: CFTimeInterval, key: String) {
        let boundingRect = CGRect(x:-ellipseRadius, y: -ellipseRadius, width: ellipseRadius*2, height: ellipseRadius*2)
        let orbit = CAKeyframeAnimation(keyPath: "animation")
        orbit.keyPath = "position"
        orbit.path = CGPath(ellipseIn: boundingRect, transform: nil)
        orbit.duration = duration
        orbit.isAdditive = true
        orbit.repeatCount = .greatestFiniteMagnitude
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.rotationMode = CAAnimationRotationMode.rotateAuto
        layer.add(orbit, forKey: key)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let sunLayer = sphereLayer(radius: Sun.radius, color: .orange, at: CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2))
        view.layer.addSublayer(sunLayer)
        
        let earthLayer = sphereLayer(radius: Earth.radius, color: .blue, at: CGPoint(x: Sun.radius, y: Sun.radius))
        addRotation(to: earthLayer, ellipseRadius: Earth.Ellipse.radius, duration: 4, key: Earth.key)
        sunLayer.addSublayer(earthLayer)
        
        let moonLayer = sphereLayer(radius: Moon.radius, color: .brown, at: CGPoint(x: Earth.radius, y: Earth.radius))
        addRotation(to: moonLayer, ellipseRadius: Moon.Ellipse.radius, duration: 2, key: Moon.key)
        earthLayer.addSublayer(moonLayer)
        
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
        animation.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateX)
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.both
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.repeatCount = .greatestFiniteMagnitude
    }
}
