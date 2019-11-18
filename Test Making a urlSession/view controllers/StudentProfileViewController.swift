//
//  StudentProfileViewController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

class StudentProfileViewController: UIViewController {
    
    var student : User!
    
    @IBOutlet weak var firstName: UILabel!

    @IBOutlet weak var LastName: UILabel!
    
    @IBOutlet weak var profilesTableView: UITableView!
    
    @IBOutlet weak var profileDescription: UILabel!
    
    @IBOutlet weak var dayOfWeekSegment: UISegmentedControl!
    
    var notesDelegate: NotesDelegate?
    
    
    var setAlready: Bool = false
    
    
    var profiles: [Profile] = []
    
    var profileForTheDayArray = Array(repeating: String(), count: 5)
    // var daySelectedRowIndexPathArray = Array(repeating: IndexPath(), count: 5)
    
    var segmentMovingFrom = 0
    
    var indexPathDictionary: [String: IndexPath] = [:]
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profilesTableView.dataSource = self
        profilesTableView.delegate = self
        
        firstName.text = student.firstName
        LastName.text = student.lastName
        
        dayOfWeekSegment.selectedSegmentIndex = 0

        

        // Do any additional setup after loading the view.
        
        GetDataApi.getProfileListResponse { (xyz) in
            DispatchQueue.main.async {
                guard let profilesResponse = xyz as? ProfilesResponse else {fatalError("could not convert it to Profiles")}
                let profls = profilesResponse.profiles.first
                print(String(repeating: "\(String(describing: profls?.name))  " , count: 5))
                
                self.profiles = profilesResponse.profiles.filter{$0.name.hasPrefix("Profile-App ") }
                
                
                self.profiles.forEach { print($0.name ) }
                
                self.profilesTableView.reloadData()
                
                self.processStudentNotes()
                
//                for (idx, profile) in self.profileForTheDayArray.enumerated() {
//                    self.daySelectedRowIndexPathArray[idx] = self.indexPathDictionary[profile] ??  IndexPath()
//                }
                
                if let rownumber = self.profiles.firstIndex(where: { (item) -> Bool in
                    item.name == self.profileForTheDayArray[self.dayOfWeekSegment.selectedSegmentIndex]
                }) {
                    self.profilesTableView.selectRow(at: IndexPath(row: rownumber, section: 0), animated: true, scrollPosition: .none)
                }

//                let rownumber = self.profiles.firstIndex { (item) -> Bool in
//                    item.name == self.profileForTheDayArray[0]
//                }
//                self.profilesTableView.selectRow(at: IndexPath(row: rownumber!, section: 0), animated: true, scrollPosition: .none)

                
            }
        }
    }
    
    
    @IBAction func updateTheStudent(_ sender: Any) {
        
        for profile in profileForTheDayArray   {
            if profile.isEmpty {
                print("Update Failed, All 5 Days are required")
                return
            }
        }
        
        var studentProfileList = profileForTheDayArray.joined(separator: ";")
        studentProfileList.append("~#~")
        let studentProfileListComplete = "~#~" + studentProfileList
        
        guard let rowSelected = profilesTableView.indexPathForSelectedRow?.row else {
            print("need to select a profile")
            return
        }
        //let profileName = profiles[rowSelected].name
        GetDataApi.updateUserProperty(GeneratedReq.init(request: ValidReqs.updateUserProperty(userId: String(student.id), propertyName: "notes", propertyValue: studentProfileListComplete))) {
            DispatchQueue.main.async {
                self.notesDelegate?.updateStudentNote(passedNoted: studentProfileListComplete)
                print("````````````Hooray Job well done")
            }
        }

    }
    
    @IBAction func dayOfWeekChanged(_ sender: UISegmentedControl) {
        print("The current day selection is \(sender.selectedSegmentIndex)")
        
        for item in profileForTheDayArray {
            print("``````````````````the item is \(item)")
        }
        
        guard let selectionIndexPath = self.profilesTableView.indexPathForSelectedRow
            else { sender.selectedSegmentIndex  = segmentMovingFrom
                return
        }


        
        /// save the selection for current selection
//        daySelectedRowIndexPathArray[segmentMovingFrom] = selectionIndexPath
//
//        let row = selectionIndexPath.row
//        profileForTheDayArray[segmentMovingFrom] = profiles[row].name

            
        /// deselect current selection
        self.profilesTableView.deselectRow(at: selectionIndexPath, animated: true)
        /// save newSegment
        segmentMovingFrom = sender.selectedSegmentIndex
            
        /// set profile selected for current day
//            if !daySelectedRowIndexPathArray[sender.selectedSegmentIndex].isEmpty {
//                profilesTableView.selectRow(at: daySelectedRowIndexPathArray[sender.selectedSegmentIndex], animated: true, scrollPosition: .none)
//            }
//            else {
                /// get the row number from the array of values
                /// get the profile of the day
                
                if let rownumber = profiles.firstIndex(where: { (item) -> Bool in
                    print("Check to hightlight row with --- \(profileForTheDayArray[sender.selectedSegmentIndex])")
                    return item.name == profileForTheDayArray[sender.selectedSegmentIndex]
                }) {
                    profilesTableView.selectRow(at: IndexPath(row: rownumber, section: 0), animated: true, scrollPosition: .none)
                    let profileSelected = profiles[rownumber]
                    profileDescription.text = profileSelected.description
                }
    }
    
    
    // MARK: - Helper Functions
    

    func processStudentNotes() {
            /// Setup
        // let stringToProcess = "a soft ~#~Here fkjbf;;kjkfjvkjf;fjjfjfjf; I want to capture~#~ orange cat"
        let delimeter = "~#~"

        /// Function Call
        do {
            let (extractedString, cleanString) = try HelperFunctions.getStringFrom(passedString: student.notes, using: delimeter)
            
            setAlready = true
            
            /// Process Cleaned String
            print(cleanString)

            /// Process Extracted  String
            let strSplit2 = String(extractedString).split(separator: ";")
            // let strSplit3 = extractedString.split(separator: ";", maxSplits: 100, omittingEmptySubsequences: false)
            
            /// Load Profiles
            for (idx, item)  in strSplit2.enumerated() {
                profileForTheDayArray[idx] = (String(item))
                print("`````loading \(String(item))")
            }

            
            strSplit2.forEach { (item) in
                print("--",item)
            }

        } catch  {
            setAlready = false
            return
        }
        
        //let (extractedString, cleanString) = try! HelperFunctions.getStringFrom(passedString: student.notes, using: delimeter)

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StudentProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        
        let profile = profiles[indexPath.row]
        cell.textLabel?.text = profile.name
        
        /// need this so when I get all the profile names I can buid and index pat arrary
        indexPathDictionary[profile.name] = indexPath

        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileSelected = profiles[indexPath.row]
        profileDescription.text = profileSelected.description
        let row = indexPath.row
        print("888888888", row)
        profileForTheDayArray[segmentMovingFrom] = profiles[row].name
    }
    
   
    
}