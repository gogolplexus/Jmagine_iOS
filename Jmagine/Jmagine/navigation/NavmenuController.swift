//
//  NavmenuController.swift
//  Jmagine
//
//  Created by mbds on 24/02/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import SideMenu
import CoreData

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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            viewController.container = appDelegate.persistentContainer
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
            
            //Parcours 6
            //viewController.currParcours = 6
            //viewController.currParcoursName = "Chemin de Pierre Laffitte à Sophia Antipolis"
            //viewController.currParcoursImg = "http://jmagine.tokidev.fr/uploads/img/img1290559692733976160.jpg"
            
            //Parcours 4
            viewController.currParcours = 4
            viewController.currParcoursName = "Chemin des artistes et écrivains du vieux Nice"
            viewController.currParcoursImg = "http://jmagine.tokidev.fr/uploads/img/img1794274583483207166.jpg"
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            viewController.container = appDelegate.persistentContainer
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
        
        let contentView = UIView(frame: CGRect(x: 30, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        
        cell.textLabel!.textColor = .white
        cell.textLabel!.font = UIFont.preferredFont(forTextStyle: .title2)
        cell.textLabel!.adjustsFontForContentSizeCategory = true
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        
        contentView.addSubview(cell.textLabel!)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        cell.selectedBackgroundView = backgroundView
        cell.addSubview(contentView)
        
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
        mainTitle.textColor = .white
        mainTitle.adjustsFontForContentSizeCategory = true
        mainTitle.layer.shadowColor = UIColor.black.cgColor
        mainTitle.layer.shadowRadius = 3.0
        mainTitle.layer.shadowOpacity = 1.0
        mainTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainTitle.layer.masksToBounds = false
        mainTitle.text = "Jmagine"
        mainTitle.sizeToFit()
        
        let subTitle = UILabel(frame: CGRect(x: 0, y: 30, width: self.view.frame.size.width  - 10, height: 50))
        subTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subTitle.textColor = UIColor.JmagineColors.Blue.MainBlue
        subTitle.adjustsFontForContentSizeCategory = true
        subTitle.layer.shadowColor = UIColor.black.cgColor
        subTitle.layer.shadowRadius = 3.0
        subTitle.layer.shadowOpacity = 1.0
        subTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        subTitle.layer.masksToBounds = false
        subTitle.text = "Chemins invisibles pour l'éducation, la culture et le patrimoine"
        subTitle.lineBreakMode = .byWordWrapping
        subTitle.numberOfLines = 0
        
        let titleView = UIView(frame: CGRect(x:30, y:130, width:max(mainTitle.frame.size.width, subTitle.frame.size.width), height:0))
        titleView.addSubview(mainTitle)
        titleView.addSubview(subTitle)
        
        let blueSeparator = UIView(frame: CGRect(x: 0, y: 250 - 5, width: self.view.frame.size.width, height: 5))
        blueSeparator.backgroundColor = UIColor.JmagineColors.Blue.MainBlue
        
        self.logoImageView.addSubview(blueSeparator)
        self.logoImageView.addSubview(titleView)
        
        view.addSubview(logoImageView)
        let widthConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        
        let heightConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        
        self.view.addConstraints([widthConstraint, heightConstraint])
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}
