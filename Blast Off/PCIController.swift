//
//  PCIController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/23/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PCIController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var rxTField: UITextField!
    @IBOutlet weak var ryTField: UITextField!
    @IBOutlet weak var rzTField: UITextField!
    @IBOutlet weak var vxTField: UITextField!
    @IBOutlet weak var vyTField: UITextField!
    @IBOutlet weak var vzTField: UITextField!


    @IBOutlet weak var rxSlider: UISlider!
    @IBOutlet weak var rySlider: UISlider!
    @IBOutlet weak var rzSlider: UISlider!
    @IBOutlet weak var vxSlider: UISlider!
    @IBOutlet weak var vySlider: UISlider!
    @IBOutlet weak var vzSlider: UISlider!

    // MARK: - IBActions
    @IBAction func rxSliderChange(_ sender: UISlider) {
        rxTField.text = String(rxSlider.value)
    }
    @IBAction func rySliderChange(_ sender: UISlider) {
        ryTField.text = String(rySlider.value)
    }
    @IBAction func rzSliderChange(_ sender: UISlider) {
        rzTField.text = String(rzSlider.value)
    }
    @IBAction func vxSliderChange(_ sender: UISlider) {
        vxTField.text = String(vxSlider.value)
    }
    @IBAction func vySliderChange(_ sender: UISlider) {
        vyTField.text = String(vySlider.value)
    }
    @IBAction func vzSliderChange(_ sender: UISlider) {
        vzTField.text = String(vzSlider.value)
    }
    @IBAction func saveOrbitClick(_ sender: UIButton) {
        print("Save Orbit Clicked, prior savedNumberOfOrbits: \(savedNumberOfOrbits)")
        showAddNameAlert()
    }
    
    
    
    
    var isModifyingOrbitPCIOE = false
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        setupTextFields()
        if isModifyingOrbitPCIOE == true {
            rxTField.text = String(self.orbit.rv[0])
            ryTField.text = String(self.orbit.rv[1])
            rzTField.text = String(self.orbit.rv[2])
            vxTField.text = String(self.orbit.rv[3])
            vyTField.text = String(self.orbit.rv[4])
            vzTField.text = String(self.orbit.rv[5])
            
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Keyboard Setup & Handling
    
    func setupTextFields(){
        rxTField.delegate = self
        ryTField.delegate = self
        rzTField.delegate = self
        vxTField.delegate = self
        vyTField.delegate = self
        vzTField.delegate = self
        
        rxTField.keyboardType = .numbersAndPunctuation
        ryTField.keyboardType = .numbersAndPunctuation
        rzTField.keyboardType = .numbersAndPunctuation
        vxTField.keyboardType = .numbersAndPunctuation
        vyTField.keyboardType = .numbersAndPunctuation
        vzTField.keyboardType = .numbersAndPunctuation

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isDouble(number: textField.text!) {
            print("Valid Double Precision value entered")
            rxSlider.value = (rxTField.text?.toFloat())!
            rySlider.value = (ryTField.text?.toFloat())!
            rzSlider.value = (rzTField.text?.toFloat())!
            vxSlider.value = (vxTField.text?.toFloat())!
            vySlider.value = (vyTField.text?.toFloat())!
            vzSlider.value = (vzTField.text?.toFloat())!
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
        
        if vxTField.isEditing || vyTField.isEditing || vzTField.isEditing == true {
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
                let rvVals = [Double(self.rxSlider.value),
                              Double(self.rySlider.value),
                              Double(self.rzSlider.value),
                              Double(self.vxSlider.value),
                              Double(self.vySlider.value),
                              Double(self.vzSlider.value)]
                //set [nameOfOrbit]rvValues
                self.defaults.set(self.nameOfOrbit, forKey: "\(savedNumberOfOrbits)")
                print("User saved \(self.nameOfOrbit)")
                self.defaults.set(rvVals, forKey: "\(savedNumberOfOrbits+1)")
                print("with the following rv values: [\(rvVals)]")
                let rVals = [rvVals[0],
                             rvVals[1],
                             rvVals[2]
                ]
                let vVals = [rvVals[3],
                             rvVals[4],
                             rvVals[5],
                             ]
                
                let oe = rv2oe(rPCI: rVals, vPCI: vVals, mu: earthGravityParam)
                //set [nameOfOrbit]oeValues
                self.defaults.set(oe, forKey: "\(savedNumberOfOrbits+2)")
                // set default show setting to true for ARDrawing
                self.defaults.set(true, forKey: "\(savedNumberOfOrbits+3)")

                print("and the following oe values: [\(oe)]")
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
    
    // MARK: - Internal Functions
    
    
    
    // MARK: - Memory Management
    let defaults = UserDefaults.standard
    var orbit = Orbit(name: String(), rv: [Double](), oe: [Double](), isShown: Bool())
    var selectedIndexPathOfOrbit = Int()
}






