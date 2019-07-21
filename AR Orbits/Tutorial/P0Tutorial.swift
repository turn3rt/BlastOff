//
//  P0Tutorial.swift
//  AR Orbits
//
//  Created by Turner Thornberry on 7/3/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class P0Tutorial: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var midMargin: NSLayoutConstraint!
    @IBOutlet weak var logoWidth: NSLayoutConstraint!
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        configureAutoLayoutForDevice()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true 
    }
    
    
    // MARK: - IBActions
    
    @IBAction func newOrbitTutClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PCIOEvc") as! PCIOEViewController
        vc.isInTutorialMode = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func modOrbitTutClick(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrbitsTBVC") as! OrbitsTableViewController
        vc.isInModTutorialMode = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Internal Functions
    func configureAutoLayoutForDevice() -> () {
        print("Native Device Height: \(UIScreen.main.nativeBounds.height)")
        if UIDevice().userInterfaceIdiom == .phone || UIDevice().userInterfaceIdiom == .pad  {
            switch UIScreen.main.nativeBounds.height {
            // iPhones
            case 1136:
                print("iPhone 5 or 5S or 5C or SE")
                topMargin.constant = 16 + 42
                midMargin.constant = 16
                logoWidth.constant = 125
                logoHeight.constant = 125
                
            case 1334:
                print("iPhone 6/6S/7/8")
                topMargin.constant = 32 + 42
                midMargin.constant = 24
       
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                topMargin.constant = 64 + 42
                midMargin.constant = 50
    
            case 2436:
                print("iPhone X, XS") // TODO: Fix these by adding 42 to all top margins
                topMargin.constant = 64 + 42
                midMargin.constant = 52
                
            case 2688:
                print("iPhone XS Max")
                topMargin.constant = 64 + 64
                midMargin.constant = 64


            case 1792:
                print("iPhone XR")
                topMargin.constant = 64 + 64
                midMargin.constant = 64

                
            // iPads
            case 2048:
                print("iPad Mini, Air, Pro 9.7in") // this is what i own
                topMargin.constant = 42  + 42
                midMargin.constant = 64
                logoWidth.constant = 200
                logoHeight.constant = 200
                
            case 1668, 2224:
                print("iPad Pro 10.5in")
                topMargin.constant = 42  + 64
                midMargin.constant = 72
                logoWidth.constant = 200
                logoHeight.constant = 200
                
                
            case 2388:
                print("iPad Pro 11in")
                topMargin.constant = 64  + 64
                midMargin.constant = 72
                logoWidth.constant = 200
                logoHeight.constant = 200
                
            case 2732:
                print("iPad Pro 12.9in")
                topMargin.constant = 64  + 64
                midMargin.constant = 72
                logoWidth.constant = 200
                logoHeight.constant = 200

            default:
                print("Unknown Device")
                
            }
        }
    }

    
    
}
