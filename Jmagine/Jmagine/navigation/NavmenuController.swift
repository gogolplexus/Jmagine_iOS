//
//  NavmenuController.swift
//  Jmagine
//
//  Created by mbds on 24/02/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import SideMenu

class NavmenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let myArray: NSArray = ["Parcours","Thèmes","Favoris","Tutoriel","Test"]
    private var myTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image:#imageLiteral(resourceName: "header.jpg"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedView: String = myArray[indexPath.row] as! String
        switch (selectedView) {
        case "Parcours":
            let navControl = self.navigationController
            let viewController = HomeController()
            viewController.modalPresentationCapturesStatusBarAppearance = true
            navControl?.pushViewController(viewController, animated: true)
            break
        case "Favoris":
            let navControl = self.navigationController
            let viewController = FavorisController()
            viewController.modalPresentationCapturesStatusBarAppearance = true
            navControl?.pushViewController(viewController, animated: true)
            break
        case "Tutoriel":
            let navControl = self.navigationController
            let viewController = TutoController()
            viewController.modalPresentationCapturesStatusBarAppearance = true
            navControl?.pushViewController(viewController, animated: true)
            break
        case "Thèmes":
            let navControl = self.navigationController
            let viewController = ThemeController()
            viewController.modalPresentationCapturesStatusBarAppearance = true
            navControl?.pushViewController(viewController, animated: true)
            break
        case "Test":
            let navControl = self.navigationController
            let viewController = ParcoursController()
            viewController.currParcours = 4
            viewController.currParcoursName = "Chemin des artistes et écrivains du vieux Nice"
            viewController.modalPresentationCapturesStatusBarAppearance = true
            navControl?.pushViewController(viewController, animated: true)
            break
        default:
            let navControl = self.navigationController
            let viewController = HomeController()
            viewController.modalPresentationCapturesStatusBarAppearance = true
            navControl?.pushViewController(viewController, animated: true)
            break
        }
        
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.textLabel!.textColor = .white
        cell.textLabel!.font = UIFont.preferredFont(forTextStyle: .title2)
        cell.textLabel!.adjustsFontForContentSizeCategory = true
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.JmagineColors.Dark.MainDark
        initNavOptions()
        initHeader()
        
        // Add the view to the view hierarchy so that it shows up on screen
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 250, width: displayWidth, height: displayHeight - barHeight - 250))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        customizeMenu()
        
        self.view.addSubview(myTableView)
    }
    
    func customizeMenu(){
        SideMenuManager.default.menuWidth = self.view.frame.width
        SideMenuManager.default.menuDismissOnPush = true
        
        myTableView.backgroundColor = UIColor.JmagineColors.Dark.MainDark
        myTableView.separatorStyle = .none
    }
    
    @objc func closeMenu(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    func initNavOptions() {
        let closeImage = UIImage(named:"ic_menu")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        let nextButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeMenu))
        nextButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = nextButton
    }
    
    func initHeader() {
        let mainTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mainTitle.font = UIFont.preferredFont(forTextStyle: .title1)
        mainTitle.textColor = UIColor.JmagineColors.Blue.MainBlue
        mainTitle.adjustsFontForContentSizeCategory = true
        mainTitle.layer.shadowColor = UIColor.black.cgColor
        mainTitle.layer.shadowRadius = 3.0
        mainTitle.layer.shadowOpacity = 1.0
        mainTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainTitle.layer.masksToBounds = false
        mainTitle.text = "Jmagine"
        mainTitle.sizeToFit()
        
        let subTitle = UILabel(frame: CGRect(x: 0, y: 30, width: 0, height: 0))
        subTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitle.textColor = UIColor.JmagineColors.Gray.MainGray
        mainTitle.adjustsFontForContentSizeCategory = true
        subTitle.layer.shadowColor = UIColor.black.cgColor
        subTitle.layer.shadowRadius = 3.0
        subTitle.layer.shadowOpacity = 1.0
        subTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        subTitle.layer.masksToBounds = false
        subTitle.text = "Les chemins de la connaissance"
        subTitle.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x:10, y:150, width:max(mainTitle.frame.size.width, subTitle.frame.size.width), height:30))
        titleView.addSubview(mainTitle)
        titleView.addSubview(subTitle)
        
        self.logoImageView.addSubview(titleView)
        
        view.addSubview(logoImageView)
        let widthConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        
        let heightConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        
        self.view.addConstraints([widthConstraint, heightConstraint])
    }
}
