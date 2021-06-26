//
//  ColorCollectionViewCell.swift
//  BubblePop
//
//  Created by Petra Čačkov on 25/01/2021.
//

import UIKit

protocol ColorCollectionViewCellDelegate: class {
    func colorCollectionViewCell(_ sender: ColorCollectionViewCell, didSelectColor color: BubbleColor)
}

class ColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var colorButton: AppButton?
    
    weak var delegate: ColorCollectionViewCellDelegate?
    
    var bubbleColor: BubbleColor? {
        didSet { reload() }
    }
    
    var isPressedDown: Bool = false {
        didSet { reload() }
    }
    
    private func reload() {
        colorButton?.backgroundColor = bubbleColor?.color
        colorButton?.shadowColor = isPressedDown ? .clear : .black
    }
    
    @IBAction private func didSelectColor(_ sender: Any) {
        guard let bubbleColor = bubbleColor else { return }
        delegate?.colorCollectionViewCell(self, didSelectColor: bubbleColor)
    }
    
    
}
