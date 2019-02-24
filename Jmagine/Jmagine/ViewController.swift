//
//  ViewController.swift
//  Jmagine
//
//  Created by mbds on 24/02/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import LGSideMenuController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "LGSideMenuController"
        
        view.backgroundColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Left", style: .plain, target: self, action: #selector(showLeftView(sender:)))
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func showLeftView(sender: AnyObject?) {
        sideMenuController?.showLeftView(animated: true, completionHandler: nil)
    }
}
