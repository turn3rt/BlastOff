//
//  DefaultOrbitsAndVars.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/26/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit

//if let key = UserDefaults.standard.object(forKey: "Key"){
//    // exist
//} else {
//    // not exist
//}

var sizeValue = UserDefaults.standard.integer(forKey: "sizeValue") // 1
var fractionValue = UserDefaults.standard.integer(forKey: "fractionValue") // 4
var orbitOriginIsShown = UserDefaults.standard.bool(forKey: "orbitOriginIsShown") // defaults to false
var cameraFeedIsShown = UserDefaults.standard.bool(forKey: "cameraFeedIsShown") // defaults to false
var worldOriginIsShown = UserDefaults.standard.bool(forKey: "worldOriginIsShown") // defaults to false

let earthRadius = 6378.1000 //km
var scaleFactor = 200000.0 // Default: 200000.0
let earthGravityParam = 398600.0 // kilometers^3/sec^2

// MARK: - Default Orbits

// Molniya Orbit
let r0 = [-1217.39430415697, -3091.41210822807, -6173.40732877317];  //km
let v0 = [9.88635815507896, -0.446121737099303, -0.890884522967222]; //km/s
let MolniyaR = [r0[0], r0[1], r0[2]]
let MolniyaV = [v0[0], v0[1], v0[2]]
let MolniyaOE = rv2oe(rPCI: r0, vPCI: v0, mu: earthGravityParam)

// Tundra Orbit
let a = 4.224108006788328e+04
let e = 0.25
let capOmegaArray = [0, 45, 90, 135, 180]
let incDeg = 63.4
let omega1deg = 90.0
let nu = 0.0


//let mew = 398600.0
let tauHour = 24.0

let inc = deg2rad(incDeg)
let omega = deg2rad(omega1deg)

let tundra0oe = [a, e, deg2rad(0), inc, omega, nu]
let tundra45oe = [a, e, deg2rad(45), inc, omega, nu]
let tundra90oe = [a, e, deg2rad(90), inc, omega, nu]
let tundra135oe = [a, e, deg2rad(135), inc, omega, nu]
let tundra180oe = [a, e, deg2rad(180), inc, omega, nu]

// International Space Station (https://heavens-above.com/orbit.aspx?satid=25544)
let aISS = Double((408+earthRadius+418+earthRadius)/2)
let eISS = 0.0007260
let capOmegaISS = deg2rad(99.8697)
let incISS = deg2rad(51.6409)
let omegaISS = deg2rad(344.5645)
let nuISS = 0.0

let ISSoe = [aISS, eISS, capOmegaISS, incISS, omegaISS, nuISS]






// Default Orbit Matrix
let defaultOrbitNames = ["Molniya Orbit", "Tundra Orbit", "I.S.S Orbit"]
let defaultOrbitOEs = [MolniyaOE, tundra45oe, ISSoe]

var defaultOrbitisShown = [true, true, true] // defaults to all orbits shown on launch button tap on fresh install
var numOfDefaultOrbitsShown = defaultOrbitisShown.filter{$0}.count // default is number of default orbits


// MARK: Helper Functions
func rad2deg(_ number: Double) -> Double {
    return number * 180 / .pi
}

func deg2rad(_ number: Double) -> Double {
    return number * .pi / 180
}

func isDouble(number: String) -> Bool {
    if Double(number) != nil {
        return true
    } else {
        return false
    }
}

extension String {
    func toFloat() -> Float? {
        return NumberFormatter().number(from: self)?.floatValue
    }
}


// MARK: - AR Drawing Constants
let colors = [UIColor.orange,
              UIColor.blue,
              UIColor.green,
              UIColor.red,
              UIColor.cyan,
              UIColor.yellow,
              UIColor.magenta,
              UIColor.brown,
              UIColor.lightGray,
              UIColor.purple]

//MARK: - Data Management
var savedNumberOfOrbits = UserDefaults.standard.integer(forKey: "savedNumberOfOrbits") 
// var totalNumberOfOrbits = UserDefaults.standard.integer(forKey: "totalNumberOfOrbits") // default is number of default orbits

func oe2rvArray(oe: [Double], mu: Double) -> [Double] {
    let rOutput = oe2rv(oe: oe, mu: mu).rPCI
    let vOutput = oe2rv(oe: oe, mu: mu).vPCI
    let rvArray = [rOutput[0],
                   rOutput[1],
                   rOutput[2],
                   vOutput[0],
                   vOutput[1],
                   vOutput[2],]
    return rvArray
}

extension UserDefaults {
    func contains(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}

//https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}
