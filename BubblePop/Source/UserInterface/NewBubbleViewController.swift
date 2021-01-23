//
//  NewBubbleViewController.swift
//  BubblePop
//
//  Created by Petra Čačkov on 27/12/2020.
//

import UIKit

protocol NewBubbleViewControllerDelegate: class {
    func newBubbleViewControllerDidAddNewItem(_ sender: NewBubbleViewController)
}

class NewBubbleViewController: UIViewController {

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var titleBubbleView: AppView?
    @IBOutlet private var titleTextField: UITextField?
    @IBOutlet private var descriptionBubbleView: AppView?
    @IBOutlet private var descriptionTextView: UITextView?
    @IBOutlet private var createButton: AppButton?
    @IBOutlet private var purpleButton: AppButton?
    @IBOutlet private var redButton: AppButton?
    @IBOutlet private var blueButton: AppButton?
    @IBOutlet private var greenButton: AppButton?
    @IBOutlet private var yellowButton: AppButton?
    @IBOutlet private var sliderBubbleView: AppView?
    @IBOutlet private var slider: UISlider?
    @IBOutlet private var dismissButton: AppButton?
    @IBOutlet private var backButton: AppButton?
    
    weak var delegate: NewBubbleViewControllerDelegate?
    
    var bubble: Bubble = Bubble()
    private var state: State {
        return bubble.createdAt != nil ? .edit : .new
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
        descriptionTextView?.textContainer.maximumNumberOfLines = 0
        descriptionTextView?.textContainer.lineBreakMode = .byTruncatingTail
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
        bubble.saveToDatabase {
            self.delegate?.newBubbleViewControllerDidAddNewItem(self)
            self.closeController()
        }
    }
    
    @IBAction private func colorButtonPressed(_ sender: AppButton) {
        if let selectedColor = sender.backgroundColor {
            bubble.color = selectedColor
            refreshUI()
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
    
    private func refreshUI() {
        slider?.minimumTrackTintColor = bubble.color
        descriptionBubbleView?.backgroundColor = bubble.color
        titleBubbleView?.backgroundColor = bubble.color
        createButton?.backgroundColor = bubble.color
        dismissButton?.backgroundColor = bubble.color
        backButton?.backgroundColor = bubble.color
        [purpleButton, redButton, blueButton, greenButton, yellowButton].forEach { button in
            button?.shadowColor = button?.backgroundColor == bubble.color ? .clear : .black
        }
    }
    
    private func reload() {
        titleTextField?.text = bubble.title
        descriptionTextView?.text = bubble.description
        slider?.value = Float(bubble.scale)
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
        refreshUI()
    }
}

private extension NewBubbleViewController {
    enum State {
        case new
        case edit
    }
}
