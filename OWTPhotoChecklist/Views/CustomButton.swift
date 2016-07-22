//
//  CustomButton.swift
//  OWTPhotoChecklist
//
//  Created by Keli'i Martin on 7/21/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton
{
    @IBInspectable
    var cornerRadius: CGFloat = 3.0
        {
        didSet
        {
            self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable
    var buttonColor: UIColor = UIColor.lightGrayColor()
        {
        didSet
        {
            self.backgroundColor = buttonColor
        }
    }
}
