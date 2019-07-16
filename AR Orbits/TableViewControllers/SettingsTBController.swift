//
//  SettingsTBController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/26/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class SettingsTBController: UITableViewController {
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var fractionLabel: UILabel!
    @IBOutlet weak var orbitOriginLabel: UILabel!
    @IBOutlet weak var cameraFeedLabel: UILabel!
    @IBOutlet weak var worldOriginLabel: UILabel!
    
    @IBOutlet weak var sizeControl: UISegmentedControl!
    @IBOutlet weak var fractionControl: UISegmentedControl!
    @IBOutlet weak var worldOriginSwitch: UISwitch!
    @IBOutlet weak var orbitOriginSwitch: UISwitch!
    @IBOutlet weak var cameraFeedSwitch: UISwitch!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var numOfOrbitsLabel: UILabel!


    
    // MARK: - IBActions
    @IBAction func doneButtonClick(_ sender: UIBarButtonItem) {
        if !isInTutorialMode {
            self.navigationController?.popViewController(animated: true) // TODO: pop to ARController
            self.navigationController?.navigationBar.barTintColor = UIColor.black
        }
    }
//    @IBAction func editClick(_ sender: UIButton) {
//        if isInTutorialMode {
//            let vc = storyboard?.instantiateViewController(withIdentifier: "OrbitsTBVC") as! OrbitsTableViewController
//            vc.isInTutorialMode = true
//        }
//    }
    
    
    
    @IBAction func sizeControlChange(_ sender: UISegmentedControl) {
        switch sizeControl.selectedSegmentIndex {
        case 0: // small
            scaleFactor = 300000.0
            defaults.set(scaleFactor, forKey: "scaleFactor")
            print("New sizeControl index: \(sizeControl.selectedSegmentIndex), with new scaleFactor Value: \(scaleFactor)")
        case 1: // medium
            scaleFactor = 200000.0 // default case
            defaults.set(scaleFactor, forKey: "scaleFactor")
            print("New sizeControl index: \(sizeControl.selectedSegmentIndex), with new scaleFactor Value: \(scaleFactor)")
        case 2: // large
            scaleFactor = 100000.0
            defaults.set(scaleFactor, forKey: "scaleFactor")
            print("New sizeControl index: \(sizeControl.selectedSegmentIndex), with new scaleFactor Value: \(scaleFactor)")
        case 3: // gigantic
            scaleFactor = 50000.0
            defaults.set(scaleFactor, forKey: "scaleFactor")
            print("New sizeControl index: \(sizeControl.selectedSegmentIndex), with new scaleFactor Value: \(scaleFactor)")
        default:
            print("sizeControl.selectedSegmentIndex err with selection index")
        }
        
        sizeValue = sizeControl.selectedSegmentIndex
        defaults.set(sizeValue, forKey: "sizeValue")
    }
    
    @IBAction func fractionControlChange(_ sender: UISegmentedControl) {
        print("New fractionControl index: \(fractionControl.selectedSegmentIndex)")
        fractionValue = fractionControl.selectedSegmentIndex
        defaults.set(fractionValue, forKey: "fractionValue")
    }
    
    @IBAction func worldOriginChange(_ sender: UISwitch) {
        print("New worldOrigin State: \(worldOriginSwitch.isOn)")
        worldOriginIsShown = worldOriginSwitch.isOn
        defaults.set(worldOriginIsShown, forKey: "worldOriginIsShown")
    }
    
    @IBAction func orbitOriginChange(_ sender: UISwitch) {
        print("New orbitOrigin State: \(orbitOriginSwitch.isOn)")
        orbitOriginIsShown = orbitOriginSwitch.isOn
        defaults.set(orbitOriginIsShown, forKey: "orbitOriginIsShown")
    }
    
    @IBAction func cameraFeedChange(_ sender: UISwitch) {
        print("New cameraFeed State: \(cameraFeedSwitch.isOn)")
        cameraFeedIsShown = cameraFeedSwitch.isOn
        defaults.set(cameraFeedIsShown, forKey: "cameraFeedIsShown")
    }
    
    // MARK: - Internal Vars
    var totalNumberOfOrbits = defaultOrbitNames.count
    var isInTutorialMode = Bool()
    
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        if savedNumberOfOrbits != 0 {
            totalNumberOfOrbits = savedNumberOfOrbits + defaultOrbitNames.count
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        enableScrollForUserDevice()
        
        let shownDefaultOrbitsArray = defaults.value(forKey: "defaultOrbitisShown") as? [Bool] ?? defaultOrbitisShown //defaultOrbitisShown.filter{$0}.count
        let numOfDefaultOrbitsShown = shownDefaultOrbitsArray.filter{$0}.count
        
        var numOfUserOrbitsShown = 0
        if savedNumberOfOrbits != 0 {
            var userOrbitsAreShownArray = [Bool()]
            for y in 0...savedNumberOfOrbits-1 {
                var keyNum = Int()
                keyNum = y == 0 ? 3 : 3+(y*4) // if y = 0, keyNum = 3 else keyNum = y*4
                userOrbitsAreShownArray.append(defaults.bool(forKey: "\(keyNum)")) //userOrbitsAreShownArray[y] = defaults.bool(forKey: "\(keyNum)")
            }
            numOfUserOrbitsShown = userOrbitsAreShownArray.filter{$0}.count
        }
        let numOfShownOrbits = numOfDefaultOrbitsShown + numOfUserOrbitsShown // need to add user selected orbits after
        numOfOrbitsLabel.text = "\(numOfShownOrbits)/\(totalNumberOfOrbits) Orbits Shown"
        

        // Loading Settings Values
        if sizeValue != 1 {
            sizeControl.selectedSegmentIndex = defaults.integer(forKey: "sizeValue")
        }
        if fractionValue != 4 {
            fractionControl.selectedSegmentIndex = defaults.integer(forKey: "fractionValue")
        }
        if orbitOriginIsShown != false {
            orbitOriginSwitch.setOn(true, animated: false)
        }
        if cameraFeedIsShown != true {
            cameraFeedSwitch.setOn(false, animated: false)
        }
        if worldOriginIsShown != false {
            worldOriginSwitch.setOn(true, animated: false)
        }
        
        // Determining if is in tutorial mode
        if isInTutorialMode {enableTutorialMode()}
        
    }
    
    // MARK: - Reset
    @IBAction func resetDefaults(_ sender: UIButton) {
        //controller definition
        let alert = UIAlertController(title:"Are you sure?", message: "This will erase any saved orbits you have created, and clear any derived data that could be causing performance issues.", preferredStyle: .alert)
        // button creation
        let reset = UIAlertAction(title: "Reset", style: .destructive) { (alertAction) in
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { key in
                defaults.removeObject(forKey: key)
            }
            print("User Reset to Default Settings")
            self.navigationController?.popToRootViewController(animated: true)
        }
        // button creation
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("User Cancelled Reset")
        }
        
        // adding to controller
        alert.addAction(cancel)
        alert.addAction(reset)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: - Internal Functions
    func enableScrollForUserDevice() -> (){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C or SE")
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                tableView.isScrollEnabled = false
                
            case 2436:
                print("iPhone X, XS")
                tableView.isScrollEnabled = false
                
            case 2688:
                print("iPhone XS Max")
                tableView.isScrollEnabled = false
                
            case 1792:
                print("iPhone XR")
                tableView.isScrollEnabled = false
                
            default:
                print("Unknown")
                
            }
        }
    }
    
    func enableTutorialMode() {
        self.sizeLabel.alpha = 0.32
        self.fractionLabel.alpha = 0.32
        self.worldOriginLabel.alpha = 0.32
        self.orbitOriginLabel.alpha = 0.32
        self.cameraFeedLabel.alpha = 0.32
        
        self.sizeControl.alpha = 0.32
        self.fractionControl.alpha = 0.32
        self.worldOriginSwitch.alpha = 0.32
        self.orbitOriginSwitch.alpha = 0.32
        self.cameraFeedSwitch.alpha = 0.32
        
        self.sizeControl.isUserInteractionEnabled = false
        self.fractionControl.isUserInteractionEnabled = false
        self.worldOriginSwitch.isUserInteractionEnabled = false
        self.orbitOriginSwitch.isUserInteractionEnabled = false
        self.cameraFeedSwitch.isUserInteractionEnabled = false
        // self.resetButton.isUserInteractionEnabled = false
        
        self.resetButton.isHidden = true
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        
        self.editButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 60.0,
                       delay: 0.0,
                       usingSpringWithDamping: CGFloat(0.01),
                       initialSpringVelocity: CGFloat(0.064),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.editButton.transform = CGAffineTransform.identity
        }, completion: { Void in })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editShownOrbits":
            if let orbitsTBController = segue.destination as? OrbitsTableViewController {
                print("User is editing shown orbits = true")
                orbitsTBController.isEditingShownOrbits = true
                orbitsTBController.isInTutorialMode = self.isInTutorialMode
            }
        default:
            print("No segue from settings TBcontroller")
        }

    }
 
    
    
    
    // MARK: - Data Management
    let defaults = UserDefaults.standard
}
