//
//  Extensions.swift
//  Weather
//
//  Created by Louie McConnell on 10/9/17.
//  Copyright © 2017 Louie McConnell. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = #imageLiteral(resourceName: "Weather")
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}
