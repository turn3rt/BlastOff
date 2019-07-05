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
    var earthRadiusAR = 6378.1000/scaleFactor // kilometers // SCALE FACTOR: 200thou smaller, double precision, converts to realistic ar rendering units from Kilometers!!!
    let earthPosAR = simd_double3(0, -0.12, -0.3) // meters from point of origin (Phone pos. upon app start)
    
//    MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true // disables power saving mode when view is active dimming
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
        configureScene()
        
        // Loading Settings Values
        if defaults.contains(key: "sizeValue"){
            sizeValue = defaults.integer(forKey: "sizeValue")
            scaleFactor = defaults.double(forKey: "scaleFactor")
        } else {
            sizeValue = 1
        }
        
        if defaults.contains(key: "fractionValue"){
            fractionValue = defaults.integer(forKey: "fractionValue")
        } else {
            fractionValue = 4
        }
        
        if defaults.contains(key: "cameraFeedIsShown"){
            cameraFeedIsShown = defaults.bool(forKey: "cameraFeedIsShown")
        } else {
            cameraFeedIsShown = true
        }
        
        switch sizeValue {
        case 0: // small
            numOfPoints = 1000
            sizeOfPoints = 0.0005 // default size
        case 1: // medium
            numOfPoints = 1000
            sizeOfPoints = 0.0009
        case 2: // large
            numOfPoints = 1000
            sizeOfPoints = 0.002
        case 3: // gigantic
            numOfPoints = 1000
            sizeOfPoints = 0.005
        default:
            print("Err: cannot find number and size of points to draw orbit")
        }
        
        earthRadiusAR = earthRadius/scaleFactor
        
        // Adds Earth Back to Scene
        let Earth = createPlanet(position: SCNVector3(earthPosAR), radius: CGFloat(earthRadiusAR), texture: "EarthTexture.png")
        // Add nodes to scene and name
        sceneView.scene.rootNode.addChildNode(Earth)
        Earth.name = "Earth"
        rotate(node: Earth)
        
        // Default Orbit Drawing
        let shownDefaultOrbitsArray = defaults.value(forKey: "defaultOrbitisShown") as? [Bool] ?? defaultOrbitisShown //defaultOrbitisShown.filter{$0}.count
        let numOfDefaultOrbitsShown = shownDefaultOrbitsArray.filter{$0}.count
        if numOfDefaultOrbitsShown != 0 {
            for num in 0...defaultOrbitNames.count-1 {
                if shownDefaultOrbitsArray[num] == true { //defaultOrbitisShown[num] == true {
                    createOrbit(name: defaultOrbitNames[num], orbitalElements: defaultOrbitOEs[num], color: colors[num])
                    print("created default orbit with name: \(defaultOrbitNames[num])")
                }
            }
        }
        
        // Saved Orbit Drawing
        if savedNumberOfOrbits != 0 {
            var userOrbitsAreShownArray = [Bool]()
            for y in 0...savedNumberOfOrbits-1 {
                var keyNum = Int()
                keyNum = y == 0 ? 3 : 3+(y*4) // keyNum = y, but if y = 0, keyNum = 3 else keyNum = 3+ (y*4)
                userOrbitsAreShownArray.append(defaults.bool(forKey: "\(keyNum)"))
            }
            let indexOfShownUserOrbits = userOrbitsAreShownArray.enumerated().filter { $1 }.map { $0.0 } // finds indices of true vals in userOrbitsAreShownArray
            print("Memory Index of shown Orbits: \(indexOfShownUserOrbits)")
            
            if indexOfShownUserOrbits != [] && indexOfShownUserOrbits.first != userOrbitsAreShownArray.count - 1 {
                for z in 0...indexOfShownUserOrbits.count-1 {
                    
                    var nameKey = Int()
                    let zPrime = indexOfShownUserOrbits[z]
                    
                    nameKey = z == 0 ? indexOfShownUserOrbits.first!*4 : zPrime*4 // if z = 0, keyNum = indexOfShownUserOrbits.first else keyNum = zPrime
                    let userOrbitName = defaults.string(forKey: "\(nameKey)")!
                    
                    var oeKey = Int()
                    oeKey = z == 0 ? (indexOfShownUserOrbits.first!*4)+2 : 2 + zPrime*4
                    let userOrbitOE = defaults.value(forKey: "\(oeKey)") as! [Double]
                    
                    if (defaultOrbitNames.count+zPrime) >= colors.count {
                        if zPrime <= 16 {
                            createOrbit(name: userOrbitName, orbitalElements: userOrbitOE, color: colors[zPrime-7])
                        } else {
                            let a = (zPrime/10)*10
                            let b = floor(Double(a)) // rounds to nearest 10's place of zPrime
                            let c = zPrime - Int(b)
                            let d = c - 7
                            createOrbit(name: userOrbitName, orbitalElements: userOrbitOE, color: colors[d])
                        }
                    } else {
                        createOrbit(name: userOrbitName, orbitalElements: userOrbitOE, color: colors[defaultOrbitNames.count+zPrime])
                    }
                    print("Succssfully created user orbit with name: \(userOrbitName)")
                }
                
            } else if indexOfShownUserOrbits != [] {
                print("Displaying only last orbit with name: \(String(describing: defaults.string(forKey: "\(indexOfShownUserOrbits.first!*4)")))")
                let lastOrbitNameKey = indexOfShownUserOrbits.first!*4
                let lastOrbitName = defaults.string(forKey: "\(lastOrbitNameKey)")

                let lastOrbitOEKey = lastOrbitNameKey+2
                let lastOrbitOE = defaults.value(forKey: "\(lastOrbitOEKey)") as! [Double]

                let colorsKey = defaultOrbitNames.count+indexOfShownUserOrbits.first!
                if colorsKey >= colors.count-1 {
                    let c = colorsKey - 10*Int(colorsKey/10)
                    createOrbit(name: lastOrbitName!, orbitalElements: lastOrbitOE, color: colors[c])
                } else {
                    createOrbit(name: lastOrbitName!, orbitalElements: lastOrbitOE, color: colors[colorsKey])
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
    
    var numOfPoints = 1000
    var sizeOfPoints = 0.0005
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
    
        let fraction = 5.0
        let interval = Double(fractionValue+1)*(2*Double.pi/Double(numOfPoints))/fraction // divide by fraction to get fraction of orbit
        
        var nuStart = nu0
        
        for index in 1...numOfPoints {
            if nuStart >= 2*Double.pi {
                nuStart = nuStart - (2*Double.pi)
            }
            let nuNext = nuStart+interval
            nuStart = nuNext
            // print("nu value is \(nuNext)")
            
            oe[5] = nuNext
            
            let ans = oe2rv(oe: oe, mu: earthGravityParam)
            let rNext = ans.rPCI
            let rNextAR = ([(rNext[0]/scaleFactor),
                            (rNext[1]/scaleFactor),
                            (rNext[2]/scaleFactor)])
            // NOTE: Y & Z AXIS FLIPPED LINK NEXT LINE
            // https://stackoverflow.com/questions/51760421/which-measuring-unit-is-used-in-scnvector3-position-for-x-y-and-z-in-arkit
            // http://www.euclideanspace.com/maths/algebra/matrix/orthogonal/rotation/

            // Rotating Axis
            let firstRotation = deg2rad(-90)
            let xTensorRows = [
                simd_double3(1,  0,  0),
                simd_double3(0, cos(firstRotation), -sin(firstRotation)),
                simd_double3(0, sin(firstRotation),  cos(firstRotation))
            ]
            let xTensor = double3x3(rows: xTensorRows)
            
            let rNextARVector = double3(rNextAR)
            let xAxisRotation = xTensor*rNextARVector
        
            let secondRotation = deg2rad(-90)
            let yTensorRows = [
                simd_double3(cos(secondRotation), 0, sin(secondRotation)),
                simd_double3(0, 1, 0),
                simd_double3(-sin(secondRotation), 0, cos(secondRotation))
            ]
            let yTensor = double3x3(rows: yTensorRows)
            
            let yAxisRotation = yTensor*xAxisRotation
        
            let newAxis = [yAxisRotation[0]+earthPosAR.x, yAxisRotation[1]+earthPosAR.y, yAxisRotation[2]+earthPosAR.z]
            
            // Plotting points
            let linePoint = double3(newAxis)
            let drawPoint = SCNSphere(radius: CGFloat(sizeOfPoints)) // default: 0.0005
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
        sceneView.showsStatistics = false
        
        // set Debug Options
        if worldOriginIsShown {
            showWorldAxis()
        }
        if orbitOriginIsShown {
            showOrbitAxis()
        }
        if cameraFeedIsShown == false {
            createBoundBox() //sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        }
        
        // sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin, SCNDebugOptions.showFeaturePoints] //, .showWireframe]
        
        // Lighting
        // sceneView.autoenablesDefaultLighting = true
    }
    
    func rotate(node: SCNNode) {
        let rotateOnce = SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: 86400/10000) // in seconds
        // ^^ duration is 1 day decreased by scale factor of 10,000 ^^
        let repeatForever = SCNAction.repeatForever(rotateOnce)
        node.runAction(repeatForever)
    }
    
    func showWorldAxis() {
        // Axis Drawing
        let axisRadius = CGFloat(0.0025) // meters
        let axisLength = CGFloat(0.19) // meters

        let xAxisNode = SCNNode(geometry: SCNCapsule(capRadius: axisRadius, height: axisLength))
        let yAxisNode = SCNNode(geometry: SCNCapsule(capRadius: axisRadius, height: axisLength))
        let zAxisNode = SCNNode(geometry: SCNCapsule(capRadius: axisRadius, height: axisLength))

        // Axis Position
        xAxisNode.position = SCNVector3(axisLength/2, 0, 0)
        yAxisNode.position = SCNVector3(0, axisLength/2, 0)
        zAxisNode.position = SCNVector3(0, 0, axisLength/2)

        // Axis Color
        xAxisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red// UIColor.red
        yAxisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green// UIColor.green
        zAxisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue // UIColor.blue
        
        // Axis Rotation
        xAxisNode.eulerAngles = SCNVector3(0,0,Double.pi/2) // rotates about z-axis
        zAxisNode.eulerAngles = SCNVector3(Double.pi/2,0,0) // rotates about x-axis
        
        // Axis Labels
        let xAxisLabel = SCNText(string: "X-Axis", extrusionDepth: 1)
        let yAxisLabel = SCNText(string: "Y-Axis", extrusionDepth: 1)
        let zAxisLabel = SCNText(string: "Z-Axis", extrusionDepth: 1)
        
        let xLabelNode = SCNNode()
        let yLabelNode = SCNNode()
        let zLabelNode = SCNNode()
        
        xLabelNode.position = SCNVector3(axisLength+0.005, 0, 0)
        yLabelNode.position = SCNVector3(-0.016, axisLength+0.005, 0)
        zLabelNode.position = SCNVector3(-0.016, 0, axisLength+0.005)
        
        xLabelNode.scale = SCNVector3(0.001, 0.001, 0.001)
        yLabelNode.scale = SCNVector3(0.001, 0.001, 0.001)
        zLabelNode.scale = SCNVector3(0.001, 0.001, 0.001)
        
        xLabelNode.geometry = xAxisLabel
        yLabelNode.geometry = yAxisLabel
        zLabelNode.geometry = zAxisLabel
        
        
        // Adding Nodes to Scene
        sceneView.scene.rootNode.addChildNode(xAxisNode)
        sceneView.scene.rootNode.addChildNode(yAxisNode)
        sceneView.scene.rootNode.addChildNode(zAxisNode)
        
        sceneView.scene.rootNode.addChildNode(xLabelNode)
        sceneView.scene.rootNode.addChildNode(yLabelNode)
        sceneView.scene.rootNode.addChildNode(zLabelNode)
    }
    
    func showOrbitAxis() {
        
        // Axis Drawing
        let axisRadius = CGFloat(0.0025) // meters
        let axisLength = CGFloat(earthRadiusAR) + 0.16 // CGFloat(0.19) // meters
        
        let xAxisNode = SCNNode(geometry: SCNCapsule(capRadius: axisRadius, height: axisLength))
        let yAxisNode = SCNNode(geometry: SCNCapsule(capRadius: axisRadius, height: axisLength))
        let zAxisNode = SCNNode(geometry: SCNCapsule(capRadius: axisRadius, height: axisLength))
        
        // Axis Position
        xAxisNode.position = SCNVector3(CGFloat(earthPosAR.x), CGFloat(earthPosAR.y), (axisLength/2)+CGFloat(earthPosAR.z))
        yAxisNode.position = SCNVector3((axisLength/2)+CGFloat(earthPosAR.x), CGFloat(earthPosAR.y), CGFloat(earthPosAR.z))
        zAxisNode.position = SCNVector3(CGFloat(earthPosAR.x), (axisLength/2)+CGFloat(earthPosAR.y), CGFloat(earthPosAR.z))
        
        // Axis Color
        xAxisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red // UIColor.red
        yAxisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green // UIColor.green
        zAxisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue // UIColor.blue
        
        // Axis Rotation
        xAxisNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0) // rotates about x-axis
        yAxisNode.eulerAngles = SCNVector3(0,0,Double.pi/2) // rotates about z-axis
        
        // Axis Labels
        let xAxisLabel = SCNText(string: "X-Axis", extrusionDepth: 1)
        let yAxisLabel = SCNText(string: "Y-Axis", extrusionDepth: 1)
        let zAxisLabel = SCNText(string: "Z-Axis", extrusionDepth: 1)
        
        let xLabelNode = SCNNode()
        let yLabelNode = SCNNode()
        let zLabelNode = SCNNode()

        xLabelNode.position = SCNVector3(CGFloat(earthPosAR.x)-(0.016), CGFloat(earthPosAR.y), CGFloat(earthPosAR.z)+axisLength+0.005)
        yLabelNode.position = SCNVector3(CGFloat(earthPosAR.x)+axisLength+0.005, CGFloat(earthPosAR.y), CGFloat(earthPosAR.z))
        zLabelNode.position = SCNVector3(CGFloat(earthPosAR.x)-(0.016), CGFloat(earthPosAR.y)+axisLength+0.005, CGFloat(earthPosAR.z))

        xLabelNode.scale = SCNVector3(0.001, 0.001, 0.001)
        yLabelNode.scale = SCNVector3(0.001, 0.001, 0.001)
        zLabelNode.scale = SCNVector3(0.001, 0.001, 0.001)

        xLabelNode.geometry = xAxisLabel
        yLabelNode.geometry = yAxisLabel
        zLabelNode.geometry = zAxisLabel

        //sceneView.autoenablesDefaultLighting = true
        
        // Adding Nodes to Scene
        sceneView.scene.rootNode.addChildNode(xAxisNode)
        sceneView.scene.rootNode.addChildNode(yAxisNode)
        sceneView.scene.rootNode.addChildNode(zAxisNode)
        
        sceneView.scene.rootNode.addChildNode(xLabelNode)
        sceneView.scene.rootNode.addChildNode(yLabelNode)
        sceneView.scene.rootNode.addChildNode(zLabelNode)
    }
    
    func createBoundBox() {
        // Adding Box around AR Origin if user disables camera feed
        
        // Front
        let frontPlane = SCNBox(width: 20, height: 20, length: 0.001, chamferRadius: 0)
        let frontPlaneNode = SCNNode(geometry: frontPlane)
        frontPlaneNode.position = SCNVector3(0,0,-10)
        
        // Top
        let topPlane = SCNBox(width: 20, height: 20, length: 0.001, chamferRadius: 0)
        let topPlaneNode = SCNNode(geometry: topPlane)
        topPlaneNode.position = SCNVector3(0,10,0)
        topPlaneNode.eulerAngles = SCNVector3(deg2rad(90), 0, 0)
        
        // Right
        let rightPlane = SCNBox(width: 20, height: 20, length: 0.001, chamferRadius: 0)
        let rightPlaneNode = SCNNode(geometry: rightPlane)
        rightPlaneNode.position = SCNVector3(10,0,0)
        rightPlaneNode.eulerAngles = SCNVector3(0, deg2rad(90), 0)
        
        // Left
        let leftPlane = SCNBox(width: 20, height: 20, length: 0.001, chamferRadius: 0)
        let leftPlaneNode = SCNNode(geometry: leftPlane)
        leftPlaneNode.position = SCNVector3(-10,0,0)
        leftPlaneNode.eulerAngles = SCNVector3(0, deg2rad(90), 0)
        
        // Bottom
        let botPlane = SCNBox(width: 20, height: 20, length: 0.001, chamferRadius: 0)
        let botPlaneNode = SCNNode(geometry: botPlane)
        botPlaneNode.position = SCNVector3(0,-10,0)
        botPlaneNode.eulerAngles = SCNVector3(deg2rad(90), 0, 0)
        
        // Back
        let backPlane = SCNBox(width: 20, height: 20, length: 0.001, chamferRadius: 0)
        let backPlaneNode = SCNNode(geometry: backPlane)
        backPlaneNode.position = SCNVector3(0,0,10)
        
        // Object Material Color
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.black
        frontPlane.firstMaterial  = material
        topPlane.firstMaterial    = material
        rightPlane.firstMaterial  = material
        leftPlane.firstMaterial   = material
        botPlane.firstMaterial    = material
        backPlane.firstMaterial   = material
        
        sceneView.scene.rootNode.addChildNode(frontPlaneNode)
        sceneView.scene.rootNode.addChildNode(topPlaneNode)
        sceneView.scene.rootNode.addChildNode(rightPlaneNode)
        sceneView.scene.rootNode.addChildNode(leftPlaneNode)
        sceneView.scene.rootNode.addChildNode(botPlaneNode)
        sceneView.scene.rootNode.addChildNode(backPlaneNode)
    }
    
//    MARK: - Data management
    let defaults = UserDefaults.standard

}
