//
//  UIVC_Login.swift
//  TextTabbar
//
//  Created by q on 15/4/15.
//  Copyright (c) 2015年 q. All rights reserved.
//

import Foundation



class UIVC_Login:  MyViewController,ServiceHelperDelegate,NSXMLParserDelegate{

    
    var helper  = ServiceHelper()
    
    
    @IBOutlet weak var TF_UserName: UITextField!
    @IBOutlet weak var TF_passwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
        
        
        
                

    }
    
    
    
    
    
    @IBAction func login(sender: AnyObject) {
        call_server()
        
      
        
    }
    
    
    func  call_server()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        
        
        
//        "<parameters>" + "<name>" + Des.encryptStr(account, getDesKey()) + "</name>" + "<pwd>"
//            + Des.encryptStr(passwd, getDesKey()) + "</pwd>" + "</parameters>"
        
        
        println(TF_UserName.text)
        println(TF_passwd.text)
        
        var send_user = aFraction.encryptUseDES(TF_UserName.text, key: "dtapp100" )
        var send_passwd = aFraction.encryptUseDES(TF_passwd.text, key: "dtapp100" )
        
        var objxml  = "<mobil_resp><parameters><name>\(send_user)</name><pwd>\(send_passwd)</pwd></parameters><hash>\(checktxt)</hash></mobil_resp>"
        

        
        
        //        String send_str = "<mobil_resp><parameters>" + "<ProductId>" + product_id + "</ProductId>" + "</parameters>" + "<hash>"
        //            + Des.encryptStr(random_, getDesKey()) + "</hash>" + "</mobil_resp>";
        
        println(objxml)
        
        
        objxml = objxml.stringByReplacingOccurrencesOfString("<", withString: "&lt;", options: nil, range: nil)
        objxml = objxml.stringByReplacingOccurrencesOfString(">", withString: "&gt;", options: nil, range: nil)
        objxml = objxml.stringByReplacingOccurrencesOfString("\"", withString: "&quot;", options: nil, range: nil)
        
        
        
        println("=======异步请求开始======\n")
        
        var arr = NSMutableArray()
        
        var dictionary = NSDictionary(object: objxml, forKey: "objXml")
        arr.addObject(dictionary)
        
        var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
        arr.addObject(dictionary_2)
        
        var dictionary_3 = NSDictionary(object: "", forKey: "TEST")
        arr.addObject(dictionary_3)
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_LogIn")
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_LogIn", soapMessage: soapMsg)
    }
    

    
    
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
//        var userDefaults = NSUserDefaults.standardUserDefaults()
//        var vvv = userDefaults.integerForKey("ffffff")
//        
//        println("vvv=\(vvv)")
//        if vvv >= 100
//        {
//            vvv = vvv+1
//        }
//        else
//        {
//            vvv = 100
//        }
//        userDefaults.setInteger(vvv, forKey: "ffffff")
//        userDefaults.synchronize()
        
        
        
        if success == "N"
        {
            showAlert(prompt)
        }
        else  if success == "Y"
        {
            
            
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(userData.UserID, forKey: "UserID")
            userDefaults.setObject(userData.UserName, forKey: "UserName")
            userDefaults.setObject(TF_passwd.text, forKey: "Passwd")
            userDefaults.synchronize()
            
            
            var alertView = UIAlertView()
            alertView.title = ""
            alertView.message = "登录成功！"
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
            
            self.dismissViewControllerAnimated(true, completion: {})
            
           // self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
        
        
        if elementName == "article"
        {
            userData = UserData()
            var value: AnyObject? = attributeDict["UserID"]
            userData.UserID = "\(value!)"
            
            value = attributeDict["UserName"]
            userData.UserName = "\(value!)"
            
        }
        
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
