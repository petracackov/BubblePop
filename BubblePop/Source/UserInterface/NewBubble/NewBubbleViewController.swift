//
//  NewBubbleViewController.swift
//  BubblePop
//
//  Created by Petra Čačkov on 27/12/2020.
//

import UIKit

protocol NewBubbleViewControllerDelegate: class {
    func newBubbleViewController(_ sender: NewBubbleViewController, didAddNewBubble bubble: Bubble)
    func newBubbleViewController(_ sender: NewBubbleViewController, didChangeBubble bubble: Bubble)
}

class NewBubbleViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var titleBubbleView: AppView?
    @IBOutlet private var titleTextField: UITextField?
    @IBOutlet private var descriptionBubbleView: AppView?
    @IBOutlet private var descriptionTextView: UITextView?
    @IBOutlet private var createButton: AppButton?
    @IBOutlet private var sliderBubbleView: AppView?
    @IBOutlet private var slider: UISlider?
    @IBOutlet private var dismissButton: AppButton?
    @IBOutlet private var backButton: AppButton?
    @IBOutlet private var colorsCollectionView: UICollectionView?
    
    weak var delegate: NewBubbleViewControllerDelegate?
    
    var bubble: Bubble = Bubble()
    private var selectedColor: BubbleColor = BubbleColor()
    private var state: State = .new
    private var cells: [Cell] = []
    private var colours: [BubbleColor] = [] {
        didSet { generateColorCells() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGestureRecogniser.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecogniser)
        
        descriptionTextView?.textContainer.maximumNumberOfLines = 0
        descriptionTextView?.textContainer.lineBreakMode = .byTruncatingTail
        state = bubble.createdAt != nil ? .edit : .new
        reload()
    }
    
    @objc private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction private func goBack(_ sender: Any) {
        closeController()
    }
    
    @IBAction private func dismissController(_ sender: Any) {
        closeController()
    }
    
    @IBAction private func create(_ sender: Any) {
        guard titleTextField?.text?.isEmpty == false else { return }
        bubble.title = titleTextField?.text
        bubble.description = descriptionTextView?.text
        bubble.color = selectedColor
        bubble.saveToDatabase {
            switch self.state {
            case .new: self.delegate?.newBubbleViewController(self, didAddNewBubble: self.bubble)
            case .edit: self.delegate?.newBubbleViewController(self, didChangeBubble: self.bubble)
            }
            self.closeController()
        }
    }
    
    
    @IBAction private func descriptionTextFViewSelected(_ sender: Any) {
        descriptionTextView?.becomeFirstResponder()
    }
    
    @IBAction private func sliderValueChanged(_ sender: UISlider) {
        bubble.scale = Double(sender.value)
    }
    
    private func closeController() {
        switch state {
        case .new: dismiss(animated: true, completion: nil)
        case .edit: navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func refreshColors() {
        slider?.minimumTrackTintColor = selectedColor.color
        descriptionBubbleView?.backgroundColor = selectedColor.color
        titleBubbleView?.backgroundColor = selectedColor.color
        createButton?.backgroundColor = selectedColor.color
        dismissButton?.backgroundColor = selectedColor.color
        backButton?.backgroundColor = selectedColor.color
    }
    
    private func reload() {
        titleTextField?.text = bubble.title
        descriptionTextView?.text = bubble.description
        slider?.value = Float(bubble.scale)
        selectedColor = bubble.color
        switch state {
        case .new:
            createButton?.setTitle("Create", for: .normal)
            dismissButton?.isHidden = false
            backButton?.isHidden = true
            titleLabel?.text = "NEW BUBBLE"
        case .edit:
            createButton?.setTitle("Confirm", for: .normal)
            dismissButton?.isHidden = true
            backButton?.isHidden = false
            titleLabel?.text = "EDIT BUBBLE"
        }
        fetchColors()
    }
    
    private func generateColorCells() {
        cells.append(.addNewColor)
        if colours.isEmpty {
            cells.append(.color(selectedColor))
        } else {
            cells.append(contentsOf: colours.map { .color($0) })
        }
        colorsCollectionView?.reloadData()
        refreshColors()
    }
    
    private func fetchColors() {
        BubbleColor.fetchAllObjects { (colours, error) in
            if let colours = colours as? [BubbleColor] {
                self.colours = colours
            }
        }
    }
}

private extension NewBubbleViewController {
    enum State {
        case new
        case edit
    }
    enum Cell {
        case color(BubbleColor)
        case addNewColor
    }
}

extension NewBubbleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cells[indexPath.item] {
        case .addNewColor:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddColorCollectionViewCell", for: indexPath) as! AddColorCollectionViewCell
            return cell
        case .color(let color):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            cell.bubbleColor = color
            cell.isPressedDown = color.id == selectedColor.id
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch cells[indexPath.item] {
        case .addNewColor:
            let controller = UIStoryboard(name: "ColorViewController", bundle: nil).instantiateViewController(identifier: "ColorViewController") as! ColorViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            controller.delegate = self
            present(controller, animated: true, completion: nil)
        case .color(_):
            return
        }
    }
}

extension NewBubbleViewController: ColorCollectionViewCellDelegate {
    func colorCollectionViewCell(_ sender: ColorCollectionViewCell, didSelectColor color: BubbleColor) {
        selectedColor = color
        colorsCollectionView?.reloadData()
        refreshColors()
    }
}

extension NewBubbleViewController: ColorViewControllerDelegate {
    func colorViewController(_ sender: ColorViewController, didAddColor color: UIColor) {
        selectedColor = BubbleColor(color)
        cells.insert(.color(selectedColor), at: 1)
        colorsCollectionView?.reloadData()
        refreshColors()
    }
}
