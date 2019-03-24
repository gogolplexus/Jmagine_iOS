//
//  ParcourCell.swift
//  Jmagine
//
//  Created by Aimé NITEKA on 21/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//


import Alamofire

import UIKit
class ParcourCell : UITableViewCell {
    
    var parcour : Parcour? {
        didSet {
            backgroundPicLabel.image = parcour?.backgroundPic
            titleLabel.text = parcour?.title
            descriptionLabel.text = parcour?.description
        }
    }
    
    
    private let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let parcourView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        //view.setCellShadow()
        return view
    }()

 
 
 
 
    
    private let backgroundPicLabel   : UIImageView = {
        let imgView = UIImageView(image:#imageLiteral(resourceName: "parcour3"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        return imgView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backgroundPicLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
      
        
//        parcourView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 8)
        /*
        addSubview(decreaseButton)
        addSubview(parcourQuantity)
        addSubview(increaseButton)
 */
        
        backgroundPicLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 5, paddingRight: 2, width: 90, height: 0, enableInsets: false)
        titleLabel.anchor(top: topAnchor, left: backgroundPicLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: backgroundPicLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//
//extension UIImage {
//    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
//        var width: CGFloat
//        var height: CGFloat
//        var newImage: UIImage
//        
//        let size = self.size
//        let aspectRatio =  size.width/size.height
//        
//        switch contentMode {
//        case .scaleAspectFit:
//            if aspectRatio > 1 {                            // Landscape image
//                width = dimension
//                height = dimension / aspectRatio
//            } else {                                        // Portrait image
//                height = dimension
//                width = dimension * aspectRatio
//            }
//            
//        default:
//            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
//        }
//        
//        if #available(iOS 10.0, *) {
//            let renderFormat = UIGraphicsImageRendererFormat.default()
//            renderFormat.opaque = opaque
//            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
//            newImage = renderer.image {
//                (context) in
//                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
//            }
//        } else {
//            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
//            self.draw(in: CGRect(x: 12, y: 12, width: width, height: height))
//            newImage = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//        }
//        
//        return newImage
//    }
//}
//
//
//
//






