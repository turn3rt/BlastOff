//
//  M0Tutorial.swift
//  AR Orbits
//
//  Created by Turner Thornberry on 7/6/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class M0Tutorial: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        //        configureAutoLayoutForDevice()
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
