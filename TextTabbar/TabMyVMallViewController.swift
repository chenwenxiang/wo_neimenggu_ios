//
//  TabMyVMallViewController.swift
//  TextTabbar
//
//  Created by q on 15/4/29.
//  Copyright (c) 2015年 q. All rights reserved.
//


import UIKit

class TabMyVMallViewController:  UITableViewController{
    
    
    @IBOutlet weak var Button_personal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        if userData.UserName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
        {
            Button_personal.setTitle("欢迎您，\(userData.UserName)", forState: UIControlState.Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
