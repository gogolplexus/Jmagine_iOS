//
//  CustomColors.swift
//  Jmagine
//
//  Created by mbds on 13/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit

public extension UIColor {
    //Some inits (not from me)
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    //Some inits (not from me)
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    //Our custom colors
    struct JmagineColors {
        
        struct Blue {
            static let MainBlue = UIColor(netHex: 0x5AC8FA)
        }
        
        struct Green {
            static let MainGreen = UIColor(netHex: 0x4CD964)
        }
        
        struct Gray {
            static let MainGray = UIColor(netHex: 0xC7C7CC)
        }
        
        struct Dark {
            static let MainDark = UIColor(netHex: 0x1E1E1E)
        }
    }
}
