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
        } else {
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
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    // MARK: - Random Helpful Functions
    func isDouble(number: String) -> Bool {
        if Double(number) != nil {
            return true
        } else {
            return false
        }
    }
    
    
}

extension String {
    func toFloat() -> Float? {
        return NumberFormatter().number(from: self)?.floatValue
    }
}
