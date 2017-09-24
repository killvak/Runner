//
//  RegisterDataSelectionVC.swift
//  RunnerApp
//
//  Created by admin on 9/24/17.
//  Copyright © 2017 CreativeApps. All rights reserved.
//

import UIKit

class RegisterDataSelectionVC: UIViewController {

    @IBOutlet weak var BtnsListView: UIView!
    @IBOutlet weak var dataListView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dataSelectionBtns(_ sender: UIButton) {
        
        self.BtnsListView.alpha = 0
        self.dataListView.alpha = 1
        UIView.transition(from: self.BtnsListView, to: dataListView, duration: 0.5, options: [.transitionFlipFromRight,.showHideTransitionViews])
    }
    @IBAction func cancelDataSelection(_ sender: UIButton) {
        
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
