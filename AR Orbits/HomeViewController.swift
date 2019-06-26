//
//  HomeViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/24/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        print("printing key value pairs for NS UserDefaults: ")
//        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
//        print("printing key value pairs for NS UserDefaults: ")
//        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
//        }
        
        
//        print("MolniyaRV: \(MolniyaR) and \(MolniyaV)")
//        let MolniyaOE = rv2oe(rPCI: MolniyaR, vPCI: MolniyaV, mu: earthGravityParam)
//        print("MolniyaOE = \(MolniyaOE)")
//        let ReRV = oe2rvArray(oe: MolniyaOE, mu: earthGravityParam)
//        print("Convert Back: MolniyaRV: \(ReRV)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
