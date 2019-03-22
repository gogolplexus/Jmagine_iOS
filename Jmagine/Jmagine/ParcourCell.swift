//
//  ParcourCell.swift
//  Jmagine
//
//  Created by Aimé NITEKA on 21/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
class ParcourCell : UITableViewCell {
    
    var parcour : Parcour? {
        didSet {
            parcourImage.image = parcour?.parcourImage
            parcourNameLabel.text = parcour?.parcourName
            parcourDescriptionLabel.text = parcour?.parcourDesc
        }
    }
    
    
    private let parcourNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    private let parcourDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    /*
    private let decreaseButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: “minusTb”), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    private let increaseButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: “addTb”), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
 
 
    var parcourQuantity : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = “1”
        label.textColor = .black
        return label
        
    }()
 
 */
    
    private let parcourImage : UIImageView = {
        let imgView = UIImageView(image:#imageLiteral(resourceName: "parcour3"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(parcourImage)
        addSubview(parcourNameLabel)
        addSubview(parcourDescriptionLabel)
        /*
        addSubview(decreaseButton)
        addSubview(parcourQuantity)
        addSubview(increaseButton)
 */
        
        //parcourImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        parcourNameLabel.anchor(top: topAnchor, left: parcourImage.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        parcourDescriptionLabel.anchor(top: parcourNameLabel.bottomAnchor, left: parcourImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        
        
       // let stackView = UIStackView(arrangedSubviews: [decreaseButton,parcourQuantity,increaseButton])
       // stackView.distribution = .equalSpacing
       // stackView.axis = .horizontal
        //stackView.spacing = 5
       // addSubview(stackView)
        //stackView.anchor(top: topAnchor, left: parcourNameLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 70, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}




