//
//  DetailController.swift
//  Jmagine
//
//  Created by hamza on 20/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import Foundation
import UIKit
import SwiftyXMLParser
import XMLParsing
import Alamofire
import SwiftSoup
import WebKit

class DetailController: UIViewController, UINavigationControllerDelegate, WKUIDelegate {
    
    var currPoi:XML.Accessor?
    var poiList = [String: XML.Accessor]()
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        initHeader()
        initNavOptions()
        initBody()
        view.backgroundColor = .white
    }
    
    func initNavOptions() {
        let backbutton = UIButton(type: .system)
        backbutton.frame = CGRect(x: 30, y: 50, width: 150, height: 50)
        backbutton.setTitle("Retour", for: .normal)
        backbutton.setTitleColor(.white, for: .normal)
        backbutton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backbutton.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        backbutton.titleLabel?.layer.shadowRadius = 3.0
        backbutton.titleLabel?.layer.shadowOpacity = 1.0
        backbutton.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        backbutton.titleLabel?.layer.masksToBounds = false
        backbutton.sizeToFit()
        
        self.view.addSubview(backbutton)
    }
    
    @objc func backAction() -> Void {
        self.dismiss(animated: true, completion: nil)
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
        mainTitle.text = currPoi?.title.text
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
        subTitle.text = currPoi?.address.text
        subTitle.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x:10, y:150, width:max(mainTitle.frame.size.width, subTitle.frame.size.width), height:30))
        titleView.addSubview(mainTitle)
        titleView.addSubview(subTitle)
        
        let logoImageView: UIImageView = {
            let poiImg = UIImageView(frame: CGRect(x: mainTitle.frame.maxX, y: mainTitle.frame.maxY, width: mainTitle.frame.width, height: 300))
            poiImg.imageFromURL(urlString: (currPoi?.backgroundPic.text)!)
            poiImg.clipsToBounds = true
            poiImg.contentMode = .scaleAspectFill
            poiImg.translatesAutoresizingMaskIntoConstraints = false
            poiImg.addSubview(titleView)
            return poiImg
        }()
        logoImageView.tag = 101
        view.addSubview(logoImageView)
        
        let widthConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        
        let heightConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        
        self.view.addConstraints([widthConstraint, heightConstraint])
    }
    func initBody() {
        let headerTag:UIView = self.view.viewWithTag(101)!
        print(headerTag.frame.size.height)
        let contentContainer = UIView(frame: CGRect(
            x:0,
            y:240,
            width:view.frame.size.width,
            height:view.frame.size.height - 240
            )
        )
        contentContainer.backgroundColor = .white
        contentContainer.layer.cornerRadius = 10
        
        do {
            let html = currPoi?.content.text
            let doc: Document = try SwiftSoup.parse(html ?? "")
            
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: CGRect(x: 10, y: 10, width: contentContainer.frame.size.width - 20, height: contentContainer.frame.size.height - 20), configuration: webConfiguration)
            webView.uiDelegate = self
            webView.loadHTMLString(try doc.body()!.text(), baseURL: nil)
            
            contentContainer.addSubview(webView)
            self.view.addSubview(contentContainer)
        } catch Exception.Error(let type, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
}
