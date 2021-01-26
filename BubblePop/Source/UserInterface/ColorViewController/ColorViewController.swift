//
//  ColorViewController.swift
//  BubblePop
//
//  Created by Petra Čačkov on 25/01/2021.
//

import UIKit

class ColorViewController: UIViewController {

    @IBOutlet private var bubbleView: AppView?
    @IBOutlet private var redSlider: UISlider?
    @IBOutlet private var greenSlider: UISlider?
    @IBOutlet private var blueSlider: UISlider?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func redSliderDidChange(_ sender: UISlider) {
    }
    
    @IBAction private func greenSliderDidChange(_ sender: UISlider) {
    }
    
    @IBAction private func blueSliderDidChange(_ sender: UISlider) {
    }
    
}
