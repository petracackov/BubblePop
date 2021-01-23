//
//  BubblesView.swift
//  BubblePop
//
//  Created by Petra Čačkov on 31/12/2020.
//

import SpriteKit

class BubblesView: SKView {

    private var bubblesScene: BubblesScene?
    
    weak var bubblesSceneDelegate: BubblesSceneDelegate? {
        didSet { bubblesScene?.bubblesSceneDelegate = bubblesSceneDelegate }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addScene()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addScene()
    }
    
    private func addScene() {
        self.backgroundColor = .red
        bubblesScene?.removeFromParent()
        bubblesScene = BubblesScene(size: bounds.size)
        bubblesScene?.scaleMode = .aspectFill
        bubblesScene?.backgroundColor = .systemBackground
        bubblesScene?.bubblesSceneDelegate = bubblesSceneDelegate
        self.presentScene(bubblesScene)
    }
    
    func addBubble(_ bubble: Bubble) {
        let centerr = BubbleNode(bubble: bubble)
        centerr.position = CGPoint(x: (bubblesScene?.size.width ?? 0)/2 - 25, y: (bubblesScene?.size.height ?? 0)/2 - 25)
        bubblesScene?.addChild(centerr)
    }
    
}
