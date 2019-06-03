//
//  OrbitsTableViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/25/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class OrbitsTableViewController: UITableViewController {

    
    
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBAction func doneButtonClick(_ sender: Any) {
        print("Done Button Clicked")
        self.isEditingShownOrbits = false
        self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)
        defaults.set(defaultOrbitisShown, forKey: "defaultOrbitisShown")
        print("saved defaultOrbitIsShown as: \(defaultOrbitisShown)")
        numOfDefaultOrbitsShown = defaultOrbitisShown.filter{$0}.count
        print("and the number of default orbits shown is currently: \(numOfDefaultOrbitsShown)")
//        let arr = [false, true, true, false, true]
//        let numberOfTrue = arr.filter{$0}.count
//        print(numberOfTrue) // 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        savedNumberOfOrbits = defaults.integer(forKey: "savedNumberOfOrbits")
        defaultOrbitisShown = defaults.value(forKey: "defaultOrbitisShown") as? [Bool] ?? defaultOrbitisShown
        self.tableView.allowsMultipleSelection = true
       // self.tableView.tableHeaderView?.backgroundColor = .black
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        backgroundView.backgroundColor = UIColor.black
        self.tableView.backgroundView = backgroundView
        
        
        

        if isEditingShownOrbits != true {
            self.tableView.allowsMultipleSelection = false
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.title = "Modify"
            //navigationController!.navigationItem.rightBarButtonItem = nil
           // doneButton = nil
           // doneButton.style = UIBarButtonItem.Style.pl
        } else {
            self.navigationItem.title = "Shown Orbits"
            print("User came from settings vc. defaultOrbitisShown state: [\(defaultOrbitisShown)]")

        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return defaultOrbitNames.count
        case 1:
            return savedNumberOfOrbits
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrbitNameCell", for: indexPath) as! OrbitCell
        switch indexPath.section {
        case 0:
            cell.orbit.oe = defaultOrbitOEs[indexPath.row]
            cell.orbitName.text = defaultOrbitNames[indexPath.row]
            cell.orbit.isShown = defaultOrbitisShown[indexPath.row]
           // cell.tintColor = UIColor.green
            if isEditingShownOrbits == true && defaultOrbitisShown[indexPath.row] == true {
                cell.accessoryType = .checkmark
                cell.tintColor = colors[indexPath.row]
                cell.orbitName.textColor = colors[indexPath.row]
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            return cell
        case 1:
            cell.orbit = Orbit(name: defaults.string(forKey: (indexPath.row*4).description)!,
                               rv: defaults.object(forKey: ((indexPath.row*4)+1).description) as? [Double] ?? [Double](),
                               oe: defaults.object(forKey: ((indexPath.row*4)+2).description) as? [Double] ?? [Double](),
                               isShown: defaults.bool(forKey: ((indexPath.row*4)+3).description))
            cell.orbitName.text = cell.orbit.name
            return cell
        default:
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Default Orbits"
        case 1:
            return "My Orbits"
        default:
            return "Error: No section"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("didselectRowAt for drawing the orbit")
            if defaultOrbitisShown[indexPath.row] == false && isEditingShownOrbits == true {
                print("User Selected Default orbit: \(defaultOrbitNames[indexPath.row])")
                defaultOrbitisShown[indexPath.row] = true
                if let cell = tableView.cellForRow(at: indexPath) as? OrbitCell {
                    cell.accessoryType = .checkmark
                    cell.tintColor = colors[indexPath.row]
                    cell.orbitName.textColor = colors[indexPath.row]
                }
            } else {
                print("presenting PCIOE controller with selected row: \(indexPath.row)")
                let vc = storyboard?.instantiateViewController(withIdentifier: "PCIOEvc") as! PCIOEViewController
                // Prep for data passage
                let orbitToPassName = defaultOrbitNames[indexPath.row]
                let orbitToPassPCI = oe2rvArray(oe: defaultOrbitOEs[indexPath.row], mu: earthGravityParam)
                let orbitToPassOE = defaultOrbitOEs[indexPath.row]
                vc.isModifyingOrbitPCIOE = true
                let orbitToPass = Orbit(name: orbitToPassName, rv: orbitToPassPCI, oe: orbitToPassOE, isShown: false)
                
                // Data Passage
                vc.orbit = orbitToPass
                navigationController?.pushViewController(vc, animated: true)
                
            }

        case 1:
            print("didselectRowAt for drawing the orbit")
            print("User selected \(indexPath.row) with orbit name: \(defaults.string(forKey: (indexPath.row*4).description)!)")
            if isEditingShownOrbits == true && defaults.bool(forKey: "\(indexPath.row + 3)") == false {
                if let cell = tableView.cellForRow(at: indexPath) {
                    // @TODO: Selecting Cell for Drawing
                    // cell.accessoryType = .checkmark
                }
            } else {
                print("presenting PCIOE controller with selected row: \(indexPath.row)")
                let vc = storyboard?.instantiateViewController(withIdentifier: "PCIOEvc") as! PCIOEViewController
                // Prep for data passage
                let orbitToPassName = defaults.string(forKey: "\(indexPath.row*4)")
//                print("Printing orbitPCI's: \(defaults.array(forKey: "\((indexPath.row*4)+1)"))")
                let orbitToPassPCI = defaults.array(forKey: "\((indexPath.row*4) + 1)") as! [Double] //oe2rvArray(oe: defaultOrbitOEs[indexPath.row], mu: earthGravityParam)
                let orbitToPassOE = defaults.array(forKey: "\((indexPath.row*4) + 2)") as! [Double]
                vc.isModifyingOrbitPCIOE = true
                let orbitToPass = Orbit(name: orbitToPassName!, rv: orbitToPassPCI, oe: orbitToPassOE, isShown: false)

                // Data Passage
                vc.orbit = orbitToPass
                navigationController?.pushViewController(vc, animated: true)
                
            }
        default:
            print("Error: No section")
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("didDeselectRowAt function handle")
            if defaultOrbitisShown[indexPath.row] == true && isEditingShownOrbits == true {
                print("User deselected: \(defaultOrbitNames[indexPath.row])")
                defaultOrbitisShown[indexPath.row] = false
                if let cell = tableView.cellForRow(at: indexPath) as? OrbitCell {
                    cell.accessoryType = .none
                    cell.tintColor = UIColor.black
                    cell.orbitName.textColor = UIColor.black
                }
            } else {
                print("error with selecting tbcells")
//                print("User Selected Default orbit: \(defaultOrbitNames[indexPath.row])")
//                defaultOrbitisShown[indexPath.row] = true
//                if let cell = tableView.cellForRow(at: indexPath) {
//                    cell.accessoryType = .checkmark
//                }
            }

        case 1:
            print("User deselected \(indexPath.row) with orbit name: \(defaults.string(forKey: indexPath.row.description)!)")
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
            }
        default:
            print("Error: No section")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("User deleting object a: \(indexPath)")
            //objects.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("error wat")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: - Data Management
    let defaults = UserDefaults.standard
    var isEditingShownOrbits = false
}
