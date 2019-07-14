//
//  PCIOEViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/27/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class PCIOEViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var topPar: UILabel!
    @IBOutlet weak var modOrbitLabel: UILabel!
    @IBOutlet weak var botPar: UILabel!
    @IBOutlet weak var nasaLinkButton: UIButton!
    @IBOutlet weak var pciButton: UIButton!
    @IBOutlet weak var oeButton: UIButton!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer! // attatched to modOrbitLabel [Planet]
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var topBlurLabel: UILabel!
    @IBOutlet weak var botBlurLabel: UILabel!
    @IBOutlet weak var blurMargin: NSLayoutConstraint!
    
    
    var isModifyingOrbitPCIOE = false
    var isInTutorialMode = false
    var ogBlurCenter = CGPoint()
    let nasaLink = "https://spaceflight.nasa.gov/realdata/elements/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        print("Orbit contained in this controller is: \(self.orbit.name)")
        if isModifyingOrbitPCIOE == true {
            topPar.text = "Here, you can edit the initial starting position & velocity of the \(self.orbit.name) in Planet Centered Inertial (PCI) coordinates."
            modOrbitLabel.text = ""
            botPar.text = "Typically, it is easier to maniuplate the Orbital Elements (OE's) of the \(self.orbit.name). They are quantified by N.A.S.A the link below."
        }
        if isInTutorialMode == true {
            nasaLinkButton.isHidden = true
            pciButton.isHidden = true
            oeButton.isHidden = true
            tapRecognizer.isEnabled = true
            botPar.isHidden = true
            botPar.text = "More commonly, six orbital elements (OE's) describe the orbit. Tap the planet to continue the tutorial..."
            // animateTopPar()
            delay(bySeconds: 0, closure: {
                self.botPar.isHidden = false
                self.animateBotPar()
            })
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
        // self.isModifyingOrbitPCIOE = false
    }
    
    @IBAction func didTapHyperlink(_ sender: UIButton) {
        if let url = URL(string: nasaLink) {
            UIApplication.shared.open(url)
        }
    }
    
    
    
    // MARK: - Memory Management
    let defaults = UserDefaults.standard
    var orbit = Orbit(name: String(), rv: [Double](), oe: [Double](), isShown: Bool())
    var selectedIndexPathOfOrbit = -1 // Default is no index path eg. neg int value != indexPath

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "pciSegue":
            if let pciController = segue.destination as? PCIController {
                if isModifyingOrbitPCIOE == true {
                    pciController.orbit = self.orbit
                    pciController.selectedIndexPathOfOrbit = self.selectedIndexPathOfOrbit
                    pciController.isModifyingOrbitPCIOE = true
                    print("sent orbit with name and PCI's: \(self.orbit.name) and [\(self.orbit.rv)] to PCIController")
                }
            }
        case "oeSegue":
            if let oeController = segue.destination as? OEController {
                if isModifyingOrbitPCIOE == true {
                    oeController.orbit = self.orbit
                    oeController.selectedIndexPathOfOrbit = self.selectedIndexPathOfOrbit
                    oeController.isModifyingOrbitPCIOE = true
                    print("sent orbit with name & OE's: \(self.orbit.name) and [\(self.orbit.oe)] to OEController")
                }
                if isInTutorialMode == true {
                    oeController.isInTutorialMode = true
                }
            }
        default:
            print("error")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: - IBActions
    @IBAction func planetTap(_ sender: Any) {
        tapRecognizer.isEnabled = false
        nasaLinkButton.alpha = 0.0
        oeButton.alpha = 0.0
        animateBlurView()
        delay(bySeconds: 1.0, closure: {
            self.animateBlurView2()
        })
    
        nasaLinkButton.isHidden = false
        oeButton.isHidden = false
        oeButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 60.0,
                       delay: 2,
                       usingSpringWithDamping: CGFloat(0.01),
                       initialSpringVelocity: CGFloat(0.064),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.oeButton.transform = CGAffineTransform.identity
        }, completion: { Void in })
    }
    
    var originalCenter = CGPoint()
    @IBAction func didPanBlurView(sender: UIPanGestureRecognizer) {
        // let translation = sender.translation(in: view)
        // print("translation \(translation)")
        // originalCenter = blurView.center
        // print("original center is : \(originalCenter)")
        if sender.state == .began {
           // originalCenter = blurView.center
        } else if sender.state == .changed {
            //blurView.center = CGPoint(x: originalCenter.x, y: originalCenter.y + translation.y/5)
            
        } else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            let blurOffset = blurMargin.constant - 11
            
            if velocity.y > 0 { // user swipes down
                UIView.animate(withDuration: 0.24) {
                    self.blurView.center.y = self.ogBlurCenter.y
                    self.botBlurLabel.alpha = 0.0
                    self.topBlurLabel.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.24) { // user swipes up
                    self.blurView.center.y = self.ogBlurCenter.y + blurOffset
                    self.botBlurLabel.alpha = 1.0
                    self.topBlurLabel.alpha = 0.0
                }
            }
        }
    }
    
    
   // MARK: - Internal Functions
    
//    func animateTopPar() {
//        topPar.alpha = 0.0
//        let finalPos = self.topPar.center.x
//        self.topPar.center.x = self.view.bounds.width + 100
//        UIView.animate(withDuration: 0.64, animations:{
//            self.topPar.center.x = finalPos
//            self.topPar.alpha = 1.0
//        })
//    }

    func animateBotPar() {
        botPar.alpha = 0.0
        let finalPos = self.botPar.center.x
        self.botPar.center.x = -self.view.bounds.width //- 100
        UIView.animate(withDuration: 0.64, animations:{
            self.botPar.center.x = finalPos
            self.botPar.alpha = 1.0
        })
    }
    
    func animateBlurView() {
        let finalBlurPos = blurView.center.y
        ogBlurCenter = self.blurView.center
        blurView.center.y = self.view.bounds.height
        blurView.alpha = 0.0
        blurView.isHidden = false
        
        let finalButPos = pciButton.center.y
        pciButton.center.y = self.view.bounds.height
        pciButton.alpha = 0.0
        pciButton.isHidden = false
        pciButton.isEnabled = false
        
        UIView.animate(withDuration: 0.64, animations:{
            self.blurView.center.y = finalBlurPos
            self.pciButton.center.y = finalButPos
            self.blurView.alpha = 1.0
            self.pciButton.alpha = 1.0
            self.topBlurLabel.alpha = 1.0
        })
    }
    
    func animateBlurView2() {
        let finalBlurPos = blurView.center.y + blurMargin.constant - 11
        UIView.animate(withDuration: 2, animations:{
            self.blurView.center.y = finalBlurPos
            self.botBlurLabel.alpha = 1.0
            self.topBlurLabel.alpha = 0.0
            self.oeButton.alpha = 1.0
            self.nasaLinkButton.alpha = 1.0
        })
    }
    
    
    
    
}
