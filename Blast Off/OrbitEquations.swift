//
//  OrbitEquations.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/20/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import simd

// %-%---------------------------------------------------------------------%-
// % This Code Takes two column vectors in the form                        %-
// % rPCI = [x, y, z]                                                      %-
// % vPCI = [Vx, Vy, Vz]                                                   %-
// % and gives oe, the Keplarian Orbital Elements in a 1x6 column matrix   %-
//                                                                         %-
//  % a        = semi-major axis distance   [kM]       = oe(1)             %-
//  % e        = eccentricity               [Unitless] = oe(2)             %-
//  % capOmega = longitude of acending node [Radians]  = oe(3)             %-
//  % inc      = orbit inclination          [Radians]  = oe(4)             %-
//  % omega    = argument of periapsis      [Radians]  = oe(5)             %-
//  % nu       = true anomoly               [Radians]  = oe(6)             %-
//                                                                         %-
//                                                                         %-
// % Inputs:                                                               %-
// %    rPCI:  Cartesian planet-centered inertial (PCI) position (3 by 1)  %-
// %    vPCI:  Cartesian planet-centered inertial (PCI) velocity (3 by 1)  %-
// %    mu:    gravitational parameter of centrally attacting body.        %-
// % Outputs:  orbital elements  (ans) = oe = solution to function         %-
// %    oe(1): semi-major axis.                                            %-
// %    oe(2): eccentricity.                                               %-
// %    oe(3): longitude of the ascending node (rad)                       %-
// %    oe(4): inclination (rad)                                           %-
// %    oe(5): argument of the periapsis (rad)                             %-
// %    oe(6): true anomaly (rad)                                          %-
// %-%---------------------------------------------------------------------%-




func rv2oe(a: Double, e: Double, capOmega: Double, inc: Double, omega: Double, nu: Double) -> [Double] {
    print("rv2oe begin")
    
    
    
    
    
    return [2.0, 3.0]
}
