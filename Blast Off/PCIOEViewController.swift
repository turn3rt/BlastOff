//
//  PCIOEViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/27/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PCIOEViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - IBActions
    @IBAction func pciButtonClick(_ sender: UIButton) {
        
    }
    @IBAction func oeButtonClick(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Memory Management
    let defaults = UserDefaults.standard
    let orbit = Orbit(name: String(), rv: [Double](), oe: [Double](), isShown: Bool())
    var selectedIndexPathOfOrbit = -1 // Default is no index path eg. neg int value != indexPath

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "pciSegue":
            if let pciController = segue.destination as? PCIController {
                pciController.orbit = self.orbit
                pciController.selectedIndexPathOfOrbit = self.selectedIndexPathOfOrbit
                print("pciSegue Success")
            }
        case "oeSegue":
            if let oeController = segue.destination as? OEController {
                oeController.orbit = self.orbit
                oeController.selectedIndexPathOfOrbit = self.selectedIndexPathOfOrbit
                print("oeSegue Success")
            }
        default:
            print("error")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
