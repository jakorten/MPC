//
//  ViewController.swift
//  AmazingAppController
//
//  Created by J.A. Korten on 21/10/2018.
//  Copyright © 2018 HAN University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var appTitleEdit: UITextField!
    
    @IBOutlet weak var appDescriptionTextView: UITextView!
    
    @IBOutlet weak var appDeveloperStudentsTextView: UITextView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var yourAppImage : UIImage?

    @IBOutlet weak var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func submitSplendidAppInfo(_ sender: UIButton) {
        
        // prepare data
        if let devData = prepareData() {
            appDelegate.ptpManagerService.send(info: devData)
            if let img = yourAppImage {
                appDelegate.ptpManagerService.sendImage(img: img)
            }
        }
        
    }
    
    func prepareData() -> String? {
        var developers = appDeveloperStudentsTextView.text.components(separatedBy: "\n")
        
        developers = developers.filter{ $0 != "" }
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        
        let fabulousAppInfo = FabulousApp(appTitle: appTitleEdit.text ?? "", appDescription: appDescriptionTextView.text, appDevelopers: developers, appImage: nil, reviewScore: 5, deviceId: device_id)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try encoder.encode(fabulousAppInfo)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        yourAppImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.previewImage.contentMode = .scaleAspectFit
        self.previewImage.image = yourAppImage
        picker.dismiss(animated: true, completion: nil)
        
        //uploadImage(image)
    }

    
}
