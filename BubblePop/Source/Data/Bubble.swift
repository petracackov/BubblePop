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
    var color: BubbleColor = BubbleColor()
    var scale: Double = 0.5
    var createdAt: Date?
    var poppedAt: Date?

    convenience init(title: String, description: String) {
        self.init()
        self.title = title
        self.description = description
    }

    override func c_fetchDataFromEntity() {
        super.c_fetchDataFromEntity()
        guard let entity = entity as? BubbleEntity else { return }
        self.title = entity.title
        self.description = entity.details
        self.scale = entity.size
        self.createdAt = entity.createdAt
        self.poppedAt = entity.poppedAt
        if let colorEntity = entity.color {
            self.color = BubbleColor(entity: colorEntity)
        }
    }
    
    override func c_writeDataToEntity() {
        super.c_writeDataToEntity()
        guard let entity = entity as? BubbleEntity else { return }
        if self.createdAt == nil {
            self.createdAt = Date()
        }
        entity.title = self.title
        entity.details = self.description
        entity.size = self.scale
        entity.poppedAt = self.poppedAt
        entity.createdAt = self.createdAt
        
        entity.color = {
//            if let currentEntity = entity.color {
//                color.injectEntity(entity: currentEntity)
//            }
            color.c_writeDataToEntity()
            return color.entity as? BubbleColorEntity
        }()
    }
}
