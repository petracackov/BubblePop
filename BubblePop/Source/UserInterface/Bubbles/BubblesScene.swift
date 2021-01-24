//
//  BubblesScene.swift
//  BubblePop
//
//  Created by Petra Čačkov on 31/12/2020.
//

import SpriteKit

protocol BubblesSceneDelegate: class {
    func bubblesScene(_ sender: BubblesScene, didSelect bubble: Bubble)
    func bubblesScene(_ sender: BubblesScene, didRemove bubble: Bubble)
}

class BubblesScene: SKScene {

    private var gravity: SKFieldNode?
    
    private var currentBubbleSelected: BubbleNode?
    private var draggingInProgress: Bool = false
    private let longPressTimeDuration: TimeInterval = 1.0
    private var touchTimer: Timer?
    private var currentTimeDuration: TimeInterval = 1.0
    private var touchEventInProgress: Bool = false {
        didSet {
            guard touchEventInProgress != oldValue else { return }
            handleTouchEvent()
        }
    }
    
    weak var bubblesSceneDelegate: BubblesSceneDelegate?
    
    override init(size: CGSize) {
        super.init(size: size)
        addGravity()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGravity()
    }
    
    private func addGravity() {
        gravity?.removeFromParent()
        let gravity = SKFieldNode.radialGravityField()
        let radius: Float = Float((pow(size.width, 2) + pow(size.height, 2)).squareRoot()/2)
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)

        gravity.region = SKRegion(radius: radius)
        gravity.minimumRadius = radius
        gravity.strength = 100
        gravity.position = CGPoint(x: (size.width / 2)-25, y: size.height / 2)
        self.gravity = gravity
        self.addChild(gravity)
    }
    
    private func resetTimer() {
        currentTimeDuration = longPressTimeDuration
        currentBubbleSelected = nil
        touchTimer?.invalidate()
    }
    
    private func handleTouchEvent() {
        if touchEventInProgress {
            touchTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
                self.currentTimeDuration -= 0.1
                if self.currentTimeDuration <= 0.0 {
                    if let currentBubble = self.currentBubbleSelected?.bubble {
                        self.currentBubbleSelected?.removeBubbleFromScene()
                        self.bubblesSceneDelegate?.bubblesScene(self, didRemove: currentBubble)
                    }
                    self.touchEventInProgress = false
                }
            })
        } else if touchEventInProgress == false {
            resetTimer()
        }
    }
    
    private func bubbleAt(location: CGPoint?) -> BubbleNode? {
        guard let location = location else { return nil }
        return nodes(at: location).compactMap { $0 as? BubbleNode }.filter { $0.path?.contains(convert(location, to: $0)) ?? false }.first
    }
}

extension BubblesScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentBubbleSelected = bubbleAt(location: touches.first?.location(in: self))
        touchEventInProgress = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let previous = touch.previousLocation(in: self)
        let delta = CalculationTools.delta(lhs: location, rgh: previous)
        if CalculationTools.distance(from: previous, to: location) > 0.0 {
            // TODO: add some break so user can't scroll to infinite
            touchEventInProgress = false
            draggingInProgress = true
            for node in children {
                if node == self.gravity {
                    gravity?.position.x += delta.x
                    gravity?.position.y += delta.y
                } else if node is BubbleNode {
                    let distance = CalculationTools.distance(from: location, to: node.position)
                    let acceleration: CGFloat = 3 * pow(distance, 1/2)
                    let direction = CGVector(dx: delta.x * acceleration, dy: delta.y * acceleration)
                    node.physicsBody?.applyForce(direction)
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: detect tap
        if touchEventInProgress, draggingInProgress == false, let currentBubble = currentBubbleSelected?.bubble {
            print("touch detected")
            bubblesSceneDelegate?.bubblesScene(self, didSelect: currentBubble)
        } else {
            print("long press or drag detected")
        }
        touchEventInProgress = false
        draggingInProgress = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEventInProgress = false
        draggingInProgress = false
    }
}
