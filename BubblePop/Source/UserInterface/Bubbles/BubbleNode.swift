//
//  BubbleNode.swift
//  BubblePop
//
//  Created by Petra Čačkov on 31/12/2020.
//

import SpriteKit



class BubbleNode: SKShapeNode {

    private var bubbleTitleLabel: SKLabelNode?
    private(set) var bubble: Bubble?
    
    init(bubble: Bubble) {
        super.init()
        self.bubble = bubble
        let size: CGFloat = CGFloat(100 + bubble.scale*100)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size)).cgPath
        self.path = path
        self.fillColor = bubble.color
        self.lineWidth = 0
        updatePhysicsBody(path: path)
        
        bubbleTitleLabel = {
            let label = SKLabelNode(text: bubble.title)
            label.horizontalAlignmentMode = .center
            label.lineBreakMode = .byCharWrapping
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = size/2 * sqrt(2)
            label.verticalAlignmentMode = .center
            label.fontColor = .black
            label.fontSize = 20
            label.position = CGPoint(x: size/2, y: size/2)
            addChild(label)
            return label
        }()
        adjustFontToFitTheFrame()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func adjustFontToFitTheFrame() {
        guard let bubbleTitleLabel = bubbleTitleLabel else { return }
        let scalingFactor = min(frame.width / bubbleTitleLabel.frame.width, frame.height / bubbleTitleLabel.frame.height, 1)
        bubbleTitleLabel.fontSize *= scalingFactor
        bubbleTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    private func updatePhysicsBody(path: CGPath) {
        self.physicsBody = {
          var transform = CGAffineTransform.identity.scaledBy(x: CGFloat(1.01), y: CGFloat(1.01))
          let body = SKPhysicsBody(polygonFrom: path.copy(using: &transform)!)
          body.allowsRotation = false
          body.friction = 0
          body.linearDamping = 3
          return body
        }()
        
    }
    
    // TODO: add animation
    func removeBubbleFromScene(animated: Bool = false) {
        self.removeFromParent()
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
}

