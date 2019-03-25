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
import CoreData


class ThemeController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let themeId = "themeId"
    var themeList = [String: XML.Accessor]()
    var currtheme:XML.Accessor?
    var container: NSPersistentContainer!

    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .singleLine
        tv.allowsMultipleSelection = true
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getData()
        setNeedsStatusBarAppearanceUpdate()
        setupTableView()
        initNavOptions()
        setupTableView()
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: NavmenuController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        //tableView.anch
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 600, enableInsets: false)
        tableView.register(ThemeCell.self, forCellReuseIdentifier: themeId)
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
        
        let doneImage = UIImage(named:"ic_arrow_forward")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let doneButton = UIBarButtonItem(image: doneImage, style: .plain, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func save() {
        
        let navControl = self.navigationController
        let viewController = HomeController()
        viewController.modalPresentationCapturesStatusBarAppearance = true
        navControl?.pushViewController(viewController, animated: true)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ThemeCell = tableView.dequeueReusableCell(withIdentifier: "themeId", for: indexPath) as! ThemeCell
        cell.setup()
        view.addSubview(cell.ThemeView)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt themeId: IndexPath) {
        if self.tableView.cellForRow(at: themeId)?.accessoryType ==  UITableViewCell.AccessoryType.checkmark {
            
            self.tableView.cellForRow(at: themeId)?.accessoryType = UITableViewCell.AccessoryType.none
            	        } else {
            self.tableView.cellForRow(at: themeId)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
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
        setup()
    }
    
    func setup() {
        addSubview(ThemeView)
//ThemeView.addSubview(descriptionLabel)        //ThemeView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8, width: 00, height: 400, enableInsets: true)
        ThemeView.layer.cornerRadius = 8
        ThemeView.layer.masksToBounds = true
        ThemeView.layer.shadowColor = UIColor.black.cgColor
        ThemeView.layer.shadowRadius = 4
        ThemeView.layer.shadowOpacity = 0.23
        ThemeView.layer.borderColor = UIColor.lightGray.cgColor
        //cell.layer.borderWidth = 2.0
    }

       private let descriptionLabel : UILabel = {
            let lbl = UILabel()
            lbl.textColor = .black
            lbl.font = UIFont.systemFont(ofSize: 16)
            lbl.textAlignment = .left
            lbl.numberOfLines = 0
            lbl.text = "coucou"
            return lbl
        }()
    
}
    

