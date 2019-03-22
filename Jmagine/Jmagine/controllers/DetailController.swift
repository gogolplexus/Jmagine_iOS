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

class DetailController: UIViewController, UINavigationControllerDelegate
{
    
    var currPoi:XML.Accessor?
    var poiList = [String: XML.Accessor]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        initNavOptions()
        getData()
        
        
        //view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func getAllPoiFromParcours(idParcours: Int,completion : @escaping (_ dataXML:XML.Accessor) -> ()){
        Alamofire.request("http://jmagine.tokidev.fr/api/parcours/\(idParcours)/get_all_pois")
            .responseData { response in
                if let data = response.data {
                    var poiData:XML.Accessor
                    let xml = XML.parse(data)
                    poiData = xml.list.poi
                    print(xml.list.poi,"poidata")
                    completion(poiData)
                }
        }
    }
    
    func getPois(data:XML.Accessor) {
        // print(data.text)
        //Adding cursors
        //And populating poiTracker dict
        for poi in data {
            //Populating poiTracker dict
            poiList[poi.title.text!] = poi
            currPoi = poi
            
        }
        initHeader()
        initBody()
        
    }
    func getData(){
        self.getAllPoiFromParcours(idParcours: 4){ (dataXML) in
            self.getPois(data: dataXML)
            // print(dataXML.description,"dataxml")
        }
    }
    func initNavOptions() {
        
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titleLabel
        titleLabel.text = "back"
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        
    }
    // func getImagePoi () -> UIImageView {
    //let imagePoiUrl = currPoi?.backgroungPic.text
    
    /*let logoImageView: UIImageView = {
     let imageView = UIImageView(image:#imageLiteral(resourceName: "header.jpg"))
     imageView.contentMode = .scaleAspectFill
     imageView.clipsToBounds = true
     imageView.translatesAutoresizingMaskIntoConstraints = false
     return imageView
     }()*/
    
    
    /*    if let url = URL(string: (currPoi?.backgroungPic.text)!) {
     do {
     let data: Data = try Data(contentsOf: url)
     logoImageView.image = UIImage(data: data)
     } catch {
     }}*/
    //        return logoImageView
    //
    //        }
    func initHeader() {
        //let poiTitle = currPoi?.title.text
        let mainTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mainTitle.font = UIFont.preferredFont(forTextStyle: .title1)
        mainTitle.textColor = UIColor.JmagineColors.Blue.MainBlue
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
            
            let poiImg = UIImageView(frame: CGRect(x: mainTitle.frame.maxX, y: mainTitle.frame.maxY + 10, width: mainTitle.frame.width, height: mainTitle.frame.height))
            poiImg.imageFromURL(urlString: (currPoi?.backgroundPic.text)!)
            poiImg.layer.cornerRadius = poiImg.frame.height/2
            poiImg.clipsToBounds = true
            poiImg.contentMode = .scaleAspectFill
            poiImg.translatesAutoresizingMaskIntoConstraints = false
            poiImg.addSubview(titleView)
            return poiImg
        }()
        view.addSubview(logoImageView)
        
        let widthConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width)
        
        let heightConstraint = NSLayoutConstraint(item: logoImageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250)
        
        self.view.addConstraints([widthConstraint, heightConstraint])
    }
    func initBody() {
        
        let description = UITextView(frame: CGRect(x:0, y:0, width:350, height:350))
        description.text = currPoi?.content.text
        description.font = UIFont.preferredFont(forTextStyle: .body)
        description.backgroundColor = .black
        description.center = self.view.center
        description.textColor = UIColor.JmagineColors.Gray.MainGray
        description.layer.shadowColor = UIColor.black.cgColor
        description.layer.shadowRadius = 3.0
        description.layer.shadowOpacity = 1.0
        description.layer.shadowOffset = CGSize(width: 0, height: 0)
        description.layer.masksToBounds = false
        description.sizeToFit()
        //let descView = UIView(frame: CGRect(x:0, y:0, width:description.frame.size.width, height:60))
        //descView.backgroundColor = .red
        self.view.addSubview(description)
    }
    
}
