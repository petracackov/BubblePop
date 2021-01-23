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
    
    private var selectedColor: UIColor = .systemPurple
    private var currentPriority: Double = 0.5
    
    weak var delegate: NewBubbleViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
        descriptionTextView?.textContainer.maximumNumberOfLines = 0
        descriptionTextView?.textContainer.lineBreakMode = .byTruncatingTail
        purpleButton?.shadowColor = .clear
        refreshUI()
    }
    
    @objc private func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction private func dismissController(_ sender: Any) {
        dismissController()
    }
    @IBAction private func create(_ sender: Any) {
        guard titleTextField?.text?.isEmpty == false else { return }
        let bubble = Bubble()
        bubble.color = selectedColor
        bubble.title = titleTextField?.text
        bubble.description = descriptionTextView?.text
        bubble.scale = currentPriority
        bubble.createdAt = Date()
        bubble.saveToDatabase {
            self.delegate?.newBubbleViewControllerDidAddNewItem(self)
            self.dismissController()
        }
    }
    @IBAction private func colorButtonPressed(_ sender: AppButton) {
        [purpleButton, redButton, blueButton, greenButton, yellowButton].forEach { $0?.shadowColor = .black }
        sender.shadowColor = .clear
        if let selectedColor = sender.backgroundColor {
            self.selectedColor = selectedColor
        }
        refreshUI()
    }
    
    
    @IBAction private func descriptionTextFViewSelected(_ sender: Any) {
        
        descriptionTextView?.becomeFirstResponder()
    }
    
    @IBAction private func sliderValueChanged(_ sender: UISlider) {
        currentPriority = Double(sender.value)
    }
    
    private func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func refreshUI() {
        slider?.minimumTrackTintColor = selectedColor
        descriptionBubbleView?.backgroundColor = selectedColor
        titleBubbleView?.backgroundColor = selectedColor
        createButton?.backgroundColor = selectedColor
        dismissButton?.backgroundColor = selectedColor
    }
}
