//
//  AppDelegate.swift
//  AmazingApps
//
//  Created by J.A. Korten on 21/10/2018.
//  Copyright © 2018 HAN University. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var fabulousApps: [FabulousApp] = []
    
    let ptpManagerService = PeerToPeerConnectionManager()
    var lastPeerDeviceId : String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let developers = ["Bart van der Wal", "Jille Treffers", "Robert Holwerda", "Lars Tijsma", "Johan Korten"]
        
        var myImage : Data?
        if let img = UIImage(named: "Image") {
            myImage = img.pngData()
        }
        
        
        let myFabulousApp = FabulousApp.init(appTitle: "My Fabulous App", appDescription: "This amazing app allows students to present their magnificent work using an Apple TV. It also allows others to rate their app :)", appDevelopers: developers, appImage: myImage, reviewScore: 4, deviceId: "")
        
        fabulousApps.append(myFabulousApp)

        // ... do other important app-wide things
        
        ptpManagerService.delegate = self

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func addInfoToModel(info : String) {
            if let jsonData = info.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    let appData = try decoder.decode(FabulousApp.self, from: jsonData)
                    print("Info for: \(appData.appTitle) found from device: \(appData.deviceId)!")

                    // Add to Model if deviceId does not exist, otherwise only update data
                    lastPeerDeviceId = appData.deviceId

                    var counter = 0
                    for app in fabulousApps {
                        if app.deviceId == lastPeerDeviceId {
                            fabulousApps[counter] = appData
                            return
                        }
                        counter += 1
                    }
                    fabulousApps.append(appData)
                    
                    // ToDo: send notification to listening viewcontrollers that app data was modified
                    // We won't need it since we will update the Slideshow using a timer from the model.
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

extension AppDelegate : PeerToPeerServiceDelegate {    
    
    func imageInfoChanged(manager: PeerToPeerConnectionManager, imageData: Data) {
        // try to add uiimage to model
        if (lastPeerDeviceId != nil) {
            var counter = 0
            for app in fabulousApps {
                if app.deviceId == lastPeerDeviceId {
                    fabulousApps[counter].appImage = imageData
                    return
                }
                counter = counter + 1
            }
        }
    }
    
    
    func connectedDevicesChanged(manager: PeerToPeerConnectionManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("Connections: \(connectedDevices)")
        }
    }
    
    func infoChanged(manager: PeerToPeerConnectionManager, infoString: String) {
        OperationQueue.main.addOperation {
            self.addInfoToModel(info: infoString)
        }
    }
}

