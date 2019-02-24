//
//  NavigationController.swift
//  Jmagine
//
//  Created by mbds on 24/02/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import LGSideMenuController

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .white
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden : Bool {
        return UIDevice.current.orientation.isLandscape && UI_USER_INTERFACE_IDIOM() == .phone
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return sideMenuController!.isRightViewVisible ? .slide : .fade
    }
    
}
