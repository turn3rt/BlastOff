//
//  HomeViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/24/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ARViewControllerDelegate {
    // MARK: - Protocol stubs
    func finishTutorial(isInTutorialMode: Bool) { // executes in ARViewController when user clicks the back button
        self.isInTutorialMode = isInTutorialMode
    }
    

    // MARK: - IBOutlets
    @IBOutlet weak var topMargin: NSLayoutConstraint! // default is 80 - normalized for iPhone X, XS
    @IBOutlet weak var midMargin: NSLayoutConstraint! // default is 64 - normalized for iPhone X, XS
    @IBOutlet weak var botMargin: NSLayoutConstraint! // default is 88 - normalized for iPhone X, XS

    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var tutorialAboutStack: UIStackView!
    
    var isInTutorialMode = Bool()
    
    // MARK: - Override Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        configureAutoLayoutForDevice()
        showUserDefaultValues()
        
        if isInTutorialMode {
            modifyButton.isHidden = true
            newButton.isHidden = true
            tutorialAboutStack.isHidden = true
            
            launchButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 60.0, // springloads button
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.01),
                           initialSpringVelocity: CGFloat(0.064),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                            self.launchButton.transform = CGAffineTransform.identity
            }, completion: { Void in })
            
        } else {
            modifyButton.isHidden = false
            newButton.isHidden = false
            tutorialAboutStack.isHidden = false
        }
    }

    
     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let arController = segue.destination as? ARViewController {
            arController.isInTutorialMode = self.isInTutorialMode
            arController.tutorialDelegate = self
        }
    }
    
    
    // MARK: - Internal Functions
    func configureAutoLayoutForDevice() -> () {
        print("Native Device Height: \(UIScreen.main.nativeBounds.height)")
        if UIDevice().userInterfaceIdiom == .phone || UIDevice().userInterfaceIdiom == .pad  {
            switch UIScreen.main.nativeBounds.height {
            // iPhones
            case 1136:
                print("iPhone 5 or 5S or 5C or SE")
                topMargin.constant = 32
                midMargin.constant = 32
                botMargin.constant = 42
                
            case 1334:
                print("iPhone 6/6S/7/8")
                topMargin.constant = 64
                midMargin.constant = 42
                botMargin.constant = 64
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                midMargin.constant = 48
                botMargin.constant = 48
                
            case 2340: // @TODO: Marginalize
                print("iPhone 12 Mini, 13 Mini")
                
            case 2436:
                // All margins are normalized to this
                print("iPhone X, XS, 11 Pro")
                
            case 2532: // @TODO: Marginalize (DONE)
                print("iPhone 12, 12 Pro, 13, 13 Pro")
                
            case 2688:
                print("iPhone XS Max, XS Pro Max, 11 Pro Max")
                topMargin.constant = 120
                
            case 2778:// @TODO: Marginalize (DONE)
                print("iPhone 12 Pro Max, 13 Pro Max")
                topMargin.constant = 120
                
            case 1792:
                print("iPhone XR, 11")
                topMargin.constant = 120
                
            // iPads
            case 2048:
                print("iPad Mini, Air, Pro 9.7in")
                topMargin.constant = 200
                
            case 1668, 2224:
                print("iPad Pro 10.5in")
                topMargin.constant = 240
                midMargin.constant = 80
                botMargin.constant = 72

            case 2388:
                print("iPad Pro 11in")
                topMargin.constant = 240
                midMargin.constant = 120
                botMargin.constant = 100
                
            case 2732:
                print("iPad Pro 12.9in")
                topMargin.constant = 300
                midMargin.constant = 180
                botMargin.constant = 150
                
            default:
                print("Unknown Device")
                
            }
        }
    }
    
    func showUserDefaultValues() -> () {
        print("printing key value pairs for NS UserDefaults: ")
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
    }
    
    // MARK: - IBActions
//    @IBAction func launchButtonClick(_ sender: UIButton) {
//        if self.isInTutorialMode {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "ARvc") as! ARViewController
//            vc.isInTutorialMode = true
//        }
//    }
    
}
