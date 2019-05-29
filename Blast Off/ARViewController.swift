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
    let scaleFactor = 200000.0 // Default: 200000.0
    lazy var earthRadiusAR = 6378.1000/scaleFactor // kilometers // SCALE FACTOR: 200thou smaller, double precision, converts to realistic ar rendering units from Kilometers!!!
    let earthPosAR = simd_double3(0, -0.12, -0.3) // meters from point of origin (Phone pos. upon app start)
    
    
//    MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScene()
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
//        // Render Nodes
//        let Earth = createPlanet(position: SCNVector3(earthPosAR), radius: CGFloat(earthRadiusAR), texture: "EarthTexture.png")
//        // Add nodes to scene and name
//        scene.rootNode.addChildNode(Earth)
//        Earth.name = "Earth"
//
//       // let yep = scene.rootNode.childNode(withName: "Earth", recursively: false)
//       // print(yep)
//
////        TODO: Animations
//        rotate(node: Earth)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        // Run the view's session
        sceneView.session.pause()
        print("ARScene Resetting all nodes...")
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        } // clears everything
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Adds Earth Back
        let Earth = createPlanet(position: SCNVector3(earthPosAR), radius: CGFloat(earthRadiusAR), texture: "EarthTexture.png")
        // Add nodes to scene and name
        sceneView.scene.rootNode.addChildNode(Earth)
        Earth.name = "Earth"
        rotate(node: Earth)
        
        
        if numOfDefaultOrbitsShown != 0 {
            for num in 0...defaultOrbitNames.count-1 {
                if defaultOrbitisShown[num] == true {
                    createOrbit(name: defaultOrbitNames[num], orbitalElements: defaultOrbitOEs[num], color: colors[num])
                    print("created default orbit with name: \(defaultOrbitNames[num])")
                }
            }
        }
    }
    
    
    
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
    
    @IBAction func backButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetClick(_ sender: UIButton) {
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
        // planet.firstMaterial?.diffuse.contents is single line func call for above func
        // diffuse is texture properties like color etc...
        // planet.firstMaterial!.specular.contents = #imageLiteral(resourceName: "EarthSpecular.png") // specular is shiny-ness of objects,
        return node
    }
    
    let numOfPoints = 1000
    func createOrbit(name: String, orbitalElements: [Double], color: UIColor) {
        print("createOrbit Start")
        var oe = orbitalElements
        // NOTE: oe[0] = a = semi maj axis is in KILOMETERS. must convert to AR units by dividing by scale factor
        // let a        = oe[0]/scaleFactor
        // let e        = oe[1]
        // let capOmega = oe[2]
        // let inc      = oe[3]
        // let omega    = oe[4]
        let nu0      = oe[5]
    
        let interval = 2*Double.pi/Double(numOfPoints) // divide by fraction to get fraction of orbit
        
        var nuStart = nu0
        
        for index in 1...numOfPoints {
            if nuStart >= 2*Double.pi{
                nuStart = nuStart - (2*Double.pi)
            }
            let nuNext = nuStart+interval
            nuStart = nuNext
            // print("nu value is \(nuNext)")
            
            oe[5] = nuNext
            
            let ans = oe2rv(oe: oe, mu: earthGravityParam)
            let rNext = ans.rPCI
            let rNextAR = ([(rNext[0]/scaleFactor) + earthPosAR.x,
                            (rNext[1]/scaleFactor) + earthPosAR.y,
                            (rNext[2]/scaleFactor) + earthPosAR.z])
            let linePoint = double3(rNextAR) //earthPos + simd_double3([0, 0, earthRadiusAR + Double(slider.value)/(scaleFactor)])
            let drawPoint = SCNSphere(radius: 0.0005) // default: 0.0005
            let drawNode = SCNNode(geometry: drawPoint)
            drawNode.position = SCNVector3(linePoint)
            
            drawNode.geometry?.firstMaterial?.diffuse.contents = color
            // drawNode.geometry?.firstMaterial?.specular.contents = UIColor.white
            
            self.sceneView.scene.rootNode.addChildNode(drawNode)
            drawNode.name = "\(name)\(index)"
        }
        
        // timing is INCORRECT, code for use in other app.
//        let orbitTime = 2*Double.pi*sqrt((a*a*a)/earthGravityParam)
//        print("Orbit time is: \(orbitTime*scaleFactor)")
//        print("CHECK OE'S HERE: \(oe)")
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
    
//    MARK: - Data management
    let defaults = UserDefaults.standard

}
