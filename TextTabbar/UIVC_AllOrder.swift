//
//  UIVC_SearchList.swift
//  TextTabbar
//
//  Created by q on 15/1/21.
//  Copyright (c) 2015年 q. All rights reserved.
//

import UIKit

class UIVC_AllOrder: UITableViewController, ServiceHelperDelegate,NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate{
    
    
    var show_num = 13
    var helper  = ServiceHelper()
    
    var orderList = Array<OrderList>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
        
        Request_order_list()
        
    }
    
    
    // MARK - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderList.count
    }
    
    // Display the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Must use 'self' here because searchResultsTableView needs to reuse the same cell in self.tableView
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell_order_list") as UITableViewCell
        
        var order_id = cell.viewWithTag(1001) as UILabel
        order_id.text = "订单编号：\(orderList[indexPath.row].OrderFormNum)"
        
        var order_money = cell.viewWithTag(1002) as UILabel
        order_money.text = "订单金额：\(orderList[indexPath.row].MoneyTotal)"
        
        
        var order_date = cell.viewWithTag(1003) as UILabel
        order_date.text = "\(orderList[indexPath.row].InputTime)"
        
        var order_status = cell.viewWithTag(1004) as UILabel
        order_status.text = "\(orderList[indexPath.row].status)"
        
        return cell
    }
    
    
    var selece_pos = 0
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        var uivc_searchlist = UIVC_OrderDetail()
        uivc_searchlist.navigationController
        
        selece_pos = indexPath.row
        
        self.performSegueWithIdentifier("orderDetail", sender: self)
        
    }
    
    
    
    
    var call_action = 0
    
    
    func  Request_order_list()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        
        
        
        
        /*
        
        
        
        
        //    String now_action = "WSQuery_GetOrderTable";
        //
        //				SoapObject rpc = new SoapObject(NAMESPACE, now_action);
        //				String random_ = getRandomByte();
        //
        //				String send_str = "<?xml version=\"1.0\" encoding=\"GBK\"?><mobil_resp><parameters " + " Page=\"" + pageNum + "\" MaxPerPage=\"10\"" + " UserID=\"" + User.UserID
        //    + "\"" + " OrderNum=\"\"" + " BeginDate=\"\"" + " EndDate=\"\"" + " oStatic=\"\"" + " pStatic=\"\"" + "  />" + "<hash>"
        //    + Des.encryptStr(random_, getDesKey()) + "</hash>" + "</mobil_resp>";
        */
        
        var objxml = "<mobil_resp><parameters   Page=\"\(1)\" MaxPerPage=\"10\" UserID=\"\(103)\"" + " OrderNum=\"\"" + " BeginDate=\"\" EndDate=\"\" oStatic=\"\" pStatic=\"\"  /><hash>\(checktxt)</hash></mobil_resp>"
        
        
        
       // var objxml = "<mobil_resp><UserID>\(103)</UserID><AddressID>\(addressList[0].AddressID)</AddressID><NeedInvoice>1</NeedInvoice><articlelist>\(goods_str)</articlelist><hash>\(checktxt)</hash></mobil_resp>"
        
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_GetOrderTable")
        
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_GetOrderTable", soapMessage: soapMsg)
    }
    

    

    
    func parserDidEndDocument(parser: NSXMLParser!) {
      
            tableView.reloadData()
      
        
    }
    
    var create_order_success = false
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
       
            if elementName == "article"
            {
                var addressTemp = OrderList()
                
                var value: AnyObject? = attributeDict["OrderFormNum"]
                addressTemp.OrderFormNum = "\(value!)"
                
                value = attributeDict["TradeType"]
                addressTemp.TradeType = "\(value!)"
                
                value = attributeDict["InputTime"]
                addressTemp.InputTime = "\(value!)"
                
                value = attributeDict["MoneyTotal"]
                addressTemp.MoneyTotal = "\(value!)"
                
                value = attributeDict["MoneyReceipt"]
                addressTemp.MoneyReceipt = "\(value!)"
                
                value = attributeDict["status"]
                addressTemp.status = "\(value!)"
                
                
                value = attributeDict["PayStatus"]
                addressTemp.PayStatus = "\(value!)"
                
                
                orderList.append(addressTemp)
                
                //var orderList = Array<OrderList>()
            }
        
    }
    
    func finishFailRequest(error: NSError!) {
        println("异步请求发生失败:\(error.description)\n")
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "orderDetail"
        {
            var vc = segue.destinationViewController as UIVC_OrderDetail
            vc.order_id = orderList[selece_pos].OrderFormNum
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }
}
