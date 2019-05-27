//
//  DefaultOrbitsAndVars.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/26/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit






// MARK: - Default Orbits
let earthGravityParam = 398600.0 // kilometers^3/sec^2

// Molniya Orbit
let r0 = [-1217.39430415697, -3091.41210822807, -6173.40732877317];  //km
let v0 = [9.88635815507896, -0.446121737099303, -0.890884522967222]; //km/s



// Tundra Orbit
let a = 4.224108006788328e+04
let e = 0.25
let capOmegaArray = [0, 45, 90, 135, 180]
let incDeg = 63.4
let omega1deg = 90.0
let nu = 0.0


let mew = 398600.0
let tauHour = 24.0

let inc = deg2rad(incDeg)
let omega = deg2rad(omega1deg)

let tundra0oe = [a, e, deg2rad(0), inc, omega, nu]
let tundra45oe = [a, e, deg2rad(45), inc, omega, nu]
let tundra90oe = [a, e, deg2rad(90), inc, omega, nu]
let tundra135oe = [a, e, deg2rad(135), inc, omega, nu]
let tundra180oe = [a, e, deg2rad(180), inc, omega, nu]


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
              UIColor.cyan,
              UIColor.gray,
              UIColor.magenta,
              UIColor.yellow,
              UIColor.brown,
              UIColor.white,
              UIColor.black]

//MARK: - Data Management
var savedNumberOfOrbits = UserDefaults.standard.integer(forKey: "savedNumberOfOrbits")

