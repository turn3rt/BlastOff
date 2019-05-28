//
//  OEController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/26/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class OEController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
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
    
    
    
    
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupTextFields()
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
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
            print("Valid Double Precision value entered")
            aSlider.value = (aTField.text?.toFloat())!
            eSlider.value = (eTField.text?.toFloat())!
            capOmegaSlider.value = (capOmegaTField.text?.toFloat())!
            incSlider.value = (incTField.text?.toFloat())!
            omegaSlider.value = (omegaTField.text?.toFloat())!
            nuSlider.value = (nuTField.text?.toFloat())!
        } else { // TODO: Error Handling
            print("Please enter a numeric value, need to display alert controller for this")
        }
        
        
        textField.resignFirstResponder()
        print("Return Key Press Success")
        //        rxTField.resignFirstResponder()
        //        ryTField.resignFirstResponder()
        //        rzTField.resignFirstResponder()
        //        vxTField.resignFirstResponder()
        //        vyTField.resignFirstResponder()
        //        vzTField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if incTField.isEditing || omegaTField.isEditing || nuTField.isEditing == true {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 180 //keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 180 //keyboardSize.height
        }
    }
    
    @IBAction func tapOffKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    // MARK: - Useful Internal Controller Functions & Variables
    var nameOfOrbit = String()
    func showAddNameAlert(){
        //controller definition
        let alert = UIAlertController(title:"Add Name", message: "Please add a name for your orbit", preferredStyle: .alert)
        
        // button creation
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" && textField.text?.contains(" ") == false {
                print("User saving with name: \(textField.text!)")
                self.nameOfOrbit = textField.text!
                print("Prior Saved Number of orbits: \(savedNumberOfOrbits)")
                self.defaults.set(self.nameOfOrbit, forKey: "\(savedNumberOfOrbits)")
                let oe = [Double(self.aSlider.value),
                          Double(self.eSlider.value),
                          Double(self.capOmegaSlider.value),
                          Double(self.incSlider.value),
                          Double(self.omegaSlider.value),
                          Double(self.nuSlider.value)]
                self.defaults.set(oe, forKey: "\(savedNumberOfOrbits+2)")
                print("and the following orbital element values: [\(oe)]")

                let rvVals = oe2rv(oe: oe, mu: earthGravityParam)
                let rvArray = [rvVals.rPCI[0],
                               rvVals.rPCI[1],
                               rvVals.rPCI[2],
                               rvVals.vPCI[0],
                               rvVals.vPCI[1],
                               rvVals.vPCI[2]]
                
                self.defaults.set(rvArray, forKey: "\(savedNumberOfOrbits+1)")
                print("with the following rv values: [\(rvArray)]")
                // set default show setting to true for ARDrawing
                self.defaults.set(true, forKey: "\(savedNumberOfOrbits+3)")
                savedNumberOfOrbits = savedNumberOfOrbits + 1
                print("New savedNumberOfOrbits: \(savedNumberOfOrbits)")
                self.defaults.set(savedNumberOfOrbits, forKey: "savedNumberOfOrbits")
                self.navigationController?.popViewController(animated: true)
                print("Save Success")
            } else {
                alert.message = "Error: Please enter a name as a single word with no spaces"
                self.present(alert, animated: true, completion: nil)
            }
        }
        // button creation
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in }
        
        // adding to controller
        alert.addAction(save)
        alert.addAction(cancel)
        alert.addTextField { (textField) in
            textField.placeholder = "Ex: Molniya"
        }
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Memory Management
    let defaults = UserDefaults.standard
    var orbit = Orbit(name: String(), rv: [Double](), oe: [Double](), isShown: Bool())
    var selectedIndexPathOfOrbit = Int()

}
