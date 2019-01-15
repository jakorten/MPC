//
//  FabulousAppModel.swift
//  AmazingApps
//
//  Created by J.A. Korten on 21/10/2018.
//  Copyright © 2018 HAN University. All rights reserved.
//

import UIKit


struct FabulousApp : Codable {
    
    let appTitle : String
    let appDescription : String
    let appDevelopers : [String]
    let appImage : Data?
    let reviewScore : Int
    let deviceId : String    
}


