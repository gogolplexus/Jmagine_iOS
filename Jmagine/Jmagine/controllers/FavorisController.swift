//
//  HomeController.swift
//  Jmagine
//
//  Created by mbds on 02/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import SideMenu
import CoreData

class FavorisController: UIViewController, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    var collectionView : UICollectionView?
    var container: NSPersistentContainer!
    
    var favoris:[Favoris]!
    var favorisCount:Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        initNavOptions()
        view.backgroundColor = UIColor.white
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: NavmenuController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuFadeStatusBar = false
        
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        initFavoris()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favorisCount
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navControl = self.navigationController
        let parcoursId = self.favoris[indexPath.row].parcoursId
        let viewController = ParcoursController()
        
        viewController.currParcours = parcoursId
        viewController.currParcoursName = self.favoris[indexPath.row].parcoursName ?? ""
        viewController.currParcoursImg = self.favoris[indexPath.row].parcoursImg ?? ""
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        viewController.container = appDelegate.persistentContainer
        viewController.modalPresentationCapturesStatusBarAppearance = true
        navControl?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoris", for: indexPath)
        let cellContentFrame = UIView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
        
        let deleteIcon = UIImage(named:"ic_close_48pt")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        
        let parcoursPic = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        parcoursPic.imageFromURL(urlString: self.favoris[indexPath.row].parcoursImg ?? "")
        parcoursPic.layer.cornerRadius = parcoursPic.frame.height/2
        parcoursPic.clipsToBounds = true
        parcoursPic.center.y = cell.center.y
        cellContentFrame.addSubview(parcoursPic)
        
        let title = UILabel(frame: CGRect(x:(parcoursPic.frame.maxX + 10), y:0, width:cellContentFrame.frame.size.width - 70, height: 40))
        title.numberOfLines = 0
        title.font = UIFont.preferredFont(forTextStyle: .body)
        title.adjustsFontForContentSizeCategory = true
        title.text = self.favoris[indexPath.row].parcoursName
        title.tintColor = .black
        title.center.y = cell.center.y
        title.sizeToFit()
        cellContentFrame.addSubview(title)
        
        let deleteBtn = CustomUIButton(frame: CGRect(
            x: (title.frame.maxX + 20),
            y: 0,
            width: 20,
            height: 20))
        deleteBtn.setImage(deleteIcon, for: .normal)
        deleteBtn.tintColor = .black
        deleteBtn.center.y = cell.center.y
        deleteBtn.addTarget(self, action: #selector(self.deleteFromFav(_:)), for:.touchUpInside)
        deleteBtn.params["parcoursId"] = self.favoris[indexPath.row].parcoursId
        deleteBtn.params["indexPath"] = indexPath
        cellContentFrame.addSubview(deleteBtn)
        
        cell.contentView.addSubview(cellContentFrame)
        return cell
    }
    
    @IBAction func deleteFromFav(_ sender: CustomUIButton) {
        let index:Int64 = sender.params["parcoursId"] as! Int64
        let indexPath:IndexPath = sender.params["indexPath"] as! IndexPath
        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        fetchRequest.predicate = NSPredicate(format: "parcoursId = %d", index)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let favToDelete = test[0] as! NSManagedObject
            managedContext.delete(favToDelete)
            do {
                try managedContext.save()
                self.favoris.remove(at: indexPath.row)
                self.favorisCount -= 1
                collectionView?.deleteItems(at: [indexPath])
                
                if(self.favorisCount == 0){
                    self.showEmptyMsg()
                }
            } catch let error {
                print("NSAsynchronousFetchRequest error: \(error)")
            }
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
        
    }
    
    @objc func openMenu(sender: UIButton!) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initNavOptions() {
        let closeImage = UIImage(named:"ic_menu")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        navigationItem.titleView = titleLabel
        titleLabel.text = "Favoris"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        let nextButton = UIBarButtonItem(image: closeImage, style: .plain, target: self, action: #selector(openMenu))
        nextButton.tintColor = .black
        
        navigationItem.leftBarButtonItem = nextButton
    }
    
    func initFavoris() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoris")
        let privateManagedObjectContext = container.viewContext
        
        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            
            // Retrieves an array of dogs from the fetch result `finalResult`
            guard let result = asynchronousFetchResult.finalResult as? [Favoris] else { return }
            
            // Dispatches to use the data in the main queue
            DispatchQueue.main.async {
                if (!result.isEmpty) {
                    self.showFavorites(data:result)
                } else {
                    self.favorisCount = 0
                    self.showEmptyMsg()
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
    
    func showFavorites(data:[Favoris]) {
        self.favoris = data
        self.favorisCount = data.count
        self.initTableView()
    }
    
    func initTableView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.width-50, height: 50)
        
        let frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: self.view.frame.size.width, height: self.view.frame.size.height - view.safeAreaInsets.top)
        
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "favoris")
        self.collectionView!.backgroundColor = .clear
        self.view.addSubview(self.collectionView!)
    }
    
    func showEmptyMsg() {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        emptyLabel.text = "Aucun favoris à afficher"
        emptyLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emptyLabel.textColor = .black
        emptyLabel.adjustsFontForContentSizeCategory = true
        emptyLabel.textAlignment = .center
        emptyLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x:20, y:view.safeAreaInsets.top, width:view.frame.size.width - 10, height:30))
        titleView.addSubview(emptyLabel)
        view.addSubview(titleView)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
}
