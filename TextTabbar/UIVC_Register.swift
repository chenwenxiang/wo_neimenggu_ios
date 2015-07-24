//
//  UIVC_Register.swift
//  TextTabbar
//
//  Created by q on 15/4/29.
//  Copyright (c) 2015年 q. All rights reserved.
//

//
//  UIVC_Login.swift
//  TextTabbar
//
//  Created by q on 15/4/15.
//  Copyright (c) 2015年 q. All rights reserved.
//

import Foundation



class UIVC_Register:  MyViewController,ServiceHelperDelegate,NSXMLParserDelegate{
    
    
    var helper  = ServiceHelper()
    
    
    @IBOutlet weak var      TF_username: UITextField!
    @IBOutlet weak var TF_Passwd: UITextField!
    @IBOutlet weak var TF_passwd_ensure: UITextField!
    @IBOutlet weak var TF_ask: UITextField!
    @IBOutlet weak var TF_answer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)

    }
    
    @IBAction func handle_register(sender: AnyObject) {
        if TF_Passwd.text != TF_passwd_ensure.text
        {
            showAlert("重复密码不一样")
            return
        }
        
        call_server()
    }

    
    func  call_server()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
    
        
        
        
    /*
        String now_action = ACTION_WSQuery_SignIn;
        String WS_NAMESPACE = NAMESPACE;
        
        String mobile = edittext_user_mobile_number.getText().toString();
        String passwd = edittext_user_passwd.getText().toString();
        String repasswd = edittext_user_repasswd_.getText().toString();
        
        SoapObject rpc = new SoapObject(WS_NAMESPACE, now_action);
        
        String random_ = getRandomByte();
        
        Out.print("random_=" + random_);
        
        String send_str = "<?xml version=\"1.0\" encoding=\"GBK\"?><mobil_resp><parameters>" + "<H_UserName>" + mobile
        + "</H_UserName>" + "<H_UserPassword>" + passwd + "</H_UserPassword>" + "<RePassword>" + repasswd
        + "</RePassword>" + "<H_UserEmail>jimy@dtapp.cn</H_UserEmail>" + "<H_UserQuestion>"
        + et_question.getText().toString() + "</H_UserQuestion>" + "<H_UserAnswer>"
        + et_answer.getText().toString() + "</H_UserAnswer>" + "<H_Sex>1</H_Sex>"
        
        + "</parameters>" + "<hash>" + Des.encryptStr(random_, getDesKey()) + "</hash>" + "</mobil_resp>";
        */
        
        
        /*
        @IBOutlet weak var TF_username: UITextField!
        @IBOutlet weak var TF_Passwd: UITextField!
        @IBOutlet weak var TF_passwd_ensure: UITextField!
        @IBOutlet weak var TF_ask: UITextField!
        @IBOutlet weak var TF_answer: UITextField!
        */
        
        var objxml  = "<mobil_resp><parameters><H_UserName>\(TF_username.text)</H_UserName><H_UserPassword>\(TF_Passwd.text)</H_UserPassword><RePassword>\(TF_passwd_ensure.text)</RePassword><H_UserEmail>jimy@dtapp.cn</H_UserEmail><H_UserQuestion>\(TF_ask.text)</H_UserQuestion><H_UserAnswer>\(TF_answer.text)</H_UserAnswer><H_Sex>1</H_Sex></parameters><hash>\(checktxt)</hash></mobil_resp>"

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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_SignIn")
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_SignIn", soapMessage: soapMsg)
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {

        if success == "N"
        {
            showAlert(prompt)
        }
        else  if success == "Y"
        {
            /*
            var userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(userData.UserID, forKey: "UserID")
            userDefaults.setObject(userData.UserName, forKey: "UserName")
            userDefaults.setObject(TF_passwd.text, forKey: "Passwd")
            userDefaults.synchronize()
*/
            
            
            var alertView = UIAlertView()
            alertView.title = ""
            alertView.message = "注册成功！"
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
        }
    }
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
//        if elementName == "article"
//        {
//            userData = UserData()
//            var value: AnyObject? = attributeDict["UserID"]
//            userData.UserID = "\(value!)"
//            
//            value = attributeDict["UserName"]
//            userData.UserName = "\(value!)"
//            
//        }
        
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
