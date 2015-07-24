//
//  UIVC_Login.swift
//  TextTabbar
//
//  Created by q on 15/4/15.
//  Copyright (c) 2015年 q. All rights reserved.
//

import Foundation



class UIVC_AddAddress:  MyViewController,ServiceHelperDelegate,NSXMLParserDelegate{
    
    
    var helper  = ServiceHelper()
    
    
    @IBOutlet weak var TF_name: UITextField!
    @IBOutlet weak var TF_mobile: UITextField!
    @IBOutlet weak var TF_address: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
    }

    
    @IBAction func handle_add_address(sender: AnyObject) {
        
        call_server()
    }
   
    
    func  call_server()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")

        println("=======异步请求开始======\n")
        
        var arr = NSMutableArray()
        
        var dictionary = NSDictionary(object: checktxt, forKey: "HashValue")
        arr.addObject(dictionary)
        
        var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
        arr.addObject(dictionary_2)
        
        var dictionary_3 = NSDictionary(object: "103", forKey: "UserID")
        arr.addObject(dictionary_3)
        
        var dictionary_4 = NSDictionary(object: TF_name.text, forKey: "UserName")
        arr.addObject(dictionary_4)
        
        var dictionary_5 = NSDictionary(object: TF_address.text, forKey: "Address")
        arr.addObject(dictionary_5)
        
        var dictionary_6 = NSDictionary(object: "000000", forKey: "ZipCode")
        arr.addObject(dictionary_6)
        
        var dictionary_7 = NSDictionary(object: TF_mobile.text, forKey: "Phone")
        arr.addObject(dictionary_7)
        
        var dictionary_8 = NSDictionary(object: TF_mobile.text, forKey: "MobilePhone")
        arr.addObject(dictionary_8)
        
        var dictionary_9 = NSDictionary(object: TF_mobile.text, forKey: "Email")
        arr.addObject(dictionary_9)
        
        var dictionary_10 = NSDictionary(object: TF_address.text, forKey: "Province")
        arr.addObject(dictionary_10)
        
        var dictionary_11 = NSDictionary(object: TF_address.text, forKey: "City")
        arr.addObject(dictionary_11)

        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_addAddress")
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_addAddress", soapMessage: soapMsg)
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        if success == "N"
        {
            showAlert(prompt)
        }
        else if success == "Y"
        {
            var alertView = UIAlertView()
            alertView.title = ""
            alertView.message = "添加成功！"
            alertView.addButtonWithTitle("知道了")
            alertView.cancelButtonIndex = 0
            alertView.delegate = self
            alertView.show()
        }
    }
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == alertView.cancelButtonIndex
        {
            println("buttonIndex == alertView.cancelButtonIndex")
            
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
//        if elementName == "article"
//        {
//            userData = UserData()
//            var value: AnyObject? = attributeDict["UserID"]
//            userData?.UserID = "\(value!)"
//            
//            value = attributeDict["UserName"]
//            userData?.UserName = "\(value!)"
//        }
//        
        if elementName == "mobil_resp"
        {
            var value: AnyObject? = attributeDict["success"]
            success = "\(value!)"
            
            value = attributeDict["prompt"]
            
            if value != nil
            {
                prompt = "\(value!)"
            }

        }
    }
    
    func finishFailRequest(error: NSError!) {
        println("异步请发生失败:\(error.description)\n")
    }
    
    func finishSuccessRequest(xml: String!) {
        
        println("异步请求返回867xml:\n\(xml)\n")
        println("=======异步请求结束======\n")
        
        
        
        
        var getxml = xml.stringByReplacingOccurrencesOfString("<?xml version=\"1.0\" encoding=\"GBK\"?>", withString: "<?xml version=\"1.0\" encoding=\"utf-8\"?>", options: nil, range: nil)
        
        var data = getxml.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        var parser = NSXMLParser(data: data)
        parser.delegate = self
        
        var parse_sc =  parser.parse()
    }
    
    func finishQueueComplete() {
        println("=====所有队列请求完成=====\n")
    }
    
    func finishSingleRequestSuccess(xml: String!, userInfo dic: [NSObject : AnyObject]!) {
        var name = dic.description
        
        println("队列,请求完成\n")
        println("队列返回的xml为\n\(name)\n")
    }
    
    func finishSingleRequestFailed(error: NSError!, userInfo dic: [NSObject : AnyObject]!) {
        var name = dic.description
        
        println("队列,请求失败\n")
        println("队列请求失败：\n\(name)\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }
}
