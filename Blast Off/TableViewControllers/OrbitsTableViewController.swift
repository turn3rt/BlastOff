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
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        savedNumberOfOrbits = defaults.integer(forKey: "savedNumberOfOrbits")
        self.tableView.allowsMultipleSelection = true
        if isEditingShownOrbits != true {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.title = "Modify Orbit"
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
            cell.orbit.isShown = defaultOrbitisShown[indexPath.row] // will probably need to change this from mem
            cell.tintColor = UIColor.green
            if isEditingShownOrbits == true && defaultOrbitisShown[indexPath.row] == true {
                cell.accessoryType = .checkmark
                cell.isSelected = true
                cell.setSelected(true, animated: false)
            }
            return cell
        case 1:
            cell.orbit = Orbit(name: defaults.string(forKey: indexPath.row.description)!,
                               rv: defaults.object(forKey: (indexPath.row+1).description) as? [Double] ?? [Double](),
                               oe: defaults.object(forKey: (indexPath.row+2).description) as? [Double] ?? [Double](),
                               isShown: defaults.bool(forKey: (indexPath.row+3).description))
            cell.orbitName.text = cell.orbit.name
            return cell
        default:
            return cell
        }
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
            print("didSELECTRowAt function handle")

            if defaultOrbitisShown[indexPath.row] == false {
                print("User Selected Default orbit: \(defaultOrbitNames[indexPath.row])")
                defaultOrbitisShown[indexPath.row] = true
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                }
            } else {
                print("User deselected: \(defaultOrbitNames[indexPath.row])")
                defaultOrbitisShown[indexPath.row] = false
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .none
                }
            }

        case 1:
            print("User selected \(indexPath.row) with orbit name: \(defaults.string(forKey: indexPath.row.description)!)")
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
            }
        default:
            print("Error: No section")
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("didDeselectRowAt function handle")
            if defaultOrbitisShown[indexPath.row] == true {
                print("User deselected: \(defaultOrbitNames[indexPath.row])")
                defaultOrbitisShown[indexPath.row] = false
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .none
                }
            } else {
                print("User Selected Default orbit: \(defaultOrbitNames[indexPath.row])")
                defaultOrbitisShown[indexPath.row] = true
                if let cell = tableView.cellForRow(at: indexPath) {
                    cell.accessoryType = .checkmark
                }
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//
//
//    }
 
    
    


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {

        case "modOrbitSegue":
            if let pcioeController = segue.destination as? PCIOEViewController {
                print("segue stuff started")
                // TODO:
            }

        default:
            print("error")
        }

    }
 

    // MARK: - Data Management
    let defaults = UserDefaults.standard
    var isEditingShownOrbits = false

    
    
}





func negate(bool: Bool) -> Bool{
    switch bool {
    case true:
        return false
    case false:
        return true
    }
}
