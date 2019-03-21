//
//  HomeController.swift
//  Jmagine
//
//  Created by mbds on 26/02/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyXMLParser
import XMLParsing

class HomeController:UITableViewController, UINavigationControllerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    let cellId = "cellId"
    var parcours: [Parcour]=[Parcour]()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        initNavOptions()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: NavmenuController())
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        
        
        createParcourArray()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // Do any additional setup after the view, typically from a nib
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
        
        let nextButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(openMenu))
        nextButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = nextButton
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titleLabel
        titleLabel.text = "Liste des Parcours"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let currentLastItem = parcours[indexPath.row]
        cell.textLabel?.text = currentLastItem.parcourName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parcours.count
    }
    
    func createParcourArray() {
        parcours.append(Parcour(parcourName: "Valbonne", parcourImage:#imageLiteral(resourceName:"parcour1"), parcourDesc:"voici le vieux nice jqdhkqjhdkqfbhkqbfkqhbf"))
        parcours.append(Parcour(parcourName: "Mamac", parcourImage:#imageLiteral(resourceName: "parcour2"), parcourDesc:"Mamac wajj jhjsfdlfhskhfksghfksghfksghb"))
        parcours.append(Parcour(parcourName: "Vielle ville", parcourImage:#imageLiteral(resourceName: "parcour3"), parcourDesc:"vieille ville bella vista jndjsndjsbjsb "))
    
    }
    
    
}
