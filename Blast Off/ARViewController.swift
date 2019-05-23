//
//  ViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/13/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Foundation

class ARViewController: UIViewController, ARSCNViewDelegate, UIAlertViewDelegate {
    
//    MARK: - IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    
//    MARK: - Local Controller Variables
    let configuration = ARWorldTrackingConfiguration()
    
//    MARK: - Math Variables
    let earthGravityParam = 398600.0 // kilometers^3/sec^2
    let scaleFactor = 200000.0// 200000000.0
    lazy var earthRadiusAR = 6378.1000/scaleFactor // 6378100.0/scaleFactor // meters SCALE FACTOR: 200thou smaller, double precision, converts to realistic ar rendering units from Kilometers!!!
    let earthPosAR = simd_double3(0, 0, -0.3) // meters from point of origin (Phone pos. upon app start)
    
    
//    MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        // Render Nodes
        let Earth = createPlanet(position: SCNVector3(earthPosAR), radius: CGFloat(earthRadiusAR), texture: "EarthTexture.png")
        // Add nodes to scene and name
        scene.rootNode.addChildNode(Earth)
        Earth.name = "Earth"
        
       // let yep = scene.rootNode.childNode(withName: "Earth", recursively: false)
       // print(yep)
        
//        TODO: Animations
        rotate(node: Earth)
        
//    MARK: - UI Elements
    
        
    }
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
       // let configuration = ARWorldTrackingConfiguration() // delcared up top
//        configuration.planeDetection = .horizontal
//        configuration.planeDetection = .vertical
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    
    
