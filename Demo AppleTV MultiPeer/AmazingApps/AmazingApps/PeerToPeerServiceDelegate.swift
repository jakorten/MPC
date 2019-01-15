//
//  PeerToPeerServiceDelegate.swift
//  AmazingApps
//
//  Created by J.A. Korten on 23/10/2018.
//  Copyright © 2018 HAN University. All rights reserved.
//

import Foundation
import MultipeerConnectivity


protocol PeerToPeerServiceDelegate {
    
    func connectedDevicesChanged(manager : PeerToPeerConnectionManager, connectedDevices: [String])
    func infoChanged(manager : PeerToPeerConnectionManager, infoString: String)
    func imageInfoChanged(manager : PeerToPeerConnectionManager, imageData: Data)

}
