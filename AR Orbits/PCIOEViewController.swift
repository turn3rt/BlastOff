//
//  PCIOEViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/27/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PCIOEViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var topPar: UILabel!
    @IBOutlet weak var modOrbitLabel: UILabel!
    @IBOutlet weak var botPar: UILabel!
    @IBOutlet weak var nasaLinkButton: UIButton!
    @IBOutlet weak var pciButton: UIButton!
    @IBOutlet weak var oeButton: UIButton!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer! // attatched to modOrbitLabel [Planet]
    
    var isModifyingOrbitPCIOE = false
    var isInTutorialMode = false
    let nasaLink = "https://spaceflight.nasa.gov/realdata/elements/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        print("Orbit contained in this controller is: \(self.orbit.name)")
        if isModifyingOrbitPCIOE == true {
            topPar.text = "Here, you can edit the initial starting position & velocity of the \(self.orbit.name) in Planet Centered Inertial (PCI) coordinates."
            modOrbitLabel.text = ""
            botPar.text = "Typically, it is easier to maniuplate the Orbital Elements (OE's) of the \(self.orbit.name). They are quantified by N.A.S.A the link below."
        }
        if isInTutorialMode == true {
            nasaLinkButton.isHidden = true
            pciButton.isHidden = true
            oeButton.isHidden = true
            tapRecognizer.isEnabled = true 
            botPar.text = "More commonly, six orbital elements (OE's) describe the orbit. Tap the planet to continue the tutorial."
        }
        
        
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
    
    @IBAction func didTapHyperlink(_ sender: UIButton) {
        if let url = URL(string: nasaLink) {
            UIApplication.shared.open(url)
        }
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
    @IBAction func planetTap(_ sender: Any) {
        print("Yeet")
    }
    
    
   // MARK: - IBActions
    

}
