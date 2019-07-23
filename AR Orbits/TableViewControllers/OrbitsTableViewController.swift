//
//  OrbitsTableViewController.swift
//  Blast Off
//
//  Created by Turner Thornberry on 5/25/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class OrbitsTableViewController: UITableViewController {

    var isInTutorialMode = Bool()
    var isInModTutorialMode = Bool()
   // var ARvc: ARViewController?
    
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBAction func doneButtonClick(_ sender: Any) {
        print("Done Button Clicked")
        self.isEditingShownOrbits = false
        defaults.set(defaultOrbitisShown, forKey: "defaultOrbitisShown")
        print("saved defaultOrbitIsShown as: \(defaultOrbitisShown)")
        numOfDefaultOrbitsShown = defaultOrbitisShown.filter{$0}.count //  counts the number of "true" statements
        print("and the number of default orbits shown is currently: \(numOfDefaultOrbitsShown)")
        
        // TODO: Clean this up
       // if !isInTutorialMode{self.navigationController?.popToViewController(navigationController!.viewControllers[1], animated: true)}
       // else {
            for vc in (self.navigationController?.viewControllers ?? []) {
                if vc is ARViewController {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                     // ARvc?.onDoneTap(data: false)
                    break
                }
            }
       // }

//        let arr = [false, true, true, false, true]
//        let numberOfTrue = arr.filter{$0}.count
//        print(numberOfTrue) // 3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
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
        return isInTutorialMode || isInModTutorialMode ? 3: 2 // if isInTutorialMode or isInModTutMode, return 3 else return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return defaultOrbitNames.count
        case 1:
            return savedNumberOfOrbits
        default:
            return 1 // tutorial cell
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
            
            if isEditingShownOrbits == true && defaults.bool(forKey: "\((indexPath.row*4) + 3)") == true {
                cell.accessoryType = .checkmark
                if indexPath.row >= colors.count - defaultOrbitNames.count {
                    print("current index: \(indexPath.row)")
                    let colorIndex = (indexPath.row - 7) - ((Int((indexPath.row + defaultOrbitNames.count)/10) - 1)*10)
                    cell.tintColor = colors[colorIndex]
                    cell.orbitName.textColor = colors[colorIndex]
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    print("current index: \(indexPath.row)")
                    cell.tintColor = colors[indexPath.row  + defaultOrbitNames.count]
                    cell.orbitName.textColor = colors[indexPath.row + defaultOrbitNames.count]
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
            }
            return cell
        default: // figures out if is new orbit tutorial or modifying orbit tutorial
            if isInTutorialMode{ cell.orbitName.text = "Select or deselect the orbits to plot. Swipe to delete. Press done to end the tutorial..." }
            else { cell.orbitName.text = "Here, you can select which orbit to modify. Make a selection to continue..."} // is modifying tutorial mode
            print("Tutorial mode enabled")
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.darkGray
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Default Orbits"
        case 1:
            if savedNumberOfOrbits != 0 { return "My Orbits" }
            else { return nil }
            
           // return  nil // "My Orbits"
        default: // tutorial
            return "Tutorial Comments"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // default orbit selections
            print("didselectRowAt for drawing the orbit")
            if defaultOrbitisShown[indexPath.row] == false && isEditingShownOrbits == true {
                print("User Selected Default orbit: \(defaultOrbitNames[indexPath.row])")
                defaultOrbitisShown[indexPath.row] = true
                if let cell = tableView.cellForRow(at: indexPath) as? OrbitCell {
                    cell.accessoryType = .checkmark
                    cell.tintColor = colors[indexPath.row]
                    cell.orbitName.textColor = colors[indexPath.row]
                }
            } else { // user is modifying orbit
                print("presenting PCIOE controller with selected row: \(indexPath.row)")
                let vc = storyboard?.instantiateViewController(withIdentifier: "PCIOEvc") as! PCIOEViewController
                // Prep for data passage
                let orbitToPassName = defaultOrbitNames[indexPath.row]
                let orbitToPassPCI = oe2rvArray(oe: defaultOrbitOEs[indexPath.row], mu: earthGravityParam)
                let orbitToPassOE = defaultOrbitOEs[indexPath.row]
                vc.isModifyingOrbitPCIOE = true
                let orbitToPass = Orbit(name: orbitToPassName, rv: orbitToPassPCI, oe: orbitToPassOE, isShown: false)
                
                // check if isInModTutorial mode
                if isInModTutorialMode { vc.isInModTutorialMode = true; vc.isInTutorialMode = true }
                
                // Data Passage
                vc.orbit = orbitToPass
                navigationController?.pushViewController(vc, animated: true)
            }

        case 1: // user generated orbit selections
            print("didselectRowAt for drawing the orbit")
            print("User selected \(indexPath.row) with orbit name: \(defaults.string(forKey: (indexPath.row*4).description)!)")
            if isEditingShownOrbits == true && defaults.bool(forKey: "\((indexPath.row*4) + 3)") == false {
                defaults.set(true, forKey: "\((indexPath.row*4) + 3)")//defaults.bool(forKey: "\((indexPath.row*4) + 3)") == false
                if let cell = tableView.cellForRow(at: indexPath) as? OrbitCell{
                    cell.accessoryType = .checkmark
                    let colorIndex = (indexPath.row - 7) - ((Int((indexPath.row + defaultOrbitNames.count)/10) - 1)*10)

                    cell.tintColor = colors[colorIndex] // colors[indexPath.row + defaultOrbitNames.count]
                    cell.orbitName.textColor = colors[colorIndex] // colors[indexPath.row + defaultOrbitNames.count ]
                }
            } else { // is modifying an orbit
                print("presenting PCIOE controller with selected row: \(indexPath.row)")
                let vc = storyboard?.instantiateViewController(withIdentifier: "PCIOEvc") as! PCIOEViewController
                // Prep for data passage
                let orbitToPassName = defaults.string(forKey: "\(indexPath.row*4)")
//                print("Printing orbitPCI's: \(defaults.array(forKey: "\((indexPath.row*4)+1)"))")
                let orbitToPassPCI = defaults.array(forKey: "\((indexPath.row*4) + 1)") as! [Double] //oe2rvArray(oe: defaultOrbitOEs[indexPath.row], mu: earthGravityParam)
                let orbitToPassOE = defaults.array(forKey: "\((indexPath.row*4) + 2)") as! [Double]
                vc.isModifyingOrbitPCIOE = true
                let orbitToPass = Orbit(name: orbitToPassName!, rv: orbitToPassPCI, oe: orbitToPassOE, isShown: false)

                // check if isInModTutorial mode
                if isInModTutorialMode { vc.isInModTutorialMode = true; vc.isInTutorialMode = true }
                
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
                    cell.orbitName.textColor = UIColor.white
                }
            }
            
        case 1:
            print("User deselected \(indexPath.row) with orbit name: \(defaults.string(forKey: (indexPath.row*4).description)!)")
            if defaults.bool(forKey: "\((indexPath.row*4) + 3)") == true && isEditingShownOrbits == true {
               // print("User deselected: \(defaultOrbitNames[indexPath.row])")
                defaults.set(false, forKey: "\((indexPath.row*4) + 3)")
                if let cell = tableView.cellForRow(at: indexPath) as? OrbitCell {
                    cell.accessoryType = .none
                    cell.tintColor = UIColor.black
                    cell.orbitName.textColor = UIColor.white
                }
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
            print("User attempting to delete object at indexPath: \(indexPath)")
            let tableViewIndexOfOrb2Del = indexPath.row
            
//            var orbitsBeforeDeletedIndex = [Orbit]()
//            if memoryIndexOfOrb2Del != 0 {
//                for n1 in 0...memoryIndexOfOrb2Del - 1 {
//                    orbitsBeforeDeletedIndex.append(Orbit(name: defaults.string(forKey: (n1*4).description)!,
//                                                         rv: defaults.object(forKey: ((n1*4)+1).description) as? [Double] ?? [Double](),
//                                                         oe: defaults.object(forKey: ((n1*4)+2).description) as? [Double] ?? [Double](),
//                                                         isShown: defaults.bool(forKey: ((n1*4)+3).description)))
//                }
//            }
//            print("orbitsBeforeDeletedIndex: \(orbitsBeforeDeletedIndex)")
            
            // Get the Orbits after the row to be deleted
            var orbitsAfterDeletedIndexRow = [Orbit]()
            if tableViewIndexOfOrb2Del != (savedNumberOfOrbits - 1) { // check if the last row isn't the one being deleted
                for n1 in (tableViewIndexOfOrb2Del + 1)...(savedNumberOfOrbits - 1) {
                    orbitsAfterDeletedIndexRow.append(Orbit(name: defaults.string(forKey: (n1*4).description)!,
                                                         rv: defaults.object(forKey: ((n1*4)+1).description) as? [Double] ?? [Double](),
                                                         oe: defaults.object(forKey: ((n1*4)+2).description) as? [Double] ?? [Double](),
                                                         isShown: defaults.bool(forKey: ((n1*4)+3).description)))
                }
                print("orbitsAfterDeletedIndex: \(orbitsAfterDeletedIndexRow)")

                // minus one from the total number of saved orbits
                savedNumberOfOrbits -= 1
                defaults.set(savedNumberOfOrbits, forKey: "savedNumberOfOrbits")
                
                // overwrite the userDefaults dicitonary values starting at the index that was deleted
                var indexToAppendFrom = tableViewIndexOfOrb2Del
                for n2 in 0...orbitsAfterDeletedIndexRow.count - 1  {
                    print("New Mem index key-val pairs:")
                    print("\(indexToAppendFrom*4):\(orbitsAfterDeletedIndexRow[n2].name)")
                    print("\((indexToAppendFrom*4)+1):\(orbitsAfterDeletedIndexRow[n2].rv)")
                    print("\((indexToAppendFrom*4)+2):\(orbitsAfterDeletedIndexRow[n2].oe)")
                    print("\((indexToAppendFrom*4)+3):\(orbitsAfterDeletedIndexRow[n2].isShown)")
                    
                    defaults.set(orbitsAfterDeletedIndexRow[n2].name,    forKey: (indexToAppendFrom*4).description)
                    defaults.set(orbitsAfterDeletedIndexRow[n2].rv,      forKey: ((indexToAppendFrom*4)+1).description)
                    defaults.set(orbitsAfterDeletedIndexRow[n2].oe,      forKey: ((indexToAppendFrom*4)+2).description)
                    defaults.set(orbitsAfterDeletedIndexRow[n2].isShown, forKey: ((indexToAppendFrom*4)+3).description)

                    indexToAppendFrom += 1
                }
            } else { // assumes last row is one being deleted
                // Memory Delete from UserDefaults
                 print("Deleting orbit: \(defaults.string(forKey: (tableViewIndexOfOrb2Del*4).description)!) with memoryIndex starting at \(tableViewIndexOfOrb2Del*4)")
                // Delete the last row from userDefaults
                for n3 in (savedNumberOfOrbits*4)-4...(savedNumberOfOrbits*4)-1 {
                    defaults.removeObject(forKey: n3.description)
                }
                savedNumberOfOrbits -= 1
                defaults.set(savedNumberOfOrbits, forKey: "savedNumberOfOrbits")
            }

            // Removing from Table View
            tableView.reloadData()
            
            
        } else if editingStyle == .insert {
            print("error cannot insert anything to tableView")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: - Data Management
    let defaults = UserDefaults.standard
    var isEditingShownOrbits = false
}
