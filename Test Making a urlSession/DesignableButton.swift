//
//  DesignableButton.swift
//  learn ibdesinables
//
//  Created by Steven Hertz on 11/17/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

@IBDesignable class DesignableButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius:  CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
