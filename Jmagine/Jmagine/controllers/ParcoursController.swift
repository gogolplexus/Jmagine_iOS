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
import CoreData

class ParcoursController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, QRCodeDelegate {
    var container: NSPersistentContainer!
    
    var currParcours:Int = 0
    var currParcoursName:String = ""
    var currParcoursImg:String = ""
    var poiList = [String: XML.Accessor]()
    var poiStateTracker = [String: ParcoursState.State]()
    var currPoi:XML.Accessor?
    var isInFav:Bool?
    
    var instructionsRead:Bool = false
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocation?
    var currPin:MKAnnotationView?
    var mapView:MKMapView = MKMapView()
    
    var maxLat:Double = -200
    var maxLong:Double = -200
    var minLat:Double = Double(MAXFLOAT)
    var minLong:Double = Double(MAXFLOAT)
    
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
        
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        self.renderFavoris()
        
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
    
    func openCtrl() {
        let modalViewController = ParcoursDetailController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.poiList = poiList
        modalViewController.poiStateTracker = poiStateTracker
        modalViewController.maxLat = self.maxLat
        modalViewController.minLat = self.minLat
        modalViewController.maxLong = self.maxLong
        modalViewController.minLong = self.minLong
        present(modalViewController, animated: true, completion: nil)
    }
    
    @objc func openQRCode(sender: UIButton!) {
        let modalViewController = QRCodeController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.delegate = self
        present(modalViewController, animated: true, completion: nil)
        //self.dataChanged(str:"jmagine-poi-6")
    }
    
    func checkIfRightPoiScanned(idScannedPoi:Int) -> Bool {
        if(idScannedPoi == currPoi?.id.int) {return true}
        return false
    }
    
    func validateCurrentPoi() {
        let poiTitle = currPoi?.title.text
        poiStateTracker[poiTitle ?? ""] = ParcoursState.State.completed
        
        let image:UIImage = #imageLiteral(resourceName: "ic_location_on_36pt")
        currPin?.image = image.maskWithColor(color: UIColor.JmagineColors.Green.MainGreen)
        currPoi = nil
        currPin = nil
        
        view.viewWithTag(100)!.removeFromSuperview()
    }
    
    func checkIfParcoursCompleted() -> Bool {
        if(!poiStateTracker.values.contains(ParcoursState.State.inactive)) {
            return true
        } else {
            return false
        }
    }
    
