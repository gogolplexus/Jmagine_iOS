//
//  CustomUIButton.swift
//  Jmagine
//
//  Created by mbds on 24/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import Foundation
import UIKit

class CustomUIButton: UIButton{
    var params: Dictionary<String, Any>
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}
