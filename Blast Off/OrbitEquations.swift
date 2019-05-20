//
//  OrbitEquations.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/20/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import Darwin
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




func rv2oe(rPCI: [Double], vPCI: [Double], mu: Double) -> [Double] {
    print("rv2oe begin")
    
    // Prior to start, define
    // Earth Centered Intertial (ECI) Coordinates

    let Ix = double3(1, 0, 0) // First point of Aries (Rams Head)
    let Iy = double3(0, 1, 0) // cross(Iz, Ix)
    let Iz = double3(0, 0, 1) // Vertical "Up" from Earth
                              // Equatorial Plane

    // convert to single instruction, multiple data (simd),
    // using simd framework declared in import
    let rPC = simd_double3(rPCI)
    let vPC = simd_double3(vPCI)
    
    //-------Begin function--------//
    // First, compute angular momentum h
    // simd_cross(vector1, vector2)) is swift syntax for cross product
    let hVector = simd_cross(rPC, vPC)
    let h       = simd_length(hVector)
    
    
    //oe(2)----------eccentricity e----------- %
    // note: can drop simd_ from func calls
    let r       = length(rPC)
    let eVector = cross(vPC,hVector)/mu - rPC/r // EQN (2.5)
    let e       = length(eVector)
    
 
 /* Once we have the angular momentum h
    and the eccentricity e
    we can then define the Perifocal Coordinate
    system which describes the orbit of a spacecraft
    relative to the planet using the periapsis
    as a point of interest */
    
    let Px = eVector/e; // towards periapsis
    let Pz = hVector/h; // "up" from the orbit plane
    let Py = cross(Pz, Px); // needed to complete coord. sys.
    
    // Semi-Lattus Rectum p
    let p = (h*h)/mu
    
    // oe(1) ---------Semi-major Axis a--------- %
    let a = p/(1-(e*e)); // [Unit Distance]

    // oe(3) -------Longitude of Ascending Node capOmega-------- %
    // We need to define the line of nodes n
   let  nVector = cross(Iz, hVector); // to check, nz component should
                                      // should be zero; lies in
                                      // Ix, Iy plane. Code: disp(n(3))

    // Need four quadrent inverse tangent atan2(Y, X) + pi
    let capOmega = atan2(dot(-nVector,Iy),dot(-nVector,Ix)) + .pi; // [RADIANS]
    // Convert to degrees
    //capOmegaDeg = rad2deg(capOmega);

    
    // oe(4) --------- orbit inclination inc -------- %
    // first need decompose hVector into components that are
    // Iz and direction orthogonal to Iz called "b"
                
    // Decomposition of angular momentum into components
    let hx = hVector[1-1]; // note: minus one because i'm lazy and swift does index starting at 0 not matlab's 1
    let hy = hVector[2-1];
    let hz = hVector[3-1];
    
    let bVector = hVector - hz*Iz; // lies in Ix, Iy plane
    // Check: hz should be zero
    let b       = length(bVector);
    
    // From EQ 2.15 in Course Notes,
    let inc    = atan2(dot(hVector, bVector), dot((b*hVector),Iz)); // [RADIANS]
    // Convert to degrees
    // incDeg = rad2deg(inc);

    // oe(5) -------------argument of periapsis omega-----------%
    // EQ 2.19 in Course Notes
    let omega = atan2(dot(-eVector,cross(hVector, nVector)),-h*dot(eVector, nVector)) + .pi;
    
    // oe(6) ------------true anomoly nu ------------ %
    let nu    = atan2(dot(-rPC,cross(hVector, eVector)),-h*dot(rPC, eVector)) + .pi;
    
    return [a, e, capOmega, inc, omega, nu]
}
