//
//  UIView+.swift
//  ToDoProject
//
//  Created by ozgun on 7.02.2022.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius : CGFloat{
        get { return self.cornerRadius}
        set { self.layer.cornerRadius = newValue}
    }
    func addShadowAndCornerRadius() {
        layer.cornerRadius = 10
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
//        layer.shadowColor = UIColor.darkGray.cgColor
    }
}
