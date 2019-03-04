//
//  ParcoursModel.swift
//  Jmagine
//
//  Created by mbds on 03/03/2019.
//  Copyright © 2019 mbds. All rights reserved.
//

import Foundation

struct Parcours: Codable
{
    var id: Int
    var title: String
    var backgroundPic: URL
    var components: [String:Components]
    var first_poi: Int
}

struct Components: Codable
{
    var title: String
    var backgroundPic: URL
    var content: String
}
