//
//  DetailController.swift
//  Jmagine
//
//  Created by hamza on 20/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//


import UIKit
import SideMenu
import Alamofire
import XMLParsing
import SwiftyXMLParser

class ThemeController: UITableViewController, UINavigationControllerDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var themeList = [String: XML.Accessor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        initNavOptions()
        view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: NavmenuController())
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    @objc func openMenu(sender: UIButton!) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initNavOptions() {
        let closeImage = UIImage(named:"ic_menu")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titleLabel
        titleLabel.text = "Thèmes"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        let nextButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(openMenu))
        nextButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = nextButton
    }
    
    func getAllThemes(completion : @escaping (_ dataXML:XML.Accessor) -> ()){
        Alamofire.request("http://jmagine.tokidev.fr/api/themes/get_all")
            .responseData { response in
                if let data = response.data {
                    var themeData:XML.Accessor
                    let xml = XML.parse(data)
                    themeData = xml.list.theme
                    completion(themeData)
                }
        }
    }
    func getThemes(data:XML.Accessor) {
        
        for theme in data {
            themeList[theme.title.text!] = theme
            print(theme)
        }
        
    }
    func getData(){
        self.getAllThemes(){ (dataXML) in
            self.getThemes(data: dataXML)
            // print(dataXML.description,"dataxml")
        }
    }
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
    
}

