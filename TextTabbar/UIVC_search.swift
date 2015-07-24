//
//  File.swift
//  TextTabbar
//
//  Created by q on 15/1/19.
//  Copyright (c) 2015年 q. All rights reserved.
//

import UIKit

class UIVC_search:  UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var ui_TFsearch: UITextField!
    
    var uivc_searchlist = TabBarViewController()
  
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("flaggg")
        ui_TFsearch.delegate = self
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func  textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        if(textField == ui_TFsearch)
        {
            println("equal")
        }
        println(textField.text)
        textField.resignFirstResponder()
        
        var uivc_searchlist = UIVC_SearchKeyword()
        //uivc_searchlist.navigationController
        
        self.performSegueWithIdentifier("search_word_list", sender: self)
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "search_word_list"
        {
            var vc = segue.destinationViewController as UIVC_SearchKeyword
            
            vc.call_type = vc.WS_SearchByKeyword
            vc.search_keyword = ui_TFsearch.text
        }
    }
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }

}
