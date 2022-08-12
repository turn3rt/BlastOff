//
//  AboutViewController.swift
//  AR Orbits
//
//  Created by Turner Thornberry on 7/6/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var gatorsLogo: UIImageView!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var middleStackHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var donateWidth: NSLayoutConstraint!
    @IBOutlet weak var donateHeight: NSLayoutConstraint!
    @IBOutlet weak var donateButton: UIButton!

    @IBOutlet weak var topLogoGap: NSLayoutConstraint!
    @IBOutlet weak var botLogoGap: NSLayoutConstraint!
    @IBOutlet weak var middleGap: NSLayoutConstraint!
    @IBOutlet weak var bottomGap: NSLayoutConstraint!
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true
//        configureAutoLayoutForDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        configureAutoLayoutForDevice()
        
        donateButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 60.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.01),
                       initialSpringVelocity: CGFloat(0.064),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.donateButton.transform = CGAffineTransform.identity
        }, completion: { Void in })

    }

    
    // MARK: - IBActions
    
    @IBAction func donateClick(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Development in Progress...", message: "The in In-App Purchase API will be linked prior to public release", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
//        self.present(alert, animated: true)
        self.donateButton.layer.removeAllAnimations()
        if let url = URL(string: "https://venmo.com/code?user_id=1510494607245312527") {
            UIApplication.shared.open(url)
        }
    }
    
    // TODO: Implement after public release, link to app store review page
    @IBAction func rateClick(_ sender: UIButton) {
        //        let alert = UIAlertController(title: "Development in Progress...", message: "The in In-App Purchase API will be linked prior to public release", preferredStyle: .alert)
        //        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
        //        self.present(alert, animated: true)
        self.donateButton.layer.removeAllAnimations()
        if let url = URL(string: "https://venmo.com/code?user_id=1510494607245312527") {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Internal Functions
    func configureAutoLayoutForDevice() -> () { // TODO: Finish this
        print("Native Device Height: \(UIScreen.main.nativeBounds.height)")
        if UIDevice().userInterfaceIdiom == .phone || UIDevice().userInterfaceIdiom == .pad  {
            switch UIScreen.main.nativeBounds.height {
            // iPhones
            case 1136:
                print("iPhone 5 or 5S or 5C or SE")
               // NOTE: Logo was referring to gators logo which was deleted in 2022
               // logoHeight.constant = 60 // default 85
               // logoWidth.constant = 175 // default 250
                middleStackHeight.constant = 100 // default 150
                bottomStackHeight.constant = 100 // default 150
                
                topLogoGap.constant = 0
                botLogoGap.constant = 16
                middleGap.constant = 0
                bottomGap.constant = 16 // default: 32
                
                donateWidth.constant = 175  // default 175
                donateHeight.constant = 36 // defalt 36
                
            case 1334:
                print("iPhone 6/6S/7/8/SE 2")
                // NOTE: Logo was referring to gators logo which was deleted in 2022
                //logoHeight.constant = 60 // default 85
                //logoWidth.constant = 175 // default 250
                
                middleStackHeight.constant = 125 // default 150
                bottomStackHeight.constant = 125 // default 150
          
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                middleStackHeight.constant = 125 // default 150
                bottomStackHeight.constant = 125 // default 150
                
            case 2436:
                // All margins are normalized to this
                print("iPhone X, XS")
                
            case 2688:
                print("iPhone XS Max")
                
            case 1792:
                print("iPhone XR")
                
            // iPads
            case 2048:
                print("iPad Mini, Air, Pro 9.7in")
                //logoHeight.constant = 100
                //logoWidth.constant = 300
                middleStackHeight.constant = 175
                bottomStackHeight.constant = 175
                
                topLogoGap.constant = 8
                botLogoGap.constant = 32
                middleGap.constant = 0
                bottomGap.constant = 42 // default: 32
                
                donateWidth.constant = 270  // default 175
                donateHeight.constant = 42 // defalt 36
                
            case 1668, 2224:
                print("iPad Pro 10.5in")
                logoHeight.constant = 100
                logoWidth.constant = 300
                middleStackHeight.constant = 175
                bottomStackHeight.constant = 175
                
                topLogoGap.constant = 8
                botLogoGap.constant = 32
                middleGap.constant = 0
                bottomGap.constant = 42 // default: 32
                
                donateWidth.constant = 270  // default 175
                donateHeight.constant = 42 // defalt 36
                
            case 2388:
                print("iPad Pro 11in")
                logoHeight.constant = 125
                logoWidth.constant = 360
                middleStackHeight.constant = 225
                bottomStackHeight.constant = 225
                
                middleGap.constant = 32
                
                donateWidth.constant = 360  // default 175
                donateHeight.constant = 50 // defalt 36

            case 2732:
                print("iPad Pro 12.9in")
                logoHeight.constant = 150
                logoWidth.constant = 400
                middleStackHeight.constant = 250
                bottomStackHeight.constant = 250
                
                middleGap.constant = 32
                
                donateWidth.constant = 360  // default 175
                donateHeight.constant = 60 // defalt 36
                
                
            default:
                print("Unknown Device")
                
            }
        }
    }

}
