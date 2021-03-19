//
//  BubbleColor.swift
//  BubblePop
//
//  Created by Petra Čačkov on 26/01/2021.
//

import UIKit

class BubbleColor: DatabaseEntity {
    var color: UIColor = .systemPurple
    //var bubbles: [Bubble] = []

    
    override func c_fetchDataFromEntity() {
        super.c_fetchDataFromEntity()
        guard let entity = entity as? BubbleColorEntity else { return }
        color = ColorTools.convertToColor(from: entity.color)
        
    }
    
    override func c_writeDataToEntity() {
        super.c_writeDataToEntity()
        guard let entity = entity as? BubbleColorEntity else { return }
        entity.color = ColorTools.convertToRGBAComponents(from: color)
    }
    
    //  TODO
    func fetchBubbles() {
        
    }
    
}
