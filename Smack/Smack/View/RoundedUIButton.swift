//
//  RoundedUIButton.swift
//  Smack
//
//  Created by Chris Mercer on 15/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedUIButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
