//
//  NavmenuController.swift
//  Jmagine
//
//  Created by mbds on 24/02/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import UIKit
import SideMenu

class NavmenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let myArray: NSArray = ["First","Second","Third"]
    private var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.red
        customizeMenu()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Show modal", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.view.addSubview(myTableView)
        self.view.addSubview(button)
    }
    
    func customizeMenu(){
        SideMenuManager.default.menuWidth = self.view.frame.width
    }
    
    @objc func buttonAction(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
}
