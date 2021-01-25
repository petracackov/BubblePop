//
//  BubbleDetailsViewController.swift
//  BubblePop
//
//  Created by Petra Čačkov on 27/12/2020.
//

import UIKit

class BubbleDetailsViewController: UIViewController {

    @IBOutlet private var blurView: UIVisualEffectView?
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var descriptionLabel: UILabel?
    @IBOutlet private var popButton: AppButton?
    @IBOutlet private var bubbleView: AppView?
    
    var bubble: Bubble? 
    
    weak var bubbleDelegate: NewBubbleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blurView?
            .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // If user edited the bubble data it should refresh when coming back from edit screen
        refresh()
    }
    
    @IBAction private func popBubble(_ sender: Any) {
        guard let bubble = bubble else { return }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewBubbleViewController") as! NewBubbleViewController
        controller.bubble = bubble
        controller.delegate = bubbleDelegate
        navigationController?.pushViewController(controller, animated: true)

    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refresh() {
        guard let bubble = bubble else { return }
        titleLabel?.text = bubble.title
        descriptionLabel?.text = bubble.description
        bubbleView?.backgroundColor = bubble.color
        popButton?.backgroundColor = bubble.color
    }

    
    
}
