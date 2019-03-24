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

class ParcoursDetailController: UIViewController, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView : UICollectionView?
    
    var poiList = [String: XML.Accessor]()
    var poiStateTracker = [String: ParcoursState.State]()
    var selectedPoi = ""
    
    var maxLat:Double = -200
    var maxLong:Double = -200
    var minLat:Double = Double(MAXFLOAT)
    var minLong:Double = Double(MAXFLOAT)
    
    var estimatedTime:Int = 0
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return poiList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "poi", for: indexPath)
        
        let cellContentFrame = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
        cellContentFrame.layer.cornerRadius = 25
        
        let rightArrow = UIImage(named:"ic_chevron_right")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let toDetailBtn = CustomUIButton(frame: CGRect(x: (cellContentFrame.frame.size.width - 40), y: (cellContentFrame.frame.size.height - 30) / 2, width: 30, height: 30))
        toDetailBtn.setImage(rightArrow, for: .normal)
        toDetailBtn.tintColor = .black
        toDetailBtn.addTarget(self, action: #selector(self.openPOIDetail(_:)), for:.touchUpInside)
        toDetailBtn.params["poiName"] = Array(poiList.values)[indexPath.row].title.text ?? ""
        
        switch Array(poiStateTracker.values)[indexPath.row] {
        case ParcoursState.State.inactive:
            cellContentFrame.backgroundColor = UIColor.JmagineColors.Gray.MainGray
        case ParcoursState.State.active:
            cellContentFrame.backgroundColor = UIColor.JmagineColors.Blue.MainBlue
            //cellContentFrame.addSubview(toDetailBtn)
        default:
            cellContentFrame.backgroundColor = UIColor.JmagineColors.Green.MainGreen
            //cellContentFrame.addSubview(toDetailBtn)
        }
        
        let cursor = UIImageView(frame: CGRect(x: 10, y: (cellContentFrame.frame.size.height - 30) / 2, width: 30, height: 30))
        cursor.image = #imageLiteral(resourceName: "ic_location_on_48pt.png")
        cursor.image = cursor.image?.maskWithColor(color: .black)
        cellContentFrame.addSubview(cursor)
        
        let title = UILabel(frame: CGRect(x:cursor.frame.maxX + 15, y:(cursor.frame.minY + (cursor.frame.size.height / 4)), width:cellContentFrame.frame.size.width - 40, height:0))
        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.adjustsFontForContentSizeCategory = true
        title.text = Array(poiList.values)[indexPath.row].title.text ?? ""
        title.tintColor = .black
        title.sizeToFit()
        cellContentFrame.addSubview(title)
        
        cell.contentView.addSubview(cellContentFrame)
        return cell
    }
    
    func initTableView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width-50, height: 50)
        
        let frame = CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: self.view.frame.size.height - 200)
        
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "poi")
        self.collectionView!.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.JmagineColors.Dark.MainDark
        initCloseBtn()
        calculateEstimatedTime {
            result in
            self.initHeaders()
            self.initTableView()
            self.view.addSubview(self.collectionView!)
        }
    }
    
    func calculateEstimatedTime(completionHandler: @escaping (_ result: Int) -> ()) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.minLat, longitude: self.minLong), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.maxLat, longitude: self.maxLong), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculateETA { (data, err) in
            self.estimatedTime = Int(data?.expectedTravelTime ?? 0)
            print(Int(self.estimatedTime).description)
            completionHandler(self.estimatedTime)
        }
    }
    
    func parseTime(time:Int) -> String{
        let timeFormat = DateComponentsFormatter()
        timeFormat.allowedUnits = [.hour, .minute, .second]
        timeFormat.unitsStyle = .abbreviated
        
        let formattedString = timeFormat.string(from: TimeInterval(time))!
        return formattedString
    }
    
    func closeThisModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPOIDetail(_ sender: CustomUIButton) {
        let index:String = sender.params["poiName"] as! String
        let modalViewController = DetailController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.poiList = poiList
        modalViewController.currPoi = poiList[index]
        present(modalViewController, animated: true, completion: nil)
    }
    
    @objc func handleCloseModalGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            closeThisModal()
        }
    }
    
    func initCloseBtn() {
        let openControlIcon = UIImage(named:"ic_keyboard_arrow_down_white")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let openControlButton = UIButton(frame: CGRect(x: (view.frame.width - 100)/2, y: 10, width: 100, height: 100))
        //openControlButton.addTarget(self, action: #selector(closeThisModal), for: .touchUpInside)
        openControlButton.tintColor = .white
        openControlButton.setImage(openControlIcon, for: .normal)
        view.addSubview(openControlButton)
        
        //Adding gesture
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleCloseModalGesture(gesture:)))
        swipeDown.direction = .down
        openControlButton.addGestureRecognizer(swipeDown)
    }
    
    func initHeaders() {
        let frame = UIView(frame: CGRect(x:50, y:100, width:view.frame.size.width, height:50))
        frame.sizeToFit()
        
        let timeIcon = UIImage(named:"ic_access_time")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let timeImage = UIImageView(image: timeIcon)
        timeImage.tintColor = .white
        frame.addSubview(timeImage)
        
        let totalEstimatedTime = UILabel(frame: CGRect(x: timeImage.frame.maxX + 5, y: 0, width: 0, height: 0))
        totalEstimatedTime.adjustsFontForContentSizeCategory = true
        totalEstimatedTime.font = UIFont.preferredFont(forTextStyle: .callout)
        totalEstimatedTime.textColor = .white
        totalEstimatedTime.text = "Temps total estimé : \(parseTime(time: self.estimatedTime))"
        totalEstimatedTime.sizeToFit()
        frame.addSubview(totalEstimatedTime)
        
        let numberOfPoiLabel = UILabel(frame: CGRect(x: timeImage.frame.maxX + 5, y: totalEstimatedTime.frame.maxY, width: 0, height: 0))
        numberOfPoiLabel.adjustsFontForContentSizeCategory = true
        numberOfPoiLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        numberOfPoiLabel.textColor = .white
        numberOfPoiLabel.text = "Nombre de POI : \(poiList.count)"
        numberOfPoiLabel.sizeToFit()
        frame.addSubview(numberOfPoiLabel)
        
        frame.tag = 001
        view.addSubview(frame)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}
