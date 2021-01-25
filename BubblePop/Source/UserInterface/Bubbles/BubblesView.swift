//
//  BubblesView.swift
//  BubblePop
//
//  Created by Petra Čačkov on 31/12/2020.
//

import SpriteKit

class BubblesView: SKView {

    private var bubblesScene: BubblesScene?
    private var currentBubbleNodes: [BubbleNode] { bubblesScene?.children.filter { $0 is BubbleNode } as? [BubbleNode] ?? [] }
    
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
        // TODO: make scene so big that all bubbles fit
        bubblesScene = BubblesScene(size: bounds.size)
        bubblesScene?.scaleMode = .aspectFill
        bubblesScene?.backgroundColor = .systemBackground
        bubblesScene?.bubblesSceneDelegate = bubblesSceneDelegate
        self.presentScene(bubblesScene)
    }
    
    func addBubble(_ bubble: Bubble, inMiddle: Bool = false) {
        let bubbleNode = BubbleNode(bubble: bubble)
        if inMiddle {
            bubbleNode.position = CGPoint(x: (bubblesScene?.size.width ?? 0)/2 - 25, y: (bubblesScene?.size.height ?? 0)/2 - 25)
        } else if currentBubbleNodes.count % 2 == 0 {
            let rand = CGFloat.random(in: 0...(bubblesScene?.size.height ?? 0))
            bubbleNode.position = CGPoint(x: 0, y: rand)
        } else {
            let rand = CGFloat.random(in: 0...(bubblesScene?.size.height ?? 0))
            bubbleNode.position = CGPoint(x: (bubblesScene?.size.width ?? 0), y: rand)
        }
        bubblesScene?.addChild(bubbleNode)
    }
    
    func updateBubble(_ bubble: Bubble) {
        currentBubbleNodes.first { $0.bubble?.id == bubble.id }?.replaceBubble(with: bubble)
    }
    
    func removeBubble(_ bubble: Bubble) {
        currentBubbleNodes.first { $0.bubble?.id == bubble.id }?.removeBubbleFromScene()
    }
    
}
