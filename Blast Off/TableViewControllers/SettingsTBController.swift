//
//  SettingsTBController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/26/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class SettingsTBController: UITableViewController {
    @IBOutlet weak var numOfOrbitsLabel: UILabel!
    var totalNumberOfOrbits = defaultOrbitNames.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if savedNumberOfOrbits != 0 {
            totalNumberOfOrbits = savedNumberOfOrbits + defaultOrbitNames.count
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        // let totalNumOfOrbits = defaults.value(forKey: "totalNumberOfOrbits") ?? defaultOrbitNames.count
        let shownDefaultOrbitsArray = defaults.value(forKey: "defaultOrbitisShown") as? [Bool] ?? [true] //defaultOrbitisShown.filter{$0}.count
        let numOfDefaultOrbitsShown = shownDefaultOrbitsArray.filter{$0}.count
        var userOrbitsAreShownArray = [Bool()]
        for y in 0...savedNumberOfOrbits-1 {
            var keyNum = Int()
            keyNum = y == 0 ? 3 : 3+(y*4) // if y = 0, keyNum = 3 else keyNum = y*4
            userOrbitsAreShownArray.append(defaults.bool(forKey: "\(keyNum)")) //userOrbitsAreShownArray[y] = defaults.bool(forKey: "\(keyNum)")
        }
        let numOfUserOrbitsShown = userOrbitsAreShownArray.filter{$0}.count
        let numOfShownOrbits = numOfDefaultOrbitsShown + numOfUserOrbitsShown // need to add user selected orbits after
        numOfOrbitsLabel.text = "\(numOfShownOrbits)/\(totalNumberOfOrbits) Orbits Shown"
    }
    
    
    // MARK: - IBActions
    @IBAction func resetDefaults(_ sender: UIButton) {
        
       // TODO: alert saying are you sure
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        print("User Reset to Default Settings")
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        case "editShownOrbits":
            if let orbitsTBController = segue.destination as? OrbitsTableViewController {
                print("User is editing shown orbits = true")
                orbitsTBController.isEditingShownOrbits = true
            }
        default:
            print("No segue from settings TBcontroller")
        }

    }
 
    
    // MARK: - Data Management
    let defaults = UserDefaults.standard
}
