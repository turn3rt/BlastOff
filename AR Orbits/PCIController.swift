//
//  PCIController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/23/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PCIController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var navBar: UINavigationItem!
    
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var initialHeightOfScroll: NSLayoutConstraint!

    
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
        scrollView.delegate = self
        // self.view.frame.origin.y = 0
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        navBar.title = ""

        
//        self.navigationController?.navigationBar.topItem?.title = "TEST"
//        self.navigationController?.navigationBar.backItem?.title = "yeet"


        setScrollPositionForUserDevice()
        
        if isModifyingOrbitPCIOE == true {
            rxTField.text = String(self.orbit.rv[0])
            ryTField.text = String(self.orbit.rv[1])
            rzTField.text = String(self.orbit.rv[2])
            vxTField.text = String(self.orbit.rv[3])
            vyTField.text = String(self.orbit.rv[4])
            vzTField.text = String(self.orbit.rv[5])
            
            rxSlider.value = Float(self.orbit.rv[0])
            rySlider.value = Float(self.orbit.rv[1])
            rzSlider.value = Float(self.orbit.rv[2])
            vxSlider.value = Float(self.orbit.rv[3])
            vySlider.value = Float(self.orbit.rv[4])
            vzSlider.value = Float(self.orbit.rv[5])
            
            // navBar.title = self.orbit.name

            
            print("max slider values: rxSlider: \(rxSlider.maximumValue)")
            print("max slider values: vxSlider: \(vxSlider.maximumValue)")
            print("min slider values: rxSlider: \(rxSlider.minimumValue)")
            print("min slider values: vxSlider: \(vxSlider.minimumValue)")
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
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
            // @TODO: can improve this later
            print("Valid Double Precision value entered")
            print("Checking if user entered text that is larger than max slider value...")

            
            rxSlider.value = (rxTField.text?.toFloat())!
            rySlider.value = (ryTField.text?.toFloat())!
            rzSlider.value = (rzTField.text?.toFloat())!
            vxSlider.value = (vxTField.text?.toFloat())!
            vySlider.value = (vyTField.text?.toFloat())!
            vzSlider.value = (vzTField.text?.toFloat())!
        } else { // Executes when user enters a non-valid number
            let alert = UIAlertController(title:"Input Error", message: "Please enter a real number value.", preferredStyle: .alert)
            // button creation
            let confirm = UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
                let neuTextField = alert.textFields![0] as UITextField
                if isDouble(number: neuTextField.text!) {
                    textField.text = neuTextField.text
                    
                    self.rxSlider.value = (self.rxTField.text?.toFloat())!
                    self.rySlider.value = (self.ryTField.text?.toFloat())!
                    self.rzSlider.value = (self.rzTField.text?.toFloat())!
                    self.vxSlider.value = (self.vxTField.text?.toFloat())!
                    self.vySlider.value = (self.vyTField.text?.toFloat())!
                    self.vzSlider.value = (self.vzTField.text?.toFloat())!
                    
                    textField.resignFirstResponder()
                } else {
                    //                    alert.title = "Custom Title"
                    //                    alert.message = "Custom Message"
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            // button creation
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
//                print("User Cancelled Action")
//                textField.resignFirstResponder()
//            }
            
            // adding to controller
//            alert.addAction(cancel)
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
        
        if vxTField.isEditing || vyTField.isEditing || vzTField.isEditing == true {
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
            if textField.text != "" { //&& textField.text?.contains(" ") == false {
                print("User saving with name: \(textField.text!)")
                self.nameOfOrbit = textField.text!
                print("Prior Saved Number of orbits: \(savedNumberOfOrbits)")
                
                self.defaults.set(self.nameOfOrbit, forKey: "\(savedNumberOfOrbits*4)")
                
                let rvVals = [Double(self.rxTField.text!),
                              Double(self.ryTField.text!),
                              Double(self.rzTField.text!),
                              Double(self.vxTField.text!),
                              Double(self.vyTField.text!),
                              Double(self.vzTField.text!)]
            
                self.defaults.set(rvVals, forKey: "\((savedNumberOfOrbits*4)+1)")
                print("with the following rv values: [\(rvVals)]")
                
                let rVals = [rvVals[0],
                             rvVals[1],
                             rvVals[2]
                ]
                let vVals = [rvVals[3],
                             rvVals[4],
                             rvVals[5],
                             ]
                
                let oe = rv2oe(rPCI: rVals as! [Double], vPCI: vVals as! [Double], mu: earthGravityParam)
                self.defaults.set(oe, forKey: "\((savedNumberOfOrbits*4)+2)")
                
                // set default show setting to true for ARDrawing
                self.defaults.set(true, forKey: "\((savedNumberOfOrbits*4)+3)")
                
                print("and the following oe values: [\(oe)]")
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
        alert.addTextField { (textField) in
            textField.placeholder = "Ex: Molniya Orbit"
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // https://stackoverflow.com/questions/46192280/detect-if-the-device-is-iphone-x
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
    
    
    
    // MARK: - Memory Management
    let defaults = UserDefaults.standard
    var orbit = Orbit(name: String(), rv: [Double](), oe: [Double](), isShown: Bool())
    var selectedIndexPathOfOrbit = Int()

}






