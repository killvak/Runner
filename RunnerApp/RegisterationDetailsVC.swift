//
//  RegisterationDetailsVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class RegisterationDetailsVC: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var listOfSelectionDataView: UIView!
    @IBOutlet weak var containerView: UIView!

//    @IBOutlet weak var dataSelectionView: UIView!
    @IBOutlet weak var headerView: UIView!
     var selectionDict : [Int: Bool] = [:]

    var shifts = ["Morning","Afternoon","Evening","Late Night"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //yourButton.contentHorizontalAlignment = .left

        // Do any additional setup after loading the view.
        for i in 0...shifts.count - 1 {
            selectionDict[i] = true
            print(i)
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     UIView.transition(from: self.datesView, to: daysView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])

 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTimeSlotCell", for: indexPath) as! RegisterTimeSlotCell
        cell.name.text = shifts[indexPath.row]
        cell.yesBtn.tag = indexPath.row
        cell.noBtn.tag = indexPath.row
        cell.yesBtn.addTarget(self, action: #selector(yesBtnSelected(_:)), for: .touchUpInside)
        cell.noBtn.addTarget(self, action: #selector(noBtnSelected(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    func yesBtnSelected(_ sender : UIButton) {
        
            selectionDict[sender.tag] = true
        handleCellBtnSelection(sender.tag, true)
 
        print("that's the selection List : \(selectionDict)")
    }
    
    func noBtnSelected(_ sender : UIButton) {
        
        selectionDict[sender.tag] = false
        handleCellBtnSelection(sender.tag, false)
        print("that's the selection List : \(selectionDict)")
    }
    
    func handleCellBtnSelection(_ tag : Int ,_ state : Bool) {
        let indexP = IndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: indexP) as! RegisterTimeSlotCell


        if state {
            cell.yesBtn.setBackgroundImage(#imageLiteral(resourceName: "star"), for: .normal)
            cell.noBtn.setBackgroundImage(#imageLiteral(resourceName: "profile_circle"), for: .normal)

        }else {
            cell.noBtn.setBackgroundImage(#imageLiteral(resourceName: "star"), for: .normal)
            cell.yesBtn.setBackgroundImage(#imageLiteral(resourceName: "profile_circle"), for: .normal)

        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 44
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }

//    @IBAction func dataSelectionBtns(_ sender: UIButton) {
//        
//        self.dataSelectionView.alpha = 0
//        self.listOfSelectionDataView.alpha = 1
//             UIView.transition(from: self.listOfSelectionDataView, to: listOfSelectionDataView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
//    }
//    @IBAction func cancelDataSelection(_ sender: UIButton) {
//        
//        self.dataSelectionView.alpha = 1
//        self.listOfSelectionDataView.alpha = 0
//        UIView.transition(from: self.listOfSelectionDataView, to: dataSelectionView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
