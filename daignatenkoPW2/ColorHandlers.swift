//
//  ColorHandlers.swift
//  daignatenkoPW2
//
//  Created by Dmitriy Ignatenko on 10/31/23.
//
import UIKit

extension UIColor {
    var redValue: CGFloat {
        var red: CGFloat = 0
        self.getRed(&red, green: nil, blue: nil, alpha: nil)
        return red
    }
    
    var greenValue: CGFloat {
        var green: CGFloat = 0
        self.getRed(nil, green: &green, blue: nil, alpha: nil)
        return green
    }
    
    var blueValue: CGFloat{
        var blue: CGFloat = 0
        self.getRed(nil, green: nil, blue: &blue, alpha: nil)
        return blue
    }
    
    var redValue255: Int {
            var red: CGFloat = 0
            self.getRed(&red, green: nil, blue: nil, alpha: nil)
            return Int(red * 255)
        }
        
    var greenValue255: Int {
        var green: CGFloat = 0
        self.getRed(nil, green: &green, blue: nil, alpha: nil)
        return Int(green * 255)
    }
        
    var blueValue255: Int{
        var blue: CGFloat = 0
        self.getRed(nil, green: nil, blue: &blue, alpha: nil)
        return Int(blue * 255)
    }
    
}


