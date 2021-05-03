//
//  Utilities.swift
//  Shows
//
//  Created by Taral Rathod on 30/04/21.
//

import Foundation
import UIKit

extension UIView {

    private var gradientColorOne: CGColor { get {UIColor(white: 0.75, alpha: 1.0).cgColor} }
    private var gradientColorTwo: CGColor { get {UIColor(white: 0.95, alpha: 1.0).cgColor} }

    func addCornerRadius(radius: CGFloat, borderWidth: Float, borderColor: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

    func startAnimating() -> CAGradientLayer {
        /* Allocate the frame of the gradient layer as the view's bounds, since the layer will sit on top of the view. */
        let gradientLayer = CAGradientLayer()

        /* To make the gradient appear moving from left to right, we are providing it the appropriate start and end points.
         Refer to the diagram above to understand why we chose the following points.
         */
        gradientLayer.frame = self.bounds

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo,   gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        /* Adding the gradient layer on to the view */
        self.layer.addSublayer(gradientLayer)

        /* Adding the animation to the layer on the view */
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.speed = 0.2
        gradientLayer.add(animation, forKey: animation.keyPath)

        return gradientLayer
    }

    func stopAnimation(layer: CAGradientLayer) {
        layer.removeAllAnimations()
        layer.removeFromSuperlayer()
    }
}
