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
    
    func getAllPoiFromParcours(idParcours: Int) -> XML.Accessor {
        var res:XML.Accessor? = nil;
        Alamofire.request("http://jmagine.tokidev.fr/api/parcours/\(idParcours)/get_all_pois")
            .responseData { response in
                if let data = response.data {
                    let xml = XML.parse(data)
                    res = xml.list.poi
                }
        }
        return (res)!
    }
    
    func getData(){
        Alamofire.request("http://jmagine.tokidev.fr/api/parcours/get_all")
            .responseData { response in
                if let data = response.data {
                    let xml = XML.parse(data)
                    print(xml.list.parcours[0].id.text ?? "failed")
                }
        }
    }
    
}
