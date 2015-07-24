//
//  UIVC_SelectAddress.swift
//  TextTabbar
//
//  Created by q on 15/4/26.
//  Copyright (c) 2015年 q. All rights reserved.
//


import UIKit



class UIVC_SelectAddress: MyViewController,ServiceHelperDelegate, UITableViewDataSource, NSXMLParserDelegate,UITableViewDelegate{
    
    //调用接口的类型，此界面是重复利用界面，所以需要指定调用方式
  //  var call_type = WS_SearchGoodByKeyword
    
    var delegate:SelectAddressDelegate?
    
    var helper  = ServiceHelper()
    var addressList = Array<AddressList>()
    var choice = [Bool]()
    
    var call_action = 0
    
    var show_num = 13
    var search_keyword = ""
    var des_key = "dtapp100"
    var random = "aaaaabbbbb"
    var select_address = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
        
    }
    override func viewDidAppear(animated: Bool) {
        
        request_get_addressList()
    }
    
    
    
    
    
    func Button_choiceGoods(button:UIButton)
    {
        
        var but_tag = button.tag-400
        
        if but_tag < addressList.count
        {
            if choice[but_tag ] == true
            {
                choice[but_tag ] = false
            }else
            {
                choice[but_tag ] = true
            }
            tableView.reloadData()
            
            
            if((delegate) != nil){
                delegate?.changeWord(self, addressData: addressList[but_tag])
                
                
                //[self.navigationController popViewControllerAnimated:YES];
                //self.navigationController?.popViewControllerAnimated(true)
                
                //            self.performSegueWithIdentifier("back_key", sender: self)
                //            self.dismissViewControllerAnimated(<#flag: Bool#>, completion: <#(() -> Void)?##() -> Void#>)
                
                self.dismissViewControllerAnimated(true, completion: {})
                
            }
            
        }
    }
    
    var delete_address_id = ""
    
    
    func Button_deleteGoodsNum(button:UIButton)
    {
        
        var but_tag = button.tag-300
        
        if but_tag < addressList.count
        {
            delete_address_id = addressList[but_tag].AddressID
            
            request_delete_address()
        }
        
    }
    
    
    
    
    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return addressList.count
    }
    
    // Display the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        // Must use 'self' here because searchResultsTableView needs to reuse the same cell in self.tableView
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ChoiceAddressCell") as UITableViewCell
        
        
        var title_mobile = cell.viewWithTag(1002) as UILabel
        title_mobile.text = addressList[indexPath.row].MobilePhone
        
        
        var title_name = cell.viewWithTag(1003) as UILabel
        title_name.text = addressList[indexPath.row].UserName
        
        
        var title_address = cell.viewWithTag(1004) as UILabel
        title_address.text = addressList[indexPath.row].Address
        
        
        
        if cell.viewWithTag(1005) != nil
        {
            var button_sub = cell.viewWithTag(1005) as UIButton
            button_sub.tag = 300+indexPath.row
            
            button_sub.addTarget(self, action: "Button_deleteGoodsNum:", forControlEvents: UIControlEvents.TouchUpInside);
        }
        
        
        
        if cell.viewWithTag(1001) != nil
        {
            var button_choice = cell.viewWithTag(1001)  as UIButton
            button_choice.tag = indexPath.row + 400
            
            if select_address == indexPath.row
            {
                button_choice.setImage(UIImage(named: "icon_multiOn.png"),forState:.Normal)
            }
            
            
            button_choice.addTarget(self, action: "Button_choiceGoods:", forControlEvents: UIControlEvents.TouchUpInside);
            
        }
        else
        {
            
            var button_choice = cell.viewWithTag(400+indexPath.row)  as UIButton
            if choice[indexPath.row] == false
            {
                button_choice.setImage(UIImage(named: "icon_multiOff.png"),forState:.Normal)
            }
            else
            {
                button_choice.setImage(UIImage(named: "icon_multiOn.png"),forState:.Normal)
            }
        }
        
        
        
        return cell
    }
    
    var goodsInfoId:String?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //goodsInfoId = goodsDataList[indexPath.row].productID
        //        var uivc_searchlist = UIVC_GoodsIntroduction()
        //        uivc_searchlist.navigationController
        // self.performSegueWithIdentifier("GoodsIntroSearchWordList", sender: self)
        
        println("indexPath.row=\(indexPath.row)")
        
        if((delegate) != nil){
            delegate?.changeWord(self, addressData: addressList[indexPath.row])
            
            
            //[self.navigationController popViewControllerAnimated:YES];
            //self.navigationController?.popViewControllerAnimated(true)
            
            //            self.performSegueWithIdentifier("back_key", sender: self)
            //            self.dismissViewControllerAnimated(<#flag: Bool#>, completion: <#(() -> Void)?##() -> Void#>)
            
            self.dismissViewControllerAnimated(true, completion: {})
            
        }
        
        
        
    }
    
    
    
    func deselect()
    {
        //[self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow] animated:YES];
        self.deselect()
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow()!, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    var action = ""
    
    func  request_get_addressList()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        
        var objxml  = "<mobil_resp><parameters><UserId>\(103)</UserId></parameters><hash>\(checktxt)</hash></mobil_resp>"
        
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_GetAddress")
        
        call_action = 1
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_GetAddress", soapMessage: soapMsg)
    }
    
    
    
    /*
    
    
				String now_action = "WSQuery_DelAddress";
    
				SoapObject rpc = new SoapObject(NAMESPACE, now_action);
				String random_ = getRandomByte();
    
				Out.print("random_=" + random_);
    
				String send_str = "<?xml version=\"1.0\" encoding=\"GBK\"?><mobil_resp><parameters>"
    
				+ "<UserID>" + User.UserID + "</UserID>" + "<AddressID>" + delete_address_id + "</AddressID>"
    
				+ "</parameters>" + "<hash>" + Des.encryptStr(random_, getDesKey()) + "</hash>" + "</mobil_resp>";
    
				Out.print(send_str);
    
				rpc.addProperty("checktxt", random_);
				rpc.addProperty("objXml", send_str);
    
    */
    
    func  request_delete_address()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        
        var objxml  = "<mobil_resp><parameters><UserID>\(103)</UserID><AddressID>\(delete_address_id)</AddressID></parameters><hash>\(checktxt)</hash></mobil_resp>"
        
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_DelAddress")
        
        call_action = 2
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_DelAddress", soapMessage: soapMsg)
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
        
        if call_action  == 1
        {
            for var i = 0; i < addressList.count; i++
            {
                choice.append(false)
            }
            
            self.tableView.reloadData()
        }
        if call_action  == 2
        {
            request_get_addressList()
        }
        
    }
    
    var create_order_success = false
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
        if call_action  == 1
        {
            if elementName == "article"
            {
                var addressTemp = AddressList()
                
                var value: AnyObject? = attributeDict["AddressID"]
                addressTemp.AddressID = "\(value!)"
                
                value = attributeDict["UserName"]
                addressTemp.UserName = "\(value!)"
                
                value = attributeDict["Address"]
                addressTemp.Address = "\(value!)"
                
                value = attributeDict["MobilePhone"]
                addressTemp.MobilePhone = "\(value!)"
                
                addressList.append(addressTemp)
            }
        }
        if call_action  == 2
        {
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
    }
    
    func finishFailRequest(error: NSError!) {
        println("异步请求发生失败:\(error.description)\n")
    }
    
    func finishSuccessRequest(xml: String!) {
        
        println("异步请求返回867xml:\n\(xml)\n")
        println("=======异步请求结束======\n")
        
        addressList.removeAll(keepCapacity: true)
        
        
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
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }
}



//定义协议改变Label内容
protocol SelectAddressDelegate:NSObjectProtocol{
    //回调方法
    func changeWord(controller:UIVC_SelectAddress,addressData:AddressList)
}


