//
//  ColorTools.swift
//  BubblePop
//
//  Created by Petra Čačkov on 26/01/2021.
//

import UIKit

class ColorTools: UICollectionViewCell {
    
    static func convertToColor(from rgba: [Double]?) -> UIColor {
        guard let rgba = rgba, rgba.count == 4 else { return UIColor.purple }
        let red = CGFloat(rgba[0])
        let green = CGFloat(rgba[1])
        let blue = CGFloat(rgba[2])
        let alpha = CGFloat(rgba[3])
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func getRGBAColor(from color: UIColor?) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        guard let color = color else { return nil }
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    static func convertToRGBAComponents(from color: UIColor?) -> [Double]  {
        let color = color ?? UIColor.purple
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [Double(red), Double(green), Double(blue), Double(alpha)]
    }
    
}
