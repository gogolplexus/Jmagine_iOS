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
    
    //final let url = URL(string: )
    
    let parcourId = "parcourId"
    var parcours: [Parcour]=[Parcour]()
    
    var currParcour:XML.Accessor?
    var parcoursList = [String: XML.Accessor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        initNavOptions()
        //initSearchOptions()
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
        tableView.register(ParcourCell.self, forCellReuseIdentifier: parcourId)
        self.tableView.sectionHeaderHeight = 70
        
//        let searchBar = UISearchBar()
//        searchBar.frame = CGRect(x: 15, y: 100, width: 350, height: 50)
//        self.view.addSubview(searchBar)
        
        // Do any additional setup after the view, typically from a nib
        
        getData()
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
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    
//    func initSearchOptions() {
//        let closeImage = UIImage(named:"search")?.withRenderingMode(
//            UIImage.RenderingMode.alwaysTemplate)
//        let searchButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(openMenu))
//        searchButton.tintColor = .black
//        navigationItem.rightBarButtonItem = searchButton
//    }
//
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: parcourId, for: indexPath) as! ParcourCell
        let currentLastItem = parcours[indexPath.row]  // un int
        cell.parcour = currentLastItem
//        let currentLastItem = Array(parcoursList.values)[indexPath.row]
//        cell.parcoursList = currentLastItem
        
         cell.layer.borderColor = UIColor.lightGray.cgColor
         cell.layer.borderWidth = 4.0
        
         cell.layer.masksToBounds = true
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parcours.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Art"
        }
    
    
    func createParcourArray() {
        parcours.append(Parcour(id: 1, title: "Valbonne", description:"voici le vieux nice jqdhkqjhdkqfbhkqbfkqhbf",themes: "Art", backgroundPic:#imageLiteral(resourceName:"parcour1")))
        parcours.append(Parcour(id :2, title: "Mamac", description:"Mamac wajj jhjsfdlfhskhfksghfksghfksghb",themes:"Art", backgroundPic:#imageLiteral(resourceName: "parcour2")))
        
         parcours.append(Parcour(id :3, title: "Vieille Ville", description:"Vieille wajj jhjsfdlfhskhfksghfksghfksghb",themes:"Art", backgroundPic:#imageLiteral(resourceName: "parcour2")))
        
         parcours.append(Parcour(id :4, title: "Vieux Nice", description:"Vieux NIce wajj jhjsfdlfhskhfksghfksghfksghb",themes:"Art", backgroundPic:#imageLiteral(resourceName: "parcour2")))
        
         parcours.append(Parcour(id :5, title: "MBDS", description:"MBDS wajj jhjsfdlfhskhfksghfksghfksghb",themes:"Art", backgroundPic:#imageLiteral(resourceName: "parcour2")))
        
//        parcours.append(Parcour(id: 3, title: "Vielle ville", description:"vieille ville bella vista jndjsndjsbjsb ", themes:"Art", backgroudPic:#imageLiteral(resourceName: "parcour3")))
//
//        parcours.append(Parcour(parcourName: "Valbonne", parcourImage:#imageLiteral(resourceName:"parcour1"), parcourDesc:"voici le vieux nice jqdhkqjhdkqfbhkqbfkqhbf"))
//        parcours.append(Parcour(parcourName: "Mamac", parcourImage:#imageLiteral(resourceName: "parcour2"), parcourDesc:"Mamac wajj jhjsfdlfhskhfksghfksghfksghb"))
//        parcours.append(Parcour(parcourName: "Vielle ville", parcourImage:#imageLiteral(resourceName: "parcour3"), parcourDesc:"vieille ville bella vista jndjsndjsbjsb "))
//        
//        
//        parcours.append(Parcour(parcourName: "Valbonne", parcourImage:#imageLiteral(resourceName:"parcour1"), parcourDesc:"voici le vieux nice jqdhkqjhdkqfbhkqbfkqhbf"))
//        parcours.append(Parcour(parcourName: "Mamac", parcourImage:#imageLiteral(resourceName: "parcour2"), parcourDesc:"Mamac wajj jhjsfdlfhskhfksghfksghfksghb"))
//        parcours.append(Parcour(parcourName: "Vielle ville", parcourImage:#imageLiteral(resourceName: "parcour3"), parcourDesc:"vieille ville bella vista jndjsndjsbjsb "))
    
    }
    
    
    
    
    
    
    func getAllParcours(completion : @escaping (_ dataXML:XML.Accessor) -> ()){
        Alamofire.request("http://jmagine.tokidev.fr/api/parcours/get_all")
            .responseData { response in
                if let data = response.data {
                    var parcourData:XML.Accessor
                    let xml = XML.parse(data)
                    parcourData = xml.list.parcours
                    print(xml.list.parcour,"parcourdata")
                    completion(parcourData)
                }
        }
    }
    
    
    func getParcours(data:XML.Accessor) {
        // print(data.text)
        //Adding cursors
        //And populating poiTracker dict
        for parcour in data {
            //Populating poiTracker dict
            parcoursList[parcour.title.text!] = parcour
            currParcour = parcour
            
        }
//        initHeader()
//        initBody()
        
    }

    
    func getData(){
        self.getAllParcours(){ (dataXML) in
            self.getParcours(data: dataXML)
            // print(dataXML.description,"dataxml")
        }
    }

    
}


