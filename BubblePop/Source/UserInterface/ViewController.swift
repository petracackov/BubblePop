//
//  ViewController.swift
//  BubblePop
//
//  Created by Petra Čačkov on 27/12/2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var bubblesView: BubblesView?
    @IBOutlet private var addBubbleButton: AppButton?
    
    private var data: [Bubble]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubblesView?.bubblesSceneDelegate = self
        reloadData()
    }

    @IBAction private func addNewBubble(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewBubbleViewController") as! NewBubbleViewController
        controller.delegate = self
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
       
    }
    
    private func reloadData() {
        Bubble.fetchAllObjects { (objects, error) in
            self.data = objects as? [Bubble]
            self.addAllBubbles()
        }
    }
    
    private func addAllBubbles() {
        // TODO: remove all bubbles
        data?.forEach { bubble in
            self.bubblesView?.addBubble(bubble)
        }
    }
    
}

extension ViewController: NewBubbleViewControllerDelegate {
    func newBubbleViewController(_ sender: NewBubbleViewController, didAddNewBubble bubble: Bubble) {
        data?.append(bubble)
        bubblesView?.addBubble(bubble, inMiddle: true)
    }
    
    func newBubbleViewController(_ sender: NewBubbleViewController, didChangeBubble bubble: Bubble) {
        bubblesView?.updateBubble(bubble)
    }
    
    
}

extension ViewController: BubblesSceneDelegate {
    func bubblesScene(_ sender: BubblesScene, didSelect bubble: Bubble) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "BubbleDetailsViewController") as! BubbleDetailsViewController
        controller.bubble = bubble
        controller.bubbleDelegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.isNavigationBarHidden = true
        present(navigationController, animated: true, completion: nil)
    }
    
    func bubblesScene(_ sender: BubblesScene, didRemove bubble: Bubble) {
        bubble.deleteFromDatabase {
            self.data = self.data?.filter { $0.id != bubble.id }
        }
    }
}
