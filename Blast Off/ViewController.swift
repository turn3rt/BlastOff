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

class ViewController: UIViewController, ARSCNViewDelegate {
    
//    MARK: - IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    
//    MARK: - Local Controller Variables
    let configuration = ARWorldTrackingConfiguration()
    
//    MARK: - Math Variables
    let earthGravityParam = 398600.0 // kilometers^3/sec^2
    let scaleFactor = 200000.0// 200000000.0
    lazy var earthRadiusAR = 6378.1000/scaleFactor // 6378100.0/scaleFactor // meters SCALE FACTOR: 200thou smaller, double precision, converts to realistic ar rendering units from Kilometers!!!
    let earthPos = simd_double3(0, 0, -0.3) // meters from point of origin (Phone pos. upon app start)
    
    
//    MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        // Render Nodes
        let Earth = createPlanet(position: SCNVector3(earthPos), radius: CGFloat(earthRadiusAR), texture: "EarthTexture.png")
        // Add nodes to scene and name
        scene.rootNode.addChildNode(Earth)
        Earth.name = "Earth"
        
       let yep = scene.rootNode.childNode(withName: "Earth", recursively: false)
        print(yep)
        
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
        // DEFINE GIVEN rPCI & vPCI & mu
        let r0 = [-1217.39430415697, -3091.41210822807, -6173.40732877317];   // km
        let v0 = [9.88635815507896, -0.446121737099303, -0.890884522967222];  // km/s
        let mu = 398600.0; // km^3/s^2
        
        // converts to AR unit system
        let r0AR = [r0[0]/scaleFactor, r0[1]/scaleFactor, r0[2]/scaleFactor]
        let v0AR = [v0[0]/scaleFactor, v0[1]/scaleFactor, v0[2]/scaleFactor]
        
        let oe = rv2oe(rPCI: r0, vPCI: v0, mu: mu)
        // NOTE: oe[0] = a = semi maj axis is in KILOMETERS. must convert to AR units by dividing by scale factor
        let a        = oe[0]/scaleFactor
        let e        = oe[1]
        let capOmega = oe[2]
        let inc      = oe[3]
        let omega    = oe[4]
        let nu0      = oe[5]
        
        
        let numOfPoints = 1000
        let interval = 2*Double.pi/Double(numOfPoints)
        
        var nuStart = nu0
        for index in 1...numOfPoints {
            if nuStart >= 2*Double.pi{
                nuStart = nuStart - (2*Double.pi)
            }
            let nuNext = nuStart+interval
            nuStart = nuNext
            print("nu value is \(nuNext)")
            //print("\(index) times 5 is \(index * 5)")
        }
        
        
        
        
        
        
        let orbitTime = 2*Double.pi*sqrt((a*a*a)/mu)
        print("Orbit time is: \(orbitTime)")
        
        
        print("CHECK OE'S HERE: \(oe)")
        
        
        
        
        
        
        
        let drawNodeExists = self.sceneView.scene.rootNode.childNode(withName: "drawNode", recursively: false)
        
        // uncomment to remove child nodes before drawing another one
        if drawNodeExists != nil {
            drawNodeExists?.removeFromParentNode()
        }
        
        let startPoint = earthPos + simd_double3([0, 0, earthRadiusAR + Double(slider.value)/(scaleFactor)])
        print("shit to be added to earth radius: \(Double(slider.value)/scaleFactor)")
        print("Earth Radius is:  \(earthRadiusAR)")
        print("Start point Z value is: \(startPoint.z)")

        let drawPoint = SCNSphere(radius: 0.005)
        let drawNode = SCNNode(geometry: drawPoint)
        drawNode.position = SCNVector3(startPoint)
        
        drawNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        self.sceneView.scene.rootNode.addChildNode(drawNode)
        drawNode.name = "drawNode" // need to add name to every node
        
        
        

        
        
        
        let rPCI = [ 0.7, 0.6, 0.3]
        let vPCI = [-0.8, 0.8, 0.0]
      
        //let oe = rv2oe(rPCI: rPCI, vPCI: vPCI, mu: 1)
        
        print("Orbital elements: \(oe)")
        print("oe[0] is : \(oe[0])")
        
        
        // TODO: marker

        let x = oe2rv(oe: oe, mu: 1)
        print("output of oe2rv is as follows: \(x)")
    }
    
    @IBAction func resetOrigin(_ sender: UIButton) {
        let drawNodeExists = self.sceneView.scene.rootNode.childNode(withName: "drawNode", recursively: false)
        if drawNodeExists != nil {
            drawNodeExists?.removeFromParentNode()
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
        
        let startPoint = earthPos + simd_double3([0, 0, earthRadiusAR + Double(slider.value)/(scaleFactor)])

        let drawPoint = SCNSphere(radius: 0.005)
        let drawNode = SCNNode(geometry: drawPoint)
        drawNode.position = SCNVector3(startPoint)
        
        drawNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        
        self.sceneView.scene.rootNode.addChildNode(drawNode)
        drawNode.name = "drawNode"
        
        print("slider value: \(sender.value)")
        altitudeLabel.text = "Altitude = \(Int(sender.value)) km" // force cast to int rounds numbers to no decimal
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
    
    
    

//    MARK: - Internal Functions
    
    func createPlanet(position: SCNVector3, radius: CGFloat, texture: String) -> SCNNode {
        
        let planet = SCNSphere(radius: radius)
        let node = SCNNode(geometry: planet)
        node.position = position
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: texture)
        planet.firstMaterial = material //
        
        // planet.firstMaterial?.diffuse.contents is single line func call for above func
        // diffuse is texture properties like color etc...
        
        // planet.firstMaterial?.specular.contents = UIColor.white // specurlar is shiny-ness of objects,
        
        
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
