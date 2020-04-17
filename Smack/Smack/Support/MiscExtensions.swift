//
//  MiscExtensions.swift
//  Smack
//
//  Created by Chris Mercer on 16/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

func componentStringToUIColour(components: String) -> UIColor {
    let defaultColour = UIColor.lightGray
    if components == "" { return defaultColour }
    
    let colourStripped = components.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: " ", with: "")
    let colourComponents = colourStripped.components(separatedBy: ",")
    if colourComponents.count < 4 { return defaultColour }

    var r, g, b, a : Float?
    r = Float(colourComponents[0])
    g = Float(colourComponents[1])
    b = Float(colourComponents[2])
    a = Float(colourComponents[3])
    
    guard let rUnwrapped = r else { return defaultColour}
    guard let gUnwrapped = g else { return defaultColour}
    guard let bUnwrapped = b else { return defaultColour}
    guard let aUnwrapped = a else { return defaultColour}
    
    let rFloat = CGFloat(Double(rUnwrapped))
    let gFloat = CGFloat(Double(gUnwrapped))
    let bFloat = CGFloat(Double(bUnwrapped))
    let aFloat = CGFloat(Double(aUnwrapped))
    
    let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
    
    return newUIColor
}
