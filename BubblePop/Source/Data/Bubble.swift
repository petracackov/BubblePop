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
        self.color = convertToColor(from: entity.color)
        self.scale = entity.size
        self.createdAt = entity.createdAt
        self.poppedAt = entity.poppedAt
    }
    
    override func c_writeDataToEntity() {
        super.c_writeDataToEntity()
        guard let entity = entity as? BubbleEntity else { return }
        entity.title = self.title
        entity.details = self.description
        entity.color = convertToRGBAComponents(from: self.color)
        entity.size = self.scale
        entity.createdAt = self.createdAt
        entity.poppedAt = self.poppedAt
    }
    
    private func convertToColor(from rgba: [Double]?) -> UIColor {
        guard let rgba = rgba, rgba.count == 4 else { return UIColor.purple }
        let red = CGFloat(rgba[0])
        let green = CGFloat(rgba[1])
        let blue = CGFloat(rgba[2])
        let alpha = CGFloat(rgba[3])
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private func convertToRGBAComponents(from color: UIColor?) -> [Double]  {
        let color = color ?? UIColor.purple
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [Double(red), Double(green), Double(blue), Double(alpha)]
    }
}
