//
//  CustomButton.swift
//  ARuler
//
//  Created by Wei Chieh Tseng on 23/08/2017.
//  Copyright © 2017 Willjay. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = bounds.width / 2
    }

}
