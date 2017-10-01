//
//  RegisterDataSelectionVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

protocol RegisterDetailsProtocoal : class  {
    func sendCurrentDataSelection(_ data : [String:String])
}

class RegisterDataSelectionVC: UIViewController  {

    @IBOutlet weak var BtnsListView: UIView!
    @IBOutlet weak var dataListView: UIView!
    @IBOutlet weak var dismissTableBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var modeOfTransportationBtn: UIButton!
    @IBOutlet weak var startingTimeBtn: UIButton!
    @IBOutlet weak var worksHoursBtn: UIButton!

    var dataDict : [String:String] = [:]
    var SelectedBtnTag : Int = 0
 
    
    weak var delegate : RegisterDetailsProtocoal?
  fileprivate   var data : dataListItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        data = dataListItems(0)
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dataSelectionBtns(_ sender: UIButton) {
        self.SelectedBtnTag = sender.tag
         data = dataListItems(sender.tag)
        self.tableView.reloadData()

        
         self.BtnsListView.alpha = 0
        self.dataListView.alpha = 1
        UIView.transition(from: self.BtnsListView, to: dataListView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
    }
    @IBAction func cancelDataSelection(_ sender: UIButton) {
        dismissListView()
    }
    
    func dismissListView() {
        
        delegate?.sendCurrentDataSelection(dataDict)
        self.tableView.scrollToTop()
        
        self.BtnsListView.alpha = 1
        self.dataListView.alpha = 0
        UIView.transition(from: self.dataListView, to: BtnsListView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension RegisterDataSelectionVC :  UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataa = data else {
            return 0 }
        
        return dataa.listOfNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterData", for: indexPath) as! RegisterListOfDataCell
        guard let dataa = data else {
            return cell }
        cell.dataTitle.text = dataa.listOfNames[indexPath.row]
        cell.selectedBtnTag = SelectedBtnTag
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! RegisterListOfDataCell
        guard  let tag = cell.selectedBtnTag , let dataa = data else {
            dismissListView()
            return
        }
        print("that's it : \(dataa.listOfNames[indexPath.row])" )
        switch tag {
        case 0:
            dataDict["transportation"] = dataa.listOfNames[indexPath.row]
            self.modeOfTransportationBtn.setTitle(dataa.listOfNames[indexPath.row], for: .normal)
            self.modeOfTransportationBtn.setTitleColor(.darkGray, for: .normal)
        case 1 :
            dataDict["start_time"] = dataa.listOfNames[indexPath.row]
             self.startingTimeBtn.setTitle(dataa.listOfNames[indexPath.row], for: .normal)
            self.startingTimeBtn.setTitleColor(.darkGray, for: .normal)
        default:
            dataDict["work_hours"] = dataa.listOfNames[indexPath.row]
             self.worksHoursBtn.setTitle(dataa.listOfNames[indexPath.row], for: .normal)
            self.worksHoursBtn.setTitleColor(.darkGray, for: .normal)
        }

        dismissListView()
    }
}





fileprivate class dataListItems {
    private var tagName : [String]?
    var listOfNames : [String] {
        guard let tgn = tagName else {
            return []
        }
        return tgn
    }
    
    init(_ tag : Int) {
        switch tag {
        case 0 :
            tagName = ["Car","Bike","Moped","Motor Cycle","Truck"]
        case 1 :
            tagName = ["Today","This Week","This Month"]
        default :
            tagName = ["Under 10 Hours","10 to 20 Hours","20 to 30 Hours","30 to 40 Hours","+40 Hours"]
        }
    }
}

 
