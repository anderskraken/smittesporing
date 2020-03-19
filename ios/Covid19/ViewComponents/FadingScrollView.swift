//
//  FadingScrollView.swift
//  Covid19
//
//  Created by Lars-Erik Kasin on 18/03/2020.
//  Copyright © 2020 Agens. All rights reserved.
//

import UIKit

class FadingScrollView: UIScrollView {

    private final let clear = UIColor.clear.cgColor
    private final let black = UIColor.black.cgColor
    private final let maxFadeSize = CGFloat(40)
    private final let maxFadeOffset = CGFloat(36)

    enum FadingEdges {
        case vertical
        case horizontal
        case top
        case bottom
        case left
        case right
        case none
    }

    enum Direction {
        case horizonal
        case vertical
        case all
    }

    var scrollDirection: Direction
    var fadingEdges = FadingEdges.none
    
    override var contentOffset: CGPoint {
        didSet {
            if scrollDirection == .horizonal && contentOffset.y != 0 {
                contentOffset.y = 0
            } else if scrollDirection == .vertical && contentOffset.x != 0 {
                contentOffset.x = 0
            }
        }
    }
    
    convenience init(direction: Direction = .all) {
        self.init(fadingEdges: .none, direction: direction)
    }
    
    init(fadingEdges: FadingEdges, direction: Direction = .all) {
        self.scrollDirection = direction
        self.fadingEdges = fadingEdges
        super.init(frame: .zero)
        self.delaysContentTouches = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard fadingEdges != .none else {
            return
        }
        
        let maskLayer = CALayer()
        maskLayer.frame = self.bounds
        
        if [FadingEdges.horizontal, .left, .right].contains(fadingEdges) {
            maskLayer.addSublayer(makeHorizontalFade())
        } else {
            maskLayer.addSublayer(makeVerticalFade())
        }
        
        self.layer.mask = maskLayer
    }
    
    private func makeVerticalFade() -> CAGradientLayer {
        let overShoot = contentSize.height - frame.height - contentOffset.y
        let topFade = fadingEdges == .bottom ? 0 : Double(maxFadeSize/frame.height * max(0, min(1, contentOffset.y/maxFadeOffset)))
        let bottomFade = fadingEdges == .top ? 0 : Double(maxFadeSize/frame.height * max(0, min(1, overShoot/maxFadeOffset)))

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: frame.size)
        gradientLayer.colors = [clear, black, black, clear]
        gradientLayer.locations = [0, NSNumber(floatLiteral: topFade), NSNumber(floatLiteral: Double(1 - bottomFade)), 1]
        return gradientLayer
    }
    
    private func makeHorizontalFade() -> CAGradientLayer {
        let overShoot = contentSize.width - frame.width - contentOffset.x
        let leftFade = fadingEdges == .right ? 0 : Double(maxFadeSize/frame.width * max(0, min(1, contentOffset.x/maxFadeOffset)))
        let rightFade = fadingEdges == .left ? 0 : Double(maxFadeSize/frame.width * max(0, min(1, overShoot/maxFadeOffset)))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = CGRect(origin: .zero, size: frame.size)
        gradientLayer.colors = [clear, black, black, clear]
        gradientLayer.locations = [0, NSNumber(floatLiteral: leftFade), NSNumber(floatLiteral: 1 - rightFade), 1]
        return gradientLayer
    }
}
