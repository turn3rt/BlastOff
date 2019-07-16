//
//  AboutViewController.swift
//  AR Orbits
//
//  Created by Turner Thornberry on 7/6/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
         self.navigationController?.navigationBar.isTranslucent = true
//        configureAutoLayoutForDevice()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        
//        oeButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//        UIView.animate(withDuration: 60.0,
//                       delay: 2,
//                       usingSpringWithDamping: CGFloat(0.01),
//                       initialSpringVelocity: CGFloat(0.064),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.oeButton.transform = CGAffineTransform.identity
//        }, completion: { Void in })

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
