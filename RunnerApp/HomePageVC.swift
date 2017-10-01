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
    
 
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(self.view.frame.height * 0.25))
        
        self.numOfDeliveriesLbl.text = "No: of Deliveries done \n 3 "
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
         profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.setBackgroundImage(#imageLiteral(resourceName: "favourite_icon_menu"), for: .normal)
        backButton.addTarget(self, action: #selector(triggerMenu), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
     }
    
    func triggerMenu() {
     
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
        
        let vc = LoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "hi"
        return cell
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
