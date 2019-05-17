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

class ViewController: UIViewController, ARSCNViewDelegate {
    
//    MARK: - IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    
//    MARK: - Local Controller Variables
    let configuration = ARWorldTrackingConfiguration()
    
//    MARK: - Math Variables
    let earthGravityParam = 398600 // meters^3/sec^2
    let earthRadius = CGFloat(6378100.0/200000000.0) // meters SCALE FACTOR: 200mil smaller, double precision
    let earthPos = SCNVector3(0, 0, -0.3) // meters from point of origin (Phone pos. upon app start)
    
    
//    MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
        
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        // Create Node Objects
        let earthPos = SCNVector3(0, 0, -0.3) // meters
        
        // Render Nodes
        let Earth = createPlanet(position: earthPos, radius: earthRadius, texture: "EarthTexture.png")
        // Add nodes to scene
        scene.rootNode.addChildNode(Earth)
        
//        TODO: Animations
        rotate(node: Earth)
        
//        MARK: UI Elements
        // createSlider()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


    
    
    
//    MARK: - IBAction Functions
    
    @IBAction func resetOrigin(_ sender: Any) {
        sceneView.session.pause()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("User Reset World Origin")
    }
    
    
    @IBAction func sliderChange(_ sender: UISlider) {
        let ans = sender.value
        
        print("slider value: \(ans)")
        altitudeLabel.text = "Altitude = \(ans) km"
    }
    
    
//    MARK: - IBOulet Variables
    
    @IBOutlet weak var slider: UISlider! {
        didSet{
            slider.transform = CGAffineTransform(rotationAngle: -.pi/2)
            slider.minimumValue = 0
            slider.maximumValue = 1000
        }
    }
    
    @IBOutlet weak var altitudeLabel: UILabel!
    
    
    

//    MARK: - Internal Functions
    
    func createPlanet(position: SCNVector3, radius: CGFloat, texture: String) -> SCNNode {
        
        let planet = SCNSphere(radius: radius)
        let node = SCNNode(geometry: planet)
        node.position = position
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: texture)
        planet.firstMaterial = material
        
        // planet.firstMaterial?.specular.contents = UIColor.white
        
        
        return node
    }
    
    func createOrbit() {
        print("createOrbit Start")
        
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

    
    
    
    
    
    
    
    //let step: Float = 10 // If you want UISlider to snap to steps by 10
//    func createSlider(){
//        let mySlider = UISlider(frame:CGRect(x: 10, y: 100, width: 300, height: 20))
//        mySlider.minimumValue = 0
//        mySlider.maximumValue = 100
//        mySlider.isContinuous = true
//        mySlider.tintColor = UIColor.green
//        mySlider.addTarget(self, action: #selector(ViewController.sliderValueDidChange(_:)), for: .valueChanged)
//
//        self.view.addSubview(mySlider)
//    }
    
    
   
    
//    @objc func sliderValueDidChange(_ sender:UISlider!)
//    {
//        print("Slider value changed")
//
//        // Use this code below only if you want UISlider to snap to values step by step
////        let roundedStepValue = round(sender.value / step) * step
////        sender.value = roundedStepValue
//
//        print("Slider step value \(Int(s))")
//    }
    
    
    
    
    
    
    
    
//     func addRocket(x: Float = 0, y: Float = 0, z: Float = -0.5) {
//        TODO: - Add 3D Model of rocket
//        guard let rocketshipScene = SCNScene(named: "rocketship.scn"), let rocketshipNode = rocketshipScene.rootNode.childNode(withName: "rocketship", recursively: true) else { return }
//        rocketshipNode.position = SCNVector3(x, y, z)
//        sceneView.scene.rootNode.addChildNode(rocketshipNode)
//    }
    
    
    
   

}
