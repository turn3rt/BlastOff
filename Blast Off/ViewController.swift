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
    
    
//    MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
        
        // Create a new scene
        let scene = SCNScene()
        
//        let Terra = SCNScene(named: "Earth.scn")
        
        // Set the scene to the view
        sceneView.scene = scene
//        sceneView.scene = Terra!
        
        // Create Node Objects
        let earthPos = SCNVector3(0, 0, -0.03)
        let earthRadius = CGFloat(0.035)
//        let moonPos = SCNVector3(0.1, 0.02, -0.08)
//        let moonRadius = CGFloat(0.02)
        
        
        // Render Nodes
        let Earth = createPlanet(position: earthPos, radius: earthRadius, texture: "EarthTexture.png")
//        let Moon = createPlanet(position: moonPos, radius: moonRadius, texture: "MoonTexture.png")
        
        // Add nodes to scene
        
        scene.rootNode.addChildNode(Earth)
//        scene.rootNode.addChildNode(Moon)
        rotate(node: Earth)
        
        
        
        
//    let rocket = SCNScene(named: "rocketship.scn")
        
        
        
        
        
        
    }
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

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


//    MARK: - Internal Functions
    
    func createPlanet(position: SCNVector3, radius: CGFloat, texture: String) -> SCNNode {
        
        let planet = SCNSphere(radius: radius)
        let node = SCNNode(geometry: planet)
        node.position = position
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: texture)
        planet.firstMaterial = material
        
        return node
    }
    
    func configureScene(){
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin]
    }
    
    
    func rotate(node: SCNNode) {
        let rotateOnce = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 86400/10000)
        // ^^ duration is 1 day decreased by scale factor of 10,000 ^^
        let repeatForever = SCNAction.repeatForever(rotateOnce)
        node.runAction(repeatForever)
    }

}
