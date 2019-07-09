//
//  OEController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/26/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class OEController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var aTField: UITextField!
    @IBOutlet weak var eTField: UITextField!
    @IBOutlet weak var capOmegaTField: UITextField!
    @IBOutlet weak var incTField: UITextField!
    @IBOutlet weak var omegaTField: UITextField!
    @IBOutlet weak var nuTField: UITextField!
    
    @IBOutlet weak var aSlider: UISlider!
    @IBOutlet weak var eSlider: UISlider!
    @IBOutlet weak var capOmegaSlider: UISlider!
    @IBOutlet weak var incSlider: UISlider!
    @IBOutlet weak var omegaSlider: UISlider!
    @IBOutlet weak var nuSlider: UISlider!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var initialHeightOfScroll: NSLayoutConstraint!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var initialTutText: UILabel!
    @IBOutlet weak var scrollTutText: UILabel!
    @IBOutlet var tutorialTapRecognizer: UITapGestureRecognizer!
    
    
    // MARK: - IBActions
    @IBAction func aSliderChange(_ sender: UISlider) {
        aTField.text = String(aSlider.value)
    }
    @IBAction func eSliderChange(_ sender: UISlider) {
        eTField.text = String(eSlider.value)
    }
    @IBAction func capOmegaSliderChange(_ sender: UISlider) {
        capOmegaTField.text = String(capOmegaSlider.value)
    }
    @IBAction func incSliderChange(_ sender: UISlider) {
        incTField.text = String(incSlider.value)
    }
    @IBAction func omegaSliderChange(_ sender: UISlider) {
        omegaTField.text = String(omegaSlider.value)
    }
    @IBAction func nuSliderChange(_ sender: UISlider) {
        nuTField.text = String(nuSlider.value)
    }
    @IBAction func saveOrbitClick(_ sender: UIButton) {
        print("Save Orbit Clicked, prior savedNumberOfOrbits: \(savedNumberOfOrbits)")
        showAddNameAlert()
    }
    
    // Local vars
    var isModifyingOrbitPCIOE = false
    var isInTutorialMode = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupTextFields()
        if isInTutorialMode {
            blurView.isHidden = false
            blurView.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        setScrollPositionForUserDevice()

        
        if isModifyingOrbitPCIOE == true {
            aTField.text         = String(self.orbit.oe[0])
            eTField.text         = String(self.orbit.oe[1])
            capOmegaTField.text  = String(rad2deg(self.orbit.oe[2]))
            incTField.text       = String(rad2deg(self.orbit.oe[3]))
            omegaTField.text     = String(rad2deg(self.orbit.oe[4]))
            nuTField.text        = String(rad2deg(self.orbit.oe[5]))
            
            aSlider.value        = Float(self.orbit.oe[0])
            eSlider.value        = Float(self.orbit.oe[1])
            capOmegaSlider.value = Float(rad2deg(self.orbit.oe[2]))
            incSlider.value      = Float(rad2deg(self.orbit.oe[3]))
            omegaSlider.value    = Float(rad2deg(self.orbit.oe[4]))
            nuSlider.value       = Float(rad2deg(self.orbit.oe[5]))
            
            titleLabel.text = "Intitial Planet-Centered Orbital Elements of \(self.orbit.name)"

            print("max slider values: aSlider: \(aSlider.maximumValue)")
            print("max slider values: eSlider: \(eSlider.maximumValue)")
            print("min slider values: aSlider: \(aSlider.minimumValue)")
            print("min slider values: aSlider: \(eSlider.minimumValue)")
            
            // @TODO: Set slider values
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Keyboard Setup & Handling
    
    func setupTextFields(){
        aTField.delegate = self
        eTField.delegate = self
        capOmegaTField.delegate = self
        incTField.delegate = self
        omegaTField.delegate = self
        nuTField.delegate = self
        
        aTField.keyboardType = .numbersAndPunctuation
        eTField.keyboardType = .numbersAndPunctuation
        capOmegaTField.keyboardType = .numbersAndPunctuation
        incTField.keyboardType = .numbersAndPunctuation
        omegaTField.keyboardType = .numbersAndPunctuation
        nuTField.keyboardType = .numbersAndPunctuation
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isDouble(number: textField.text!) {
            // @TODO: can improve this later
            print("Valid Double Precision value entered")
            aSlider.value        = (aTField.text?.toFloat())!
            eSlider.value        = (eTField.text?.toFloat())!
            capOmegaSlider.value = (capOmegaTField.text?.toFloat())!
            incSlider.value      = (incTField.text?.toFloat())!
            omegaSlider.value    = (omegaTField.text?.toFloat())!
            nuSlider.value       = (nuTField.text?.toFloat())!
        } else { // Executes when user enters a non-valid number
            let alert = UIAlertController(title:"Input Error", message: "Please enter a real number value.", preferredStyle: .alert)
            // button creation
            let confirm = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
                let neuTextField = alert.textFields![0] as UITextField
                if isDouble(number: neuTextField.text!) {
                    textField.text = neuTextField.text
                    
                    self.aSlider.value        = (self.aTField.text?.toFloat())!
                    self.eSlider.value        = (self.eTField.text?.toFloat())!
                    self.capOmegaSlider.value = (self.capOmegaTField.text?.toFloat())!
                    self.incSlider.value      = (self.incTField.text?.toFloat())!
                    self.omegaSlider.value    = (self.omegaTField.text?.toFloat())!
                    self.nuSlider.value       = (self.nuTField.text?.toFloat())!
                    
                    textField.resignFirstResponder()
                } else {
//                    alert.title = "Custom Title"
//                    alert.message = "Custom Message"
                    self.present(alert, animated: true, completion: nil)
                }

            }

            alert.addAction(confirm)
            alert.addTextField { (newTextField) in
                newTextField.text = textField.text
            }
            self.present(alert, animated: true, completion: nil)
        }
        
        textField.resignFirstResponder()
        print("Return Key Press Success")
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if incTField.isEditing || omegaTField.isEditing || nuTField.isEditing == true {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 180 //keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += 180 //keyboardSize.height
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func tapOffKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func tutorialTap(_ sender: UITapGestureRecognizer) {
        animateBlurView()
    }
    
    
    
    
    
    // MARK: - Useful Internal Controller Functions & Variables
    var nameOfOrbit = String()
    func showAddNameAlert(){
        //controller definition
        let alert = UIAlertController(title:"Add Name", message: "Please add a name for your orbit", preferredStyle: .alert)
        
        // button creation
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" { // && textField.text?.contains(" ") == false {
                print("User saving with name: \(textField.text!)")
                self.nameOfOrbit = textField.text!
                print("Prior Saved Number of orbits: \(savedNumberOfOrbits)")
                
                self.defaults.set(self.nameOfOrbit, forKey: "\(savedNumberOfOrbits*4)")
                let oe = [Double(self.aSlider.value),
                          Double(self.eSlider.value),
                          Double(deg2rad(Double(self.capOmegaSlider.value))),
                          Double(deg2rad(Double(self.incSlider.value))),
                          Double(deg2rad(Double(self.omegaSlider.value))),
                          Double(deg2rad(Double(self.nuSlider.value)))]
                
                self.defaults.set(oe, forKey: "\((savedNumberOfOrbits*4)+2)")
                print("and the following orbital element values: [\(oe)]")

                let rvVals = oe2rv(oe: oe, mu: earthGravityParam)
                let rvArray = [rvVals.rPCI[0],
                               rvVals.rPCI[1],
                               rvVals.rPCI[2],
                               rvVals.vPCI[0],
                               rvVals.vPCI[1],
                               rvVals.vPCI[2]]
                
                self.defaults.set(rvArray, forKey: "\((savedNumberOfOrbits*4)+1)")
                print("with the following rv values: [\(rvArray)]")
                
                // set default show setting to true for ARDrawing
                self.defaults.set(true, forKey: "\((savedNumberOfOrbits*4)+3)")
                
                savedNumberOfOrbits = savedNumberOfOrbits + 1
                print("New savedNumberOfOrbits: \(savedNumberOfOrbits)")
                self.defaults.set(savedNumberOfOrbits, forKey: "savedNumberOfOrbits")
                
                self.navigationController?.popToRootViewController(animated: true) 
                print("Save Success")
            } else {
                alert.message = "Error: Orbit name cannot be blank."
                self.present(alert, animated: true, completion: nil)
            }
        }
        // button creation
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in }
        
        // adding to controller
        alert.addAction(save)
        alert.addAction(cancel)
        alert.addTextField { (textField) in // text field var params go here
            textField.placeholder = "Ex: Molniya"
            textField.autocapitalizationType = UITextAutocapitalizationType.words
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func setScrollPositionForUserDevice() -> (){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C or SE")
                initialHeightOfScroll.constant = 56
                
            case 1334:
                print("iPhone 6/6S/7/8")
                initialHeightOfScroll.constant = 56
                
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                initialHeightOfScroll.constant = 56
                scrollView.isScrollEnabled = false
                
            case 2436:
                print("iPhone X, XS")
                scrollView.isScrollEnabled = false
                
            case 2688:
                print("iPhone XS Max")
                initialHeightOfScroll.constant = 132
                scrollView.isScrollEnabled = false
                
            case 1792:
                print("iPhone XR")
                initialHeightOfScroll.constant = 132
                scrollView.isScrollEnabled = false
                
            default:
                print("Unknown")
                
            }
        }
    }
    
    
    // MARK: - Animations
    func animateBlurView() {
        let finalBlurPos = blurView.center.y + 344
        UIView.animate(withDuration: 1.0, animations: {
            self.blurView.center.y = finalBlurPos
            self.initialTutText.alpha = 0.0
            self.scrollTutText.alpha = 1.0
        })
    }
    
    // MARK: - Memory Management
    let defaults = UserDefaults.standard
    var orbit = Orbit(name: String(), rv: [Double](), oe: [Double](), isShown: Bool())
    var selectedIndexPathOfOrbit = Int()
}

