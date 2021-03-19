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
    @IBOutlet private var colorsContentView: UIView?
    @IBOutlet private var colorsContentViewTrailingConstraint: NSLayoutConstraint?
    @IBOutlet private var colorsContentViewHeight: NSLayoutConstraint?
    @IBOutlet private var colorsCollectionView: UICollectionView?
    @IBOutlet private var colorSelectionButton: UIButton?
    
    private var data: [Bubble]?
    private var colours: [BubbleColor] = [] {
        didSet { print(colours.map { $0.color })}
    }
    private var colorsAreExpanded: Bool = false {
        didSet { animateColorSelectionView() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubblesView?.bubblesSceneDelegate = self
        colorsAreExpanded = false
        
        colorsContentView?.clipsToBounds = false
        colorsContentView?.layer.cornerRadius = 10
        colorsContentView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        reloadData()
    }

    @IBAction func colorSelectionButtonPressed(_ sender: Any) {
        colorsAreExpanded.toggle()
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
            self.refreshBubbles()
        }
        BubbleColor.fetchAllObjects { (colours, error) in
            if let colours = colours as? [BubbleColor] { self.colours = colours }
            self.colorsCollectionView?.reloadData()
        }
    }
    
    private func refreshBubbles() {
        data?.forEach { bubble in
            self.bubblesView?.removeBubble(bubble)
            self.bubblesView?.addBubble(bubble)
        }
    }
    
    private func animateColorSelectionView() {
        colorsContentView?.layer.cornerRadius = 10
        colorsContentView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        UIView.animate(withDuration: 2) {
            if self.colorsAreExpanded {
                self.colorsContentViewTrailingConstraint?.constant = self.view.bounds.width - (self.colorsContentView?.bounds.width ?? 0)
                self.colorSelectionButton?.transform = CGAffineTransform(rotationAngle: .pi)
//                self.colorsContentView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            } else {
                self.colorsContentViewTrailingConstraint?.constant = 0
                self.colorSelectionButton?.transform = .identity
//                self.colorsContentView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            }
            self.view.layoutIfNeeded()
        } completion: { (_) in
            
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.color = colours[indexPath.item].color
        //cell.isPressedDown = color == bubble.color.color
        cell.delegate = self
        return cell
    }
}

extension ViewController: ColorCollectionViewCellDelegate {
    func colorCollectionViewCell(_ sender: ColorCollectionViewCell, didSelectColor color: UIColor) {
//        bubble.color.color = color
//        colorsCollectionView?.reloadData()
//        refreshColors()
    }
}
