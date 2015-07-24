//
//  UIVC_MemberCenter.swift
//  TextTabbar
//
//  Created by q on 15/5/8.
//  Copyright (c) 2015 q. All rights reserved.
//


import UIKit


class UIVC_MemberCenter: UITableViewController,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,ServiceHelperDelegate{
    
    var call_count = 0
    
    var memberCredits = MemberCredits()
    var discountCoupons  = Array<DiscountCoupon>()
    var tradeRecords = Array<TradeRecord>()
    
    var helper  = ServiceHelper()
    
    @IBOutlet weak var UIL_fu_value: UILabel!//付值
    
    @IBOutlet weak var UIL_buyValue: UILabel!//积分
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
        
        call_count = 0
        query_GetTradRecord()
        
    }
    
    var viewsArray : NSMutableArray?
    var adsInt: NSInteger?
    
    
    func query_GetTradRecord()
    {
        var action_str = "WSQuery_APPExecCRM_XFJL"
        
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        var arr = NSMutableArray()
        
        var dictionary = NSDictionary(object: checktxt, forKey: "HashValue")
        arr.addObject(dictionary)
        var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
        arr.addObject(dictionary_2)
        var dictionary_3 = NSDictionary(object: "\(userData.UserID)|2013-01-01|2020-12-31 ", forKey: "sInXML")
        arr.addObject(dictionary_3)
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: action_str)
        
        println("=======异步请求开始======\n")
        helper.asynServiceMethod(action_str, soapMessage: soapMsg)
        
    }
    
    func query_GetCreditsAndTicket()
    {
        var action_str = "WSQuery_APPExecCRM_ZYE"
        
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        var arr = NSMutableArray()
        
        var dictionary = NSDictionary(object: checktxt, forKey: "HashValue")
        arr.addObject(dictionary)
        var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
        arr.addObject(dictionary_2)
        var dictionary_3 = NSDictionary(object: "\(userData.UserID)", forKey: "sInXML")
        arr.addObject(dictionary_3)
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: action_str)
        
        println("=======异步请求开始======\n")
        helper.asynServiceMethod(action_str, soapMessage: soapMsg)
        
    }
    
    var voucher_num = 3
    var discount = 5
    
    // MARK - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return tradeRecords.count
        
        return 2+voucher_num+1+discount
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            if (indexPath.row < 2)
            {
                return  44.0
            }
            else if (indexPath.row < 2 + voucher_num)
            {
                return 62.0
            }
            else if (indexPath.row == 2 + voucher_num)
            {
                return 44.0
            }
            else
            {
                return 88.0
            }
        }
        
        return 80.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var  cell:UITableViewCell?
        
        if(indexPath.row == 0)
        {
            cell = self.tableView.dequeueReusableCellWithIdentifier("cell_1") as UITableViewCell
            
            var fu_value = cell!.viewWithTag(1001) as UILabel
            fu_value.text = "付值：\(memberCredits.balance)"
            
            var buyValue = cell!.viewWithTag(1002) as UILabel
            buyValue.text = "积分：\(memberCredits.cent_available)"
            
            //            UIL_fu_value.text = "付值：\(memberCredits.balance)"
            //            UIL_buyValue.text = "积分：\(memberCredits.cent_available)"
        }
        else if(indexPath.row == 1)
        {
            cell = self.tableView.dequeueReusableCellWithIdentifier("cell_2") as UITableViewCell
        }
            
        else if (indexPath.row < 2 + voucher_num)
        {
            
            cell = self.tableView.dequeueReusableCellWithIdentifier("voicher_list") as UITableViewCell
        }
        else if (indexPath.row == 2 + voucher_num)
        {
            
            cell = self.tableView.dequeueReusableCellWithIdentifier("cell_3") as UITableViewCell
        }
        else
        {
            cell = self.tableView.dequeueReusableCellWithIdentifier("trade_order_list") as UITableViewCell
        }
   
        return cell!
        
    }
    

    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
        switch(call_count)
        {
        case 0:
            call_count++
            query_GetCreditsAndTicket()
            self.tableView.reloadData()
            break;
        case 1:
//            UIL_fu_value.text = "付值：\(memberCredits.balance)"
//            UIL_buyValue.text = "积分：\(memberCredits.cent_available)"
            self.tableView.reloadData()
            break;
        default:
            break;
        }
        
    }
    
    var discountCoupon_temp = DiscountCoupon()
    var element_nannn = ""
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        println("qName=\(qName)")
        
        
        switch(call_count)
        {
        case 0:
            
            if elementName == "item"
            {
                var data_item = TradeRecord()
                var value = attributeDict["seq_id"]
                data_item.seq_id = "\(value!)"
                
                data_item = TradeRecord()
                value = attributeDict["shop_name"]
                data_item.shop_name = "\(value!)"
                
                data_item = TradeRecord()
                value = attributeDict["pos_id"]
                data_item.pos_id = "\(value!)"
                
                data_item = TradeRecord()
                value = attributeDict["bill_id"]
                data_item.bill_id = "\(value!)"
                
                
                data_item = TradeRecord()
                value = attributeDict["time_shopping"]
                data_item.time_shopping = "\(value!)"
                
                
                data_item = TradeRecord()
                value = attributeDict["prod_code"]
                data_item.prod_code = "\(value!)"
                
                
                data_item = TradeRecord()
                value = attributeDict["prod_name"]
                data_item.prod_name = "\(value!)"
                
                
                data_item = TradeRecord()
                value = attributeDict["sale_num"]
                data_item.sale_num = "\(value!)"
                
                
                data_item = TradeRecord()
                value = attributeDict["sale_m"]
                data_item.sale_m = "\(value!)"
                
                
                data_item = TradeRecord()
                value = attributeDict["disc_m"]
                data_item.disc_m = "\(value!)"
                
                
                data_item = TradeRecord()
                value = attributeDict["cent"]
                data_item.cent = "\(value!)"
                
                tradeRecords.append(data_item)
            }
            break;
        case 1:
            
            element_nannn = elementName
            
            if elementName == "yelist"
            {
                
              //for (int i = 0; i < parser.getAttributeCount(); i++) {

                var value = attributeDict["cent_available"]
                memberCredits.cent_available = "\(value!)"
                
                 value = attributeDict["balance"]
                memberCredits.balance = "\(value!)"
                
                
            }
            
            if elementName == "voucher"
            {
                var value = attributeDict["id"]
                discountCoupon_temp.id = "\(value!)"
            }
           
            
            break;
        default:
            break;
        }

    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if call_count == 1
        {
            if element_nannn == "name"
            {
                discountCoupon_temp.name = string
            }
            if element_nannn == "balance"
            {
                discountCoupon_temp.balance = string
            }
        }

    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {

        if call_count == 1
        {
            if elementName == "voucher"
            {
                discountCoupons.append(discountCoupon_temp)
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
        
        println("parser.parserError=\(parser.parserError)")
    }
    
    func finishQueueComplete() {
        println("=====所有队列请求完成=====\n")
    }
    
    func finishSingleRequestSuccess(xml: String!, userInfo dic: [NSObject : AnyObject]!) {
        // var name = dic.description
        
        println("队列,请求完成\n")
        // println("队列返回的xml为\n\(name)\n")
    }

    func finishSingleRequestFailed(error: NSError!, userInfo dic: [NSObject : AnyObject]!) {
        // var name = dic.description
        
        println("队列,请求失败\n")
        // println("队列请求失败：\n\(name)\n")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }

}









