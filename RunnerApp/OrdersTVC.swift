//
//  OrdersTVC.swift
//  RunnerApp
//
//  Created by admin on 9/26/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class OrdersTVC: UITableViewController {
    
    @IBOutlet var ordersTableView: UITableView!
    
    let userRequest = M_UserRequest()
    var ordersData : [OrderDataAndDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.rowHeight = UITableViewAutomaticDimension
        ordersTableView.estimatedRowHeight = 159
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateData()
        
    }
    func updateData() {
        ad.isLoading()
        userRequest.getRunnerOrders(20) {[weak self ] (opData, state, sms ) in
            guard state , let data = opData else {
                DispatchQueue.main.async {
                self?.view.showSimpleAlert("", "Couldn't find Any Data",.alarm)
                ad.killLoading()
                }
                return
            }
            DispatchQueue.main.async {
                self?.ordersData = data
                self?.tableView.reloadData()
                ad.killLoading()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ordersData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell_ID", for: indexPath) as! OrdersCell
        let data = ordersData[indexPath.row]
        
        cell.orderTitle.text  = data.order_details
        cell.orderDetails.text  = data.order_details
        cell.dateofOrder.text = data.created_at
        
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderVC") as! NewOrderVC
        //        vc.orderIsActive = indexPath.row
        //        vc.orderIsActive = 0...2 ~=  indexPath.row ? indexPath.row : 1
        
        self.navigationController?.pushViewController(vc, animated: true )
    }
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
