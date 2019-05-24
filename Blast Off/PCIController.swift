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
        if isDouble(number: textField.text!){
            print("Double Precision value entered")
        } else {
            print("Please enter a numeric value")
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
    func isDouble(number:String) -> Bool{
        if Double(number) == nil{
            return false
        } else {
            return true
        }
    }
       

    
    
    
}
