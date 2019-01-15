//
//  MainViewController.swift
//  AmazingApps
//
//  Created by J.A. Korten on 21/10/2018.
//  Copyright © 2018 HAN University. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    
    var sliderTimer : Timer!
    var currentSlideIndex = 0
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var appTitleLabel: UILabel!
    
    @IBOutlet weak var appDescriptionLabel: UILabel!
    
    @IBOutlet weak var appDevelopersLabel: UILabel!
    
    @IBOutlet weak var appRatingLabel: UILabel!
    
    @IBOutlet weak var appImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sliderTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(slideSlider), userInfo: nil, repeats: true)
        
        appTitleLabel.fadeTransition(0.6)
        appDescriptionLabel.fadeTransition(0.6)
        appDevelopersLabel.fadeTransition(0.6)
        appRatingLabel.fadeTransition(0.6)

    }
    
    @objc func slideSlider() {
        if (currentSlideIndex < appDelegate.fabulousApps.count - 1) {
            currentSlideIndex = currentSlideIndex + 1
        } else {
            currentSlideIndex = 0
        }
        let currentSlide = appDelegate.fabulousApps[currentSlideIndex]
        showNewSlider(currentSlide: currentSlide)
    }

    func showNewSlider(currentSlide : FabulousApp) {
        // slideView from main storyboard
        appTitleLabel.fadeTransition(0.6)
        appDescriptionLabel.fadeTransition(0.6)
        appDevelopersLabel.fadeTransition(0.6)
        appRatingLabel.fadeTransition(0.6)
        appImageView.fadeTransition(0.6)
        
        self.appTitleLabel.text = currentSlide.appTitle
        self.appDescriptionLabel.text = currentSlide.appDescription
        var devNames = ""
        for developer in currentSlide.appDevelopers {
            devNames = devNames + "\(developer)\n"
        }
        self.appDevelopersLabel.text = devNames
        // currentSlide.reviewScore
        // Others think your app is: ★★★★☆
        let filledStar = "★"
        let emptyStar = "☆"
        
        var rating = currentSlide.reviewScore
        var ratingText = ""
        for _ in 1...5 {
            if rating > 0 {
                ratingText = ratingText + filledStar
            } else {
                ratingText = ratingText + emptyStar
            }
            rating = rating - 1
        }
        
        self.appRatingLabel.text = "Others think your app is: \(ratingText)"
        
        guard let imageData = currentSlide.appImage else { return }
        
        if let image = UIImage(data: imageData) {
            appImageView.image = image
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.moveIn
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
