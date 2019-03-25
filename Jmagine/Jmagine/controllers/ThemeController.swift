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

class ThemeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsMultipleSelection = true
        return tv
    }()
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "themeId", for: indexPath)
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let themeId = "themeId"

    var themeList = [String: XML.Accessor]()
var currtheme:XML.Accessor?
    

    
    func setupTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ThemeCell.self, forCellReuseIdentifier: themeId)
        view.addSubview(tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setNeedsStatusBarAppearanceUpdate()
        initNavOptions()
        setupTableView()
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: NavmenuController())

        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
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
            
            currtheme = theme
            themeList[theme["name"].text!] = theme
            

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
    
    
  //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let name = themeList[currtheme!["name"].text!]
    //     let cell = tableView.dequeueReusableCell(withIdentifier: "themeId", for: indexPath)
//       cell.textLabel?.text = name
//        //currtheme?["name"].text!
//     //   print(currtheme?["name"].text!)
////print (currtheme?.id.text!)
    //    cell.layer.borderColor = UIColor.lightGray.cgColor
    //    cell.layer.borderWidth = 4.0
      //  cell.layer.masksToBounds = true
    
        
    //    return cell
   // }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeList.count
    }
    
    
}

class ThemeCell: UITableViewCell {
    
    let ThemeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(ThemeView)
        addSubview(descriptionLabel)
        ThemeView.layer.cornerRadius = 8
        ThemeView.layer.masksToBounds = true
        ThemeView.layer.shadowColor = UIColor.black.cgColor
        ThemeView.layer.shadowRadius = 4
        ThemeView.layer.shadowOpacity = 0.23
    }
        private let descriptionLabel : UILabel = {
            let lbl = UILabel()
            lbl.textColor = .black
            lbl.font = UIFont.systemFont(ofSize: 16)
            lbl.textAlignment = .left
            lbl.numberOfLines = 0
            lbl.text = "cpucpu"
            return lbl
        }()
    
}
    

