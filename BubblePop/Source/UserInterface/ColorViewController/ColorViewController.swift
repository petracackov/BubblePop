//
//  ColorViewController.swift
//  BubblePop
//
//  Created by Petra Čačkov on 25/01/2021.
//

import UIKit

protocol ColorViewControllerDelegate: class {
    func colorViewController(_ sender: ColorViewController, didAddColor color: UIColor)
}

class ColorViewController: UIViewController {

    @IBOutlet private var bubbleView: AppView?
    @IBOutlet private var redSlider: UISlider?
    @IBOutlet private var greenSlider: UISlider?
    @IBOutlet private var blueSlider: UISlider?
    @IBOutlet private var dismissButton: AppButton?
    @IBOutlet private var confirmButton: AppButton?
    
    weak var delegate: ColorViewControllerDelegate?
    
    private var currentColor: UIColor? {
        didSet { updateColorsUI() }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentColor = .systemBlue
        if let rgbaColors = ColorTools.getRGBAColor(from: currentColor) {
            redSlider?.value = Float(rgbaColors.red)
            blueSlider?.value = Float(rgbaColors.blue)
            greenSlider?.value = Float(rgbaColors.green)
        }
        
    }
    
    @IBAction private func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func redSliderDidChange(_ sender: UISlider) {
        if let color = ColorTools.getRGBAColor(from: currentColor) {
            currentColor = UIColor(red: CGFloat(sender.value), green: color.green, blue: color.blue, alpha: color.alpha)
        }
        
    }
    
    @IBAction private func greenSliderDidChange(_ sender: UISlider) {
        if let color = ColorTools.getRGBAColor(from: currentColor) {
            currentColor = UIColor(red: color.red, green: CGFloat(sender.value), blue: color.blue, alpha: color.alpha)
        }
    }
    
    @IBAction private func blueSliderDidChange(_ sender: UISlider) {
        if let color = ColorTools.getRGBAColor(from: currentColor) {
            currentColor = UIColor(red: color.red, green: color.green, blue: CGFloat(sender.value), alpha: color.alpha)
        }
    }
    
    @IBAction private func confirmButtonPressed(_ sender: Any) {
        if let color = currentColor {
            delegate?.colorViewController(self, didAddColor: color)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func updateColorsUI() {
        bubbleView?.backgroundColor = currentColor
        dismissButton?.backgroundColor = currentColor
        confirmButton?.backgroundColor = currentColor
    }
}