//    // MARK: - ARSCNViewDelegate
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        DispatchQueue.main.async {
//            self.buttonHighlighted = self.button.isHighlighted
//        }
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // this function iterates at 60 frames per second
//        let startPos = earthPos + SCNVector3(0, 0, earthRadius) //SCNVector3(0, 0, -0.3) // meters

        //print("rendering...")
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
//    MARK: - IBAction Functions
    
    @IBAction func launchTap(_ sender: UIButton) {
        createOrbit()
    }
    
    @IBAction func resetClick(_ sender: UIButton) {
        // removing starter point
        let drawNodeExists = self.sceneView.scene.rootNode.childNode(withName: "drawNode", recursively: false)
        if drawNodeExists != nil {
            drawNodeExists?.removeFromParentNode()
        }
        
        // removing orbit
        if orbitExists {
            for index in 1...numOfPoints{
                let orbitNode = self.sceneView.scene.rootNode.childNode(withName: "drawNode\(index)", recursively: false)
                orbitNode?.removeFromParentNode()
            }
        }
        
        sceneView.session.pause()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("User Reset World Origin")
    }
    
    @IBAction func sliderChange(_ sender: UISlider) {
//        uncomment if desired for step value when moving slider
//        let step: Float = 1000
//        let roundedValue = round(sender.value / step) * step
//        sender.value = roundedValue
        
        let drawNodeExists = self.sceneView.scene.rootNode.childNode(withName: "drawNode", recursively: false)
        
        if drawNodeExists != nil {
            drawNodeExists?.removeFromParentNode()
        }
        
        let startPoint = earthPosAR + simd_double3([0, 0, earthRadiusAR + Double(slider.value)/(scaleFactor)])

        let drawPoint = SCNSphere(radius: 0.005)
        let drawNode = SCNNode(geometry: drawPoint)
        drawNode.position = SCNVector3(startPoint)
        
        drawNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        self.sceneView.scene.rootNode.addChildNode(drawNode)
        drawNode.name = "drawNode"
        
        print("slider value: \(sender.value)")
        altitudeLabel.text = "Altitude = \(Int(sender.value)) km" // force cast to int rounds numbers to no decimal
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("User clicked back button")
        }
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func variableButtonClick(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Slider Variable", message: "Select a variable to change using the slider:", preferredStyle: .actionSheet)
        
        let aButton = UIAlertAction(title: "Semi-Major Axis [a]", style: .default, handler: { (action) -> Void in
            self.variableButton.setTitle("a", for: UIControl.State.normal)
            print("a: semi-major axis selected")
        })
        
        let eButton = UIAlertAction(title: "Eccentricity [e]", style: .default, handler: { (action) -> Void in
            self.variableButton.setTitle("e", for: UIControl.State.normal)
            print("e: eccentricity selected")
        })
        
        let capOmegaButton = UIAlertAction(title: "Longitude of Ascending Node [capOmega]", style: .default, handler: { (action) -> Void in
            self.variableButton.setTitle("capOmega", for: UIControl.State.normal)
            print("capOmega: long of asc. node selected")
        })
        
        let incButton = UIAlertAction(title: "Inclination [inc]", style: .default, handler: { (action) -> Void in
            self.variableButton.setTitle("inc", for: UIControl.State.normal)
            print("inc: inclination selected")
        })
        
        let omegaButton = UIAlertAction(title: "Argument of Periapsis [omega]", style: .default, handler: { (action) -> Void in
            self.variableButton.setTitle("omega", for: UIControl.State.normal)
            print("omega: arg of periapsis selected")
        })
        
        let nuButton = UIAlertAction(title: "True Anomoly [nu]", style: .default, handler: { (action) -> Void in
            self.variableButton.setTitle("nu", for: UIControl.State.normal)
            print("nu: true anomoly selected")
        })
        
//        let  deleteButton = UIAlertAction(title: "Delete forever", style: .destructive, handler: { (action) -> Void in
//            print("Delete button tapped")
//        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(aButton)
        alertController.addAction(eButton)
        alertController.addAction(capOmegaButton)
        alertController.addAction(incButton)
        alertController.addAction(omegaButton)
        alertController.addAction(nuButton)

        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
//    MARK: - IBOulet Variables
    
    @IBOutlet weak var slider: UISlider! {
        didSet{
            slider.transform = CGAffineTransform(rotationAngle: -.pi/2)
            slider.minimumValue = 0
            slider.maximumValue = 35000 // in kilometers
        }
    }
    
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var variableButton: UIButton!
    
    
    

//    MARK: - Internal Functions
    
    func createPlanet(position: SCNVector3, radius: CGFloat, texture: String) -> SCNNode {
        
        let planet = SCNSphere(radius: radius)
        let node = SCNNode(geometry: planet)
        node.position = position
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: texture)
        planet.firstMaterial = material
        
        // planet.firstMaterial?.diffuse.contents is single line func call for above func
        // diffuse is texture properties like color etc...
        
        // planet.firstMaterial?.specular.contents = UIColor.white // specular is shiny-ness of objects,
        
        
        return node
    }
    
    let numOfPoints = 1000
    var orbitExists = false
    func createOrbit() {
        print("createOrbit Start")
        // DEFINE GIVEN rPCI & vPCI & mu
        let r0 = [-1217.39430415697, -3091.41210822807, -6173.40732877317];   // km
        let v0 = [9.88635815507896, -0.446121737099303, -0.890884522967222];  // km/s
        let mu = 398600.0; // km^3/s^2
        
        // converts to AR unit system
        // let r0AR = [r0[0]/scaleFactor, r0[1]/scaleFactor, r0[2]/scaleFactor]
        // let v0AR = [v0[0]/scaleFactor, v0[1]/scaleFactor, v0[2]/scaleFactor]
        
        var oe = rv2oe(rPCI: r0, vPCI: v0, mu: mu)
        // NOTE: oe[0] = a = semi maj axis is in KILOMETERS. must convert to AR units by dividing by scale factor
        let a        = oe[0]/scaleFactor
        // let e        = oe[1]
        // let capOmega = oe[2]
        // let inc      = oe[3]
        // let omega    = oe[4]
        let nu0      = oe[5]
        
        let interval = 2*Double.pi/Double(numOfPoints)
        
        var nuStart = nu0
        //var L = 0 // length of time matrix based on numOfPoints divided by 2*pi (one orbit)
        
        for index in 1...numOfPoints {
            if nuStart >= 2*Double.pi{
                nuStart = nuStart - (2*Double.pi)
            }
            let nuNext = nuStart+interval
            nuStart = nuNext
            // print("nu value is \(nuNext)")
            
            oe[5] = nuNext
            
            let ans = oe2rv(oe: oe, mu: mu)
            let rNext = ans.rPCI
            let rNextAR = [rNext[0]/scaleFactor, rNext[1]/scaleFactor, (rNext[2]/scaleFactor) + earthPosAR.z]
            
            let linePoint = double3(rNextAR) //earthPos + simd_double3([0, 0, earthRadiusAR + Double(slider.value)/(scaleFactor)])
            let drawPoint = SCNSphere(radius: 0.0005)
            let drawNode = SCNNode(geometry: drawPoint)
            drawNode.position = SCNVector3(linePoint)
            
            drawNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            
            self.sceneView.scene.rootNode.addChildNode(drawNode)
            drawNode.name = "drawNode\(index)"
        }
        
        let orbitTime = 2*Double.pi*sqrt((a*a*a)/mu)
        print("Orbit time is: \(orbitTime*scaleFactor)")
        print("CHECK OE'S HERE: \(oe)")
        orbitExists = true
    }
    
    func configureScene(){
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin, .showFeaturePoints] //, .showWireframe]
        // Lighting
        // sceneView.autoenablesDefaultLighting = true
    }
    
    
    func rotate(node: SCNNode) {
        let rotateOnce = SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: 86400/10000) // in seconds
        // ^^ duration is 1 day decreased by scale factor of 10,000 ^^
        let repeatForever = SCNAction.repeatForever(rotateOnce)
        node.runAction(repeatForever)
    }

}
