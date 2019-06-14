//
//  PCIOEViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/27/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PCIOEViewController: UIViewController {

    @IBOutlet weak var modOrbitLabel: UILabel!
    var isModifyingOrbitPCIOE = false
    let nasaLink = "https://spaceflight.nasa.gov/realdata/elements/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        print("Orbit contained in this controller is: \(self.orbit.name)")
        if isModifyingOrbitPCIOE == true {
            self.modOrbitLabel.text = "Currently Modifying: \(self.orbit.name)"
        } else {
            self.modOrbitLabel.text = ""
        }
//        self.navigationController?.title = self.orbit.name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        // self.isModifyingOrbitPCIOE = false
    }
    
    // MARK: - IBActions
    @IBAction func pciButtonClick(_ sender: UIButton) {
        
    }
    @IBAction func oeButtonClick(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Memory Management
    let defaults = UserDefaults.standard
    var orbit = Orbit(name: String(), rv: [Double](), oe: [Double](), isShown: Bool())
    var selectedIndexPathOfOrbit = -1 // Default is no index path eg. neg int value != indexPath

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pciSegue":
            if let pciController = segue.destination as? PCIController {
                if isModifyingOrbitPCIOE == true {
                    pciController.orbit = self.orbit
                    pciController.selectedIndexPathOfOrbit = self.selectedIndexPathOfOrbit
                    pciController.isModifyingOrbitPCIOE = true
                    print("sent orbit with name and PCI's: \(self.orbit.name) and [\(self.orbit.rv)] to PCIController")
                }
            }
        case "oeSegue":
            if let oeController = segue.destination as? OEController {
                if isModifyingOrbitPCIOE == true {
                    oeController.orbit = self.orbit
                    oeController.selectedIndexPathOfOrbit = self.selectedIndexPathOfOrbit
                    oeController.isModifyingOrbitPCIOE = true
                    print("sent orbit with name & OE's: \(self.orbit.name) and [\(self.orbit.oe)] to OEController")
                }
            }
        default:
            print("error")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
