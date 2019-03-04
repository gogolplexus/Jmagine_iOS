//
//  ApiUtils.swift
//  Jmagine
//
//  Created by mbds on 03/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import Alamofire
import SwiftyXMLParser
import XMLParsing

class ApiUtils {
    
    func getData(){
        Alamofire.request("http://jmagine.tokidev.fr/api/parcours/get_all")
            .responseData { response in
                if let data = response.data {
                    let xml = XML.parse(data)
                    guard let data = xml.data(using: .utf8) else { return }
                    let note = try? XMLDecoder().decode(Parcours.self, from: data)
                    print(xml.list.parcours[0] ?? "failed")
                }
        }
    }
    
}
