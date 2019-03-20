//
//  DetailController.swift
//  Jmagine
//
//  Created by hamza on 20/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import Foundation
import UIKit

class DetailController: UIViewController, UINavigationControllerDelegate
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        	initNavOptions()
        initHeader()
        initBody()

        
        //view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initNavOptions() {
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titleLabel
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black

    }
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image:#imageLiteral(resourceName: "header.jpg"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    func initHeader() {
        let mainTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mainTitle.font = UIFont.systemFont(ofSize: 28)
        mainTitle.textColor = UIColor.JmagineColors.Blue.MainBlue
        mainTitle.layer.shadowColor = UIColor.black.cgColor
        mainTitle.layer.shadowRadius = 3.0
        mainTitle.layer.shadowOpacity = 1.0
        mainTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainTitle.layer.masksToBounds = false
        mainTitle.text = "Fennochio"
        mainTitle.sizeToFit()
        
        let subTitle = UILabel(frame: CGRect(x: 0, y: 30, width: 0, height: 0))
        subTitle.font = UIFont.systemFont(ofSize: 16)
        subTitle.textColor = UIColor.JmagineColors.Gray.MainGray
        subTitle.layer.shadowColor = UIColor.black.cgColor
        subTitle.layer.shadowRadius = 3.0
        subTitle.layer.shadowOpacity = 1.0
        subTitle.layer.shadowOffset = CGSize(width: 0, height: 0)
        subTitle.layer.masksToBounds = false
        subTitle.text = "Destinée de l'année"
        subTitle.sizeToFit()
        
        let titleView = UITextView(frame: CGRect(x:10, y:150, width:max(mainTitle.frame.size.width, subTitle.frame.size.width), height:30))
        titleView.addSubview(mainTitle)
        titleView.addSubview(subTitle)
        
        self.logoImageView.addSubview(titleView)
        
        view.addSubview(logoImageView)
        let widthConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        
        let heightConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        
        self.view.addConstraints([widthConstraint, heightConstraint])
    }
    func initBody() {
        
        let description = UITextView(frame: CGRect(x:10, y:150, width:30, height:30))
        description.text = "Bonjour je m'appelle hamza boudradar etudiant master 2 mbds......"
        description.font = UIFont.systemFont(ofSize: 20)
        description.center = self.view.center
        description.textColor = UIColor.JmagineColors.Gray.MainGray
        description.layer.shadowColor = UIColor.black.cgColor
        description.layer.shadowRadius = 3.0
        description.layer.shadowOpacity = 1.0
        description.layer.shadowOffset = CGSize(width: 0, height: 0)
        description.layer.masksToBounds = false
        description.textAlignment = .center
        //let descView = UIView(frame: CGRect(x:0, y:0, width:description.frame.size.width, height:60))
        //descView.backgroundColor = .red
        self.view.addSubview(description)
    }
    
    }
