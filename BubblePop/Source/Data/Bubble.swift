//
//  Bubble.swift
//  BubblePop
//
//  Created by Petra Čačkov on 27/12/2020.
//

import UIKit

class Bubble: DatabaseEntity {
    var title: String?
    var description: String?
    var color: UIColor = .systemPurple
    var scale: Double = 0.5
    var createdAt: Date?
    var poppedAt: Date?
    
    override func c_fetchDataFromEntity() {
        super.c_fetchDataFromEntity()
        guard let entity = entity as? BubbleEntity else { return }
        self.title = entity.title
        self.description = entity.details
        self.color = ColorTools.convertToColor(from: entity.color)
        self.scale = entity.size
        self.createdAt = entity.createdAt
        self.poppedAt = entity.poppedAt
    }
    
    override func c_writeDataToEntity() {
        super.c_writeDataToEntity()
        guard let entity = entity as? BubbleEntity else { return }
        if self.createdAt == nil {
            self.createdAt = Date()
        }
        entity.title = self.title
        entity.details = self.description
        entity.color = ColorTools.convertToRGBAComponents(from: self.color)
        entity.size = self.scale
        entity.poppedAt = self.poppedAt
        entity.createdAt = self.createdAt
    }
}
