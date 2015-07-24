//
//  MyViewController.swift
//  TextTabbar
//
//  Created by q on 15/4/17.
//  Copyright (c) 2015年 q. All rights reserved.
//

import UIKit


class MyViewController:  UIViewController{
    
    
    var success = ""
    var prompt = ""
    
    func showAlert(showMessage: String)
    {
        var alertView = UIAlertView()
        alertView.title = ""
        alertView.message = showMessage
        alertView.addButtonWithTitle("知道了")
        alertView.delegate = self
        alertView.show()
    }
    
    
    func showlogin()
    {
        var alertView = UIAlertView()
        alertView.title = ""
        alertView.message = "对不起，请登录"
        alertView.addButtonWithTitle("好")
        alertView.cancelButtonIndex = 0
        alertView.delegate = self
        alertView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}