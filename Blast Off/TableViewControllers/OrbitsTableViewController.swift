//
//  OrbitsTableViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/25/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class OrbitsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        savedNumberOfOrbits = defaults.integer(forKey: "savedNumberOfOrbits") 

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return savedNumberOfOrbits
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrbitNameCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Default Orbitzzzzz"
            return cell
        case 1:
            let orbitForRow = Orbit(name: defaults.string(forKey: indexPath.row.description)!,
                                      rv: defaults.object(forKey: (indexPath.row+1).description) as? [Double] ?? [Double](),
                                      oe: defaults.object(forKey: (indexPath.row+2).description) as? [Double] ?? [Double](),
                                 isShown: defaults.bool(forKey: (indexPath.row+3).description))
            cell.textLabel?.text = orbitForRow.name
            return cell
        default:
            return cell
        }
        
        
        
        
        //cell.textLabel?.text = "yeet" //defaults.string(forKey: indexPath.description)//"Section \(indexPath.section) Row \(indexPath.row)"

        //return cell
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
            print("Default Orbits selected")
        case 1:
            print("User selected \(indexPath.row) with orbit name: \(defaults.string(forKey: indexPath.row.description)!)")
        default:
            print("Error: No section")
        }
    }
    
    
    
//    func toDoubleArray(array: [Any]) -> [Double] {
//        var arr = array
//        for i in 0...arr.count {
//            arr[i] = Double(arr[i])
//        }
//
//        return [0.0]
//
//
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
   

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    
    
}
