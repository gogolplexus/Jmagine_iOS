//
//  ParcoursController.swift
//  Jmagine
//
//  Created by mbds on 10/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire
import SwiftyXMLParser
import XMLParsing
import MapKit

class ParcoursController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var currParcours:Int = 0
    var currParcoursName:String = ""
    var poiList = [String: XML.Accessor]()
    var poiStateTracker = [String: ParcoursState.State]()
    var mapView:MKMapView = MKMapView()
    var instructionsRead:Bool = false
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocation?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if (isViewLoaded && !instructionsRead) {
            instructionsRead = true
            //Showing an alert for user which displays basic instructions.
            // create the alert
            let alert = UIAlertController(title: "Instructions", message: "Pour commencer le parcours, veuillez cliquer sur le POI de votre choix. Par défaut, nous vous proposons un ordre de passage mais vous pouvez toujours suivre le parcours dans l'ordre de votre choix.", preferredStyle: UIAlertController.Style.alert)
            
            // add the button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // location manager delegate: did update locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations.last!
        // update current location properties
        currentCoordinate = lastLocation
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        setNeedsStatusBarAppearanceUpdate()
        initNavOptions()
        
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: NavmenuController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        self.getAllPoiFromParcours(idParcours: currParcours){ (dataXML) in
            self.drawMap(data: dataXML)
        }
    }
    
    @objc func openMenu(sender: UIButton!) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func openQRCode(sender: UIButton!) {
        present(QRCodeController(), animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func drawMap(data:XML.Accessor) {
        mapView.delegate = self
        
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        //init the polyline var for the path
        var locations = [CLLocationCoordinate2D]()
        
        //Adding cursors
        //And populating poiTracker dict
        for poi in data {
            //Populating poiTracker dict
            poiList[poi.title.text!] = poi
            poiStateTracker[poi.title.text!] = ParcoursState.State.inactive
                        
            //Creating the annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: poi.lat.double ?? 0, longitude: poi.lng.double ?? 0)
            annotation.title = poi.title.text
            
            //Append the annotation coord to the poyline array
            locations.append(annotation.coordinate)
            
            //Append the annotation to the map
            mapView.addAnnotation(annotation)
        }
        
        //find rect that encloses all coords
        
        var maxLat:Double = -200
        var maxLong:Double = -200
        var minLat:Double = Double(MAXFLOAT)
        var minLong:Double = Double(MAXFLOAT)
        
        for loc in locations {
            if (loc.latitude < minLat) {
                minLat = loc.latitude
            }
            
            if (loc.longitude < minLong) {
                minLong = loc.longitude
            }
            
            if (loc.latitude > maxLat) {
                maxLat = loc.latitude
            }
            
            if (loc.longitude > maxLong) {
                maxLong = loc.longitude
            }
        }
        
        //Center point
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake((maxLat + minLat) * 0.5, (maxLong + minLong) * 0.5);
        
        //Centering view with center point
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: center,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setCenter(center, animated: true)
        
        //Creating the path with polyline
        let path = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(path)
        
        //Append the map to the view
        view.addSubview(mapView)
    }
    
    func getAllPoiFromParcours(idParcours: Int,completion : @escaping (_ dataXML:XML.Accessor) -> ()){
        Alamofire.request("http://jmagine.tokidev.fr/api/parcours/\(idParcours)/get_all_pois")
            .responseData { response in
                if let data = response.data {
                    var poiData:XML.Accessor
                    let xml = XML.parse(data)
                    poiData = xml.list.poi
                    completion(poiData)
                }
        }
    }
    
    func initNavOptions() {
        let closeImage = UIImage(named:"ic_menu")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let favOffImage = UIImage(named:"ic_favorite_border")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let favOnImage = UIImage(named:"ic_favorite")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(openMenu))
        closeButton.tintColor = .black
        
        let favButton = UIBarButtonItem(image: favOffImage, style: .plain, target: self, action: #selector(openMenu))
        favButton.tintColor = .black
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        
        navigationItem.titleView = titleLabel
        titleLabel.text = currParcoursName
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = favButton
    }
    
    //Function for appending the polyline to the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
        if(overlay is MKPolyline) {
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = .black
            polylineRender.lineWidth = 3
            return polylineRender
        }
        return nil
    }
    
    //Function for registering tap event for annotations
    func mapView(_ mapView: MKMapView,didSelect view: MKAnnotationView) {
        if case let poiTitle?? = view.annotation!.title {
            if(poiStateTracker.values.contains(ParcoursState.State.active)){
                //Showing an alert for confirming the poi
                // create the alert
                let msg = "Un POI est déjà actif"
                let alert = UIAlertController(title: "Attention", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            } else {
                //Showing an alert for confirming the poi
                // create the alert
                let msg = "Voulez-vous vraiment commencer par le POI suivant :\n\n\(poiTitle)"
                let alert = UIAlertController(title: "Confirmation", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Oui", style: UIAlertAction.Style.default, handler: { (action) in
                    self.startPOI(poi: poiTitle, pin: view)
                }))
                alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Function for modding the annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "CustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            let img:UIImage = #imageLiteral(resourceName: "ic_location_on_36pt.png")
            annotationView!.image = img
            annotationView!.centerOffset = CGPoint(x:0, y:-img.size.height / 2);
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    //Function for starting a POI
    func startPOI(poi:String, pin:MKAnnotationView) {
        poiStateTracker[poi] = ParcoursState.State.active
        let image:UIImage = #imageLiteral(resourceName: "ic_location_on_36pt")
        pin.image = image.maskWithColor(color: UIColor.JmagineColors.Blue.MainBlue)
        showBottomBar(poi:poi)
    }
    
    func showBottomBar(poi:String) {
        //Defining the bottom control
        let bottomView = UIView(frame: CGRect(x:0, y:(view.frame.size.height - 160), width:view.frame.size.width, height:160))
        bottomView.backgroundColor = UIColor.JmagineColors.Dark.MainDark
        
        //Defining the blue top border
        let topBlueBorder = UIView(frame: CGRect(x:0, y:0, width:view.frame.size.width, height:5))
        topBlueBorder.backgroundColor = UIColor.JmagineColors.Blue.MainBlue
        bottomView.addSubview(topBlueBorder)
        
        //Defining the content area
        let contentViewWidth = bottomView.frame.size.width - 20
        let contentViewHeight = bottomView.frame.size.height - 20
        let contentView = UIView(frame: CGRect(
            x:(bottomView.frame.size.width - contentViewWidth)/2,
            y:(bottomView.frame.size.height - contentViewHeight)/2,
            width:contentViewWidth,
            height:contentViewHeight)
        )
        contentView.backgroundColor = .clear
        
        //Defining the content itself
        let openControlIcon = UIImage(named:"ic_keyboard_arrow_up")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let openControlButton = UIButton(frame: CGRect(x: 0, y: 0, width: openControlIcon?.size.width ?? 0, height: openControlIcon?.size.height ?? 0))
        openControlButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        openControlButton.tintColor = .white
        openControlButton.setImage(openControlIcon, for: .normal)
        contentView.addSubview(openControlButton)
        
        let activeCount = poiStateTracker.filter{ $0.value == ParcoursState.State.active || $0.value == ParcoursState.State.completed }.count
        let totalPoi = poiStateTracker.count
        
        let poiName = UILabel(frame: CGRect(x: 5, y: openControlButton.frame.maxY, width: 0, height: 0))
        poiName.font = UIFont.systemFont(ofSize: 16)
        poiName.textColor = .white
        poiName.text = poi + " (\(activeCount) / \(totalPoi))"
        poiName.sizeToFit()
        contentView.addSubview(poiName)
        
        let poiImg = UIImageView(frame: CGRect(x: 5, y: poiName.frame.maxY + 10, width: 50, height: 50))
        let poiImgUrl:String = poiList[poi]?.backgroundPic.text ?? ""
        poiImg.imageFromURL(urlString: poiImgUrl)
        poiImg.layer.cornerRadius = poiImg.frame.height/2
        poiImg.clipsToBounds = true
        contentView.addSubview(poiImg)
        
        let cursor = UIImageView(frame: CGRect(x: poiName.frame.maxX, y: poiName.frame.minY, width: 20, height: 20))
        cursor.image = #imageLiteral(resourceName: "ic_location_on_48pt.png")
        cursor.image = cursor.image?.maskWithColor(color: UIColor.JmagineColors.Blue.MainBlue)
        contentView.addSubview(cursor)
        
        let distanceInfo = UILabel(frame: CGRect(x: cursor.frame.maxX, y: poiName.frame.minY, width: 0, height: 0))
        distanceInfo.font = UIFont.systemFont(ofSize: 12)
        distanceInfo.textColor = .white
        distanceInfo.text = calculateNextPoiDistance(poi:poi)
        distanceInfo.sizeToFit()
        contentView.addSubview(distanceInfo)
        
        let scanPoiRect = UIView(frame: CGRect(x:contentViewWidth - 55, y:poiName.frame.maxY + 10, width:50, height:50))
        scanPoiRect.backgroundColor = UIColor.JmagineColors.Blue.MainBlue
        
        let qrCodeIcon = UIImage(named:"ic_qrcode")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let scanPoiBtn = UIButton(frame: CGRect(x: (scanPoiRect.frame.width - 40) / 2, y: 0, width: 40, height: 40))
        scanPoiBtn.addTarget(self, action: #selector(openQRCode), for: .touchUpInside)
        scanPoiBtn.tintColor = .black
        scanPoiBtn.setImage(qrCodeIcon, for: .normal)
        scanPoiRect.addSubview(scanPoiBtn)
        
        /* Need working
        let scanPoiText = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        scanPoiText.font = UIFont.systemFont(ofSize: 10)
        scanPoiText.textColor = .black
        scanPoiText.text = "Scan"
        scanPoiText.center.x = scanPoiRect.center.x
        scanPoiText.sizeToFit()
        scanPoiRect.addSubview(scanPoiText)*/
        
        contentView.addSubview(scanPoiRect)
        
        //Appending all the views
        bottomView.addSubview(contentView)
        view.addSubview(bottomView)
    }
    
    func calculateNextPoiDistance(poi:String) -> String {
        let pointLocation = CLLocation(
            latitude:  poiList[poi]?.lat.double ?? 0,
            longitude: poiList[poi]?.lng.double ?? 0
        )
        let distanceMeters = currentCoordinate?.distance(from: pointLocation)
        let distanceKilometers = distanceMeters ?? 0 / 1000.00
        let roundedDistanceKilometers = String(Double(round(100 * distanceKilometers) / 100)) + " km"
        
        if(distanceKilometers < 1) {
            return String(Double(round(distanceMeters!))) + " m"
        }
        return roundedDistanceKilometers
    }
}

//Extension to color UIImage from annotations
extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
}
