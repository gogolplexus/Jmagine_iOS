//
//  ParcoursDetailController.swift
//  Jmagine
//
//  Created by mbds on 19/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import SwiftyXMLParser
import MapKit

class ParcoursDetailController: UIViewController, MKMapViewDelegate {
    
    var poiList = [String: XML.Accessor]()
    
    @objc func closeThisModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func initCloseBtn() {
        let openControlIcon = UIImage(named:"ic_keyboard_arrow_down_white")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let openControlButton = UIButton(frame: CGRect(x: (view.frame.width - 100)/2, y: 10, width: 100, height: 100))
        openControlButton.addTarget(self, action: #selector(closeThisModal), for: .touchUpInside)
        openControlButton.tintColor = .white
        openControlButton.setImage(openControlIcon, for: .normal)
        view.addSubview(openControlButton)
    }
    
    func initHeaders() {
        let frame = UIView(frame: CGRect(x:50, y:100, width:view.frame.size.width, height:160))
        let timeIcon = UIImage(named:"ic_access_time")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let timeImage = UIImageView(image: timeIcon)
        timeImage.tintColor = .white
        frame.addSubview(timeImage)
        
        let totalEstimatedTime = UILabel(frame: CGRect(x: timeImage.frame.maxX + 5, y: 0, width: 0, height: 0))
        totalEstimatedTime.adjustsFontForContentSizeCategory = true
        totalEstimatedTime.font = UIFont.preferredFont(forTextStyle: .callout)
        totalEstimatedTime.textColor = .white
        totalEstimatedTime.text = "Temps total estimé : "
        totalEstimatedTime.sizeToFit()
        frame.addSubview(totalEstimatedTime)
        
        let numberOfPoiLabel = UILabel(frame: CGRect(x: timeImage.frame.maxX + 5, y: totalEstimatedTime.frame.maxY, width: 0, height: 0))
        numberOfPoiLabel.adjustsFontForContentSizeCategory = true
        numberOfPoiLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        numberOfPoiLabel.textColor = .white
        numberOfPoiLabel.text = "Nombre de POI : \(poiList.count)"
        numberOfPoiLabel.sizeToFit()
        frame.addSubview(numberOfPoiLabel)
        
        view.addSubview(frame)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.JmagineColors.Dark.MainDark
        initCloseBtn()
        initHeaders()
        
        let request = MKDirections.Request()
        var total:Double = 0.0
        
        /*poiList.forEach { (key,value) in
            let currIndex = poiList.index(forKey: key)
            
            if(poiList.endIndex != currIndex) {
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: value.lat.double ?? 0.0, longitude: value.lng.double ?? 0.0), addressDictionary: nil))
                
                let nextLat = poiList[poiList.index(after: currIndex!)].value.lat.double
                let nextLng = poiList[poiList.index(after: currIndex!)].value.lng.double
                
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: nextLat ?? 0.0, longitude: nextLng ?? 0.0), addressDictionary: nil))
                request.requestsAlternateRoutes = true
                request.transportType = .walking
                
                let directions = MKDirections(request: request)
                directions.calculateETA { (data, err) in
                    let timeInMinutes = (data?.expectedTravelTime ?? 0) / 60
                    total = total + timeInMinutes
                    print(timeInMinutes.description)
                }
                
            }
        }*/
        
        print(total)
    }
}
