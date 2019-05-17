//
//  OrbitEquations.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/17/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import ARKit
import SceneKit





func oe2rv(orbitalElements: [Double], muValue: Double, planetRadius: Double, planetPosition: SCNVector3) -> SCNVector3 {
    
    print("Orbital Elements: \(orbitalElements) " + "and the muValue: \(muValue)" + "and the planetRadius: \(planetRadius)" + "and the planet Position: \(planetPosition)")
    
    let planetPos = planetPosition
    
    return planetPos
}
