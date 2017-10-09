//
//  HomePageVC.swift
//  RunnerApp
//
//  Created by admin on 9/25/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit
import SwiftyStarRatingView

class HomePageVC: UIViewController , UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    @IBOutlet weak var numOfDeliveriesLbl: UILabel!
    
    @IBOutlet weak var noDataFoundLbl: UILabel!
    let userRequest = M_UserRequest()
    var numOfOrders = 0
    var homeData : [OrderDataAndDetails] = []
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 159
        
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(self.view.frame.height * 0.25))
        
 
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
         profileImage.addGestureRecognizer(tapGestureRecognizer)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let isOnline = UserDefaults.standard.value(forKey: "runnerIsOnLine") as? Bool , isOnline  else {
            homeData =  []
            self.tableView.reloadData()
            noDataFoundLbl.alpha = 1
            noDataFoundLbl.text = "You'r Offline"
            return
        }
        noDataFoundLbl.alpha = 0
        updateData()
    }
    func updateData() {
        ad.isLoading()
        userRequest.getHomePageData(1,14) {[weak self ] (opData, state, sms ) in
            guard state , let data = opData , let orderData = data.ordesArray else {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.noDataFoundLbl.alpha = 1
                    ad.killLoading()
                }

                return
            }
            DispatchQueue.main.async {
                self?.noDataFoundLbl.alpha = 0
                self?.ratingView.value = CGFloat(data.runnerRate)
                self?.numOfDeliveriesLbl.text = "No: of Deliveries done \n \(data.totalOrders)"
                self?.numOfOrders = data.totalOrders
                self?.homeData = orderData
                self?.tableView.reloadData()
                ad.killLoading()
            }
        }
    }
    @IBAction func menuBtnHundler(_ sender: UIBarButtonItem) {
        let x = HelpeMenuVC()
        x.modalTransitionStyle = .coverVertical
        //        view.navigationController?.present(x, animated: true, completion: nil)
        //        self.view.present(x, animated: true, completion: nil)
        self.present(x, animated: true, completion: nil)
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileImage.layer.cornerRadius =  profileImage.bounds.size.width   / 2
        self.profileImage.clipsToBounds = true
    }
    
    
    func imageTapped()
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        // Your action
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {

            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
   
    @IBAction func viewDetails(_ sender: UIButton) {
        
        guard numOfOrders >= 1  else {
            self.view.showSimpleAlert("", "There's no data to view", .alarm)
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrdersTVC") as! OrdersTVC
        
        self.navigationController?.pushViewController(vc, animated: true)
      }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOrdersCell_ID", for: indexPath) as! HomeOrdersCell
          let data = homeData[indexPath.row]  
        cell.orderTitle.text = data.order_details
        cell.orderSerialNum.text = "Order_ID : \(data.orderID)"
        cell.dateofOrder.text = data.created_at
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let data = homeData[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderVC") as! NewOrderVC
        vc.orderDetails = data
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
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




class HomeOrdersCell: UITableViewCell {
    
    @IBOutlet weak var orderTitle: UILabel!
    @IBOutlet weak var dateofOrder: UILabel!
    @IBOutlet weak var orderSerialNum: UILabel!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