    func dataChanged(str: String) {
        let index:String = str.replacingOccurrences(of: "jmagine-poi-", with: "", options: NSString.CompareOptions.literal, range:nil)
        let data:Int = Int(index) ?? 0
        
        if (checkIfRightPoiScanned(idScannedPoi:data)) {
            validateCurrentPoi()
            if(self.checkIfParcoursCompleted()){
                let alert = UIAlertController(title: "Félicitations!", message: "Vous avez terminé le parcours !", preferredStyle: UIAlertController.Style.alert)
                
                // add the button
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Félicitations!", message: "Vous venez de débloquer le POI : \(data)", preferredStyle: UIAlertController.Style.alert)
                
                // add the button
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Attention", message: "Vous n'avez pas scanné le bon POI : \(data)", preferredStyle: UIAlertController.Style.alert)
            
            // add the button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
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
        for loc in locations {
            if (loc.latitude < minLat) {
                self.minLat = loc.latitude
            }
            
            if (loc.longitude < minLong) {
                self.minLong = loc.longitude
            }
            
            if (loc.latitude > maxLat) {
                self.maxLat = loc.latitude
            }
            
            if (loc.longitude > maxLong) {
                self.maxLong = loc.longitude
            }
        }
        
        //Center point
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake((self.maxLat + self.minLat) * 0.5, (self.maxLong + self.minLong) * 0.5);
        
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
        
        let closeButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(openMenu))
        closeButton.tintColor = .black
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        
        navigationItem.titleView = titleLabel
        titleLabel.text = currParcoursName
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        navigationItem.leftBarButtonItem = closeButton
    }
    
    func initFavoris(isInFav:Bool){
        self.isInFav = isInFav
        var favImage = UIImage(named:"ic_favorite_border")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        if (isInFav) {
            favImage = UIImage(named:"ic_favorite")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
        }
        
        let favButton = UIBarButtonItem(image: favImage, style: .plain, target: self, action: #selector(updateFavoris))
        favButton.tintColor = .black
        navigationItem.rightBarButtonItem = favButton
    }
    
    @objc func updateFavoris() {
        let managedContext = container.viewContext
        if(isInFav!) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
            fetchRequest.predicate = NSPredicate(format: "parcoursId = %d", currParcours)
            
            do {
                let test = try managedContext.fetch(fetchRequest)
                let favToDelete = test[0] as! NSManagedObject
                managedContext.delete(favToDelete)
                do {
                    try managedContext.save()
                    var favImage = UIImage(named:"ic_favorite_border")?.withRenderingMode(
                        UIImage.RenderingMode.alwaysTemplate)
                    let favButton = UIBarButtonItem(image: favImage, style: .plain, target: self, action: #selector(updateFavoris))
                    favButton.tintColor = .black
                    navigationItem.rightBarButtonItem = favButton
                } catch let error {
                    print("NSAsynchronousFetchRequest error: \(error)")
                }
            } catch let error {
                print("NSAsynchronousFetchRequest error: \(error)")
            }
        } else {
            let favorisEntity = NSEntityDescription.entity(forEntityName: "Favoris", in: managedContext)!
            
            let favoris = NSManagedObject(entity: favorisEntity, insertInto: managedContext)
            favoris.setValue(currParcours, forKey: "parcoursId")
            favoris.setValue(currParcoursName, forKey: "parcoursName")
            favoris.setValue(currParcoursImg, forKey: "parcoursImg")
            
            print(currParcours)
            print(currParcoursName)
            print(currParcoursImg)
            
            do {
                try managedContext.save()
                let favImage = UIImage(named:"ic_favorite")?.withRenderingMode(
                    UIImage.RenderingMode.alwaysTemplate)
                let favButton = UIBarButtonItem(image: favImage, style: .plain, target: self, action: #selector(updateFavoris))
                favButton.tintColor = .black
                navigationItem.rightBarButtonItem = favButton
            } catch let error {
                print("NSAsynchronousFetchRequest error: \(error)")
            }
        }
    }
    
    func renderFavoris() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        fetchRequest.predicate = NSPredicate(format: "parcoursId = %d", currParcours)
        let privateManagedObjectContext = container.newBackgroundContext()
        
        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            
            // Retrieves an array of dogs from the fetch result `finalResult`
            guard let result = asynchronousFetchResult.finalResult as? [Favoris] else { return }
            
            // Dispatches to use the data in the main queue
            DispatchQueue.main.async {
                if (!result.isEmpty) {
                    print(result[0].parcoursId)
                    self.initFavoris(isInFav:true)
                } else {
                    print(result)
                    self.initFavoris(isInFav:false)
                }
            }
        }
        
        do {
            // Executes `asynchronousFetchRequest`
            try privateManagedObjectContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
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
            } else if(poiStateTracker[poiTitle] == ParcoursState.State.completed) {
                //Showing an alert for confirming the poi
                // create the alert
                let msg = "Vous avez déjà validé ce POI"
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
        currPoi = poiList[poi]
        currPin = pin
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
        
        let openControlButton = UIButton(frame: CGRect(x: (contentViewWidth - (openControlIcon?.size.width ?? 0)) / 2, y: 0, width: openControlIcon?.size.width ?? 0, height: openControlIcon?.size.height ?? 0))
        //openControlButton.addTarget(self, action: #selector(openCtrl), for: .touchUpInside)
        openControlButton.tintColor = .white
        openControlButton.setImage(openControlIcon, for: .normal)
        contentView.addSubview(openControlButton)
        
        let activeCount = poiStateTracker.filter{ $0.value == ParcoursState.State.active || $0.value == ParcoursState.State.completed }.count
        let totalPoi = poiStateTracker.count
        
        let poiName = UILabel(frame: CGRect(x: 5, y: openControlButton.frame.maxY, width: 0, height: 0))
        poiName.font = UIFont.preferredFont(forTextStyle: .headline)
        poiName.adjustsFontForContentSizeCategory = true
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
        distanceInfo.font = UIFont.preferredFont(forTextStyle: .body)
        distanceInfo.adjustsFontForContentSizeCategory = true
        distanceInfo.textColor = .white
        distanceInfo.text = calculateNextPoiDistance(poi:poi)
        distanceInfo.sizeToFit()
        contentView.addSubview(distanceInfo)
        
        let scanPoiRect = UIView(frame: CGRect(x:contentViewWidth - 55, y:poiName.frame.maxY + 10, width:50, height:70))
        scanPoiRect.backgroundColor = .clear
        
        let qrCodeIcon = UIImage(named:"ic_center_focus_weak_48pt")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let scanPoiBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        scanPoiBtn.addTarget(self, action: #selector(openQRCode), for: .touchUpInside)
        scanPoiBtn.tintColor = UIColor.JmagineColors.Blue.MainBlue
        scanPoiBtn.setImage(qrCodeIcon, for: .normal)
        scanPoiRect.addSubview(scanPoiBtn)
        
        let scanPoiText = UILabel(frame: CGRect(x: 0, y: scanPoiBtn.frame.maxY, width: 50, height: 20))
        scanPoiText.font = UIFont.preferredFont(forTextStyle: .footnote)
        scanPoiText.adjustsFontForContentSizeCategory = true
        scanPoiText.textColor = UIColor.JmagineColors.Blue.MainBlue
        scanPoiText.text = "Scan"
        scanPoiText.sizeToFit()
        scanPoiText.textAlignment = .center
        scanPoiText.center = CGPoint(x:scanPoiRect.frame.width / 2, y:4 * scanPoiRect.frame.height / 5)
        scanPoiRect.addSubview(scanPoiText)
        
        contentView.addSubview(scanPoiRect)
        
        //Appending all the views
        bottomView.addSubview(contentView)
        bottomView.tag = 100
        view.addSubview(bottomView)
        
        //Adding gesture
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleBottomBarGesture(gesture:)))
        swipeUp.direction = .up
        bottomView.addGestureRecognizer(swipeUp)
    }
    
    @objc func handleBottomBarGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            openCtrl()
        }
    }
    
    func calculateNextPoiDistance(poi:String) -> String {
        let pointLocation = CLLocation(
            latitude:  poiList[poi]?.lat.double ?? 0,
            longitude: poiList[poi]?.lng.double ?? 0
        )
        
        let distanceMeters = currentCoordinate?.distance(from: pointLocation) ?? 0.0
        let distanceKilometers = distanceMeters / 1000.00
        let roundedDistanceKilometers = String(Double(round(100 * distanceKilometers) / 100)) + " km"
        
        if(distanceKilometers < 1) {
            return String(Double(round(distanceMeters))) + " m"
        }
        return roundedDistanceKilometers
    }
    
    override open var shouldAutorotate: Bool {
        return false
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

