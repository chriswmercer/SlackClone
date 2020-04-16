//
//  CircleImageView.swift
//  Smack
//
//  Created by Chris Mercer on 16/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView {

    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
