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
    
    private let myArray: NSArray = ["Parcours","Thèmes","Favoris","Tutoriel"]
    private var myTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image:#imageLiteral(resourceName: "menu_bg.jpg"))
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        customizeMenu()
        initNavOptions()
        initHeader()
        
        // Add the view to the view hierarchy so that it shows up on screen
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + 250, width: displayWidth, height: displayHeight - barHeight - 250))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.view.addSubview(myTableView)
    }
    
    func customizeMenu(){
        SideMenuManager.default.menuWidth = self.view.frame.width
        SideMenuManager.default.menuDismissOnPush = true
    }
    
    @objc func closeMenu(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    func initNavOptions() {
        let closeImage = UIImage(named:"ic_menu")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        let nextButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(closeMenu))
        nextButton.tintColor = .white
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        
        navigationItem.titleView = titleLabel
        titleLabel.text = "Menu"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        
        navigationItem.rightBarButtonItem = nextButton
    }
    
    func initHeader() {
        view.addSubview(logoImageView)
        let widthConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        
        let heightConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        
        self.view.addConstraints([widthConstraint, heightConstraint])
    }
}
