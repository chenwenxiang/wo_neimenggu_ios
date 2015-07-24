//
//  UIVC_WriteOrder.swift
//  TextTabbar
//
//  Created by q on 15/4/12.
//  Copyright (c) 2015年 q. All rights reserved.
//


import UIKit
 
class UIVC_WriteOrder:  MyViewController,ServiceHelperDelegate,NSXMLParserDelegate, UITableViewDataSource, SelectAddressDelegate,UITableViewDelegate{
    
    var helper  = ServiceHelper()
    
    @IBOutlet weak var total_price: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var addressList = Array<AddressList>()
    var cartData = Array<CartData>()
    var selectAddressId = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
        
        println("cartData.count=\(cartData.count)")
        
        var total_price_money:Float = 0.0
        for var i = 0; i < cartData.count; i++
        {
            total_price_money += ((cartData[i].price as NSString).floatValue * (cartData[i].number as NSString).floatValue)
            
        }
        
        total_price.text = "共\(cartData.count)件商品，合计￥\(total_price_money)"
    
        request_get_addressList()
        
        
    }
    
    @IBAction func handle_select_address(sender: AnyObject) {
        
        self.performSegueWithIdentifier("selece_address_segue", sender: self)
        
    }
    
    
    @IBAction func createOrder(sender: AnyObject) {
        
         if  addressList.count <= 0
         {
            showAlert("收货人列表为空，请先添加！")
            return
        }
        if  cartData.count <= 0
        {
            showAlert("出错，商品列表为空！")
            return
        }
        
        Request_create_order()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3+cartData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            var goods_count =  cartData.count
            if (indexPath.row == 0)
            {
                return  78
            }
//            if (indexPath.row == 1 )
//            {
//                return 44
//            }
            
            if(indexPath.row <= goods_count)
            {
                
                return 80
            }
            
            
            if (indexPath.row == goods_count+1)
            {
                return 55
            }
            if (indexPath.row == goods_count+2)
            {
                return 44
            }
           
                
        }
        
        return 80.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var  cell:UITableViewCell?
        
        println("indexPath=\(indexPath)")
        
        if(indexPath.section == 0)
        {
            
            var goods_count =  cartData.count
            if (indexPath.row == 0)
            {
                let identify :String = "PlaceOrderCellIdentifierOne"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
                
                
                if addressList.count > 0
                {
                    if selectAddressId.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0
                    {
                    
                    
                    var label_name = cell?.viewWithTag(261) as UILabel
                    label_name.text  = addressList[0].UserName
                
                    var label_mobile = cell?.viewWithTag(262) as UILabel
                    label_mobile.text  = addressList[0].MobilePhone
                
                    var label_address = cell?.viewWithTag(263) as UILabel
                    label_address.text  = addressList[0].Address
                    }
                    else
                    {
                        var find_flag = false
                        for var i=0; i < addressList.count; i++
                        {
                            if addressList[i].AddressID == selectAddressId
                            {
                                
                                var label_name = cell?.viewWithTag(261) as UILabel
                                label_name.text  = addressList[i].UserName
                                
                                var label_mobile = cell?.viewWithTag(262) as UILabel
                                label_mobile.text  = addressList[i].MobilePhone
                                
                                var label_address = cell?.viewWithTag(263) as UILabel
                                label_address.text  = addressList[i].Address
                                
                                find_flag = true
                                break
                            }
                        }
                        
                        if find_flag == false
                        {
                            var label_name = cell?.viewWithTag(261) as UILabel
                            label_name.text  = addressList[0].UserName
                            
                            var label_mobile = cell?.viewWithTag(262) as UILabel
                            label_mobile.text  = addressList[0].MobilePhone
                            
                            var label_address = cell?.viewWithTag(263) as UILabel
                            label_address.text  = addressList[0].Address
                        }
                    }
                }
                else
                {
                    
                    var label_address = cell?.viewWithTag(263) as UILabel
                    label_address.text  = "收货人为空，请先点击此处新增收货人"
                }
            }
            else if(indexPath.row <= goods_count)
            {
                let identify :String = "PlaceOrderCellIdentifierThree"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
                
                var cartData_temp = cartData[indexPath.row-1]
                
                
                var UIIV_goods_image = cell?.viewWithTag(265) as UIImageView
                //label_name.text  = addressList[0].UserName
                
                let URL = NSURL(string: "\(URL_IMAGE_BASE)\(cartData_temp.imageUrl)")!
                UIIV_goods_image.hnk_setImageFromURL(URL)
                
                
                
                var label_goods_name = cell?.viewWithTag(266) as UILabel
                label_goods_name.text  = cartData_temp.name
                
                var label_price = cell?.viewWithTag(267) as UILabel
                label_price.text  = "￥\(cartData_temp.price)"
                
                var label_spec = cell?.viewWithTag(268) as UILabel
                label_spec.text  = "\(cartData_temp.size),\(cartData_temp.color)"
                
                var label_quantity = cell?.viewWithTag(269) as UILabel
                label_quantity.text  = "x\(cartData_temp.number)"
            }
            else if (indexPath.row == goods_count+1)
            {
                let identify :String = "PlaceOrderCellIdentifierFour"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
            }
            else if (indexPath.row == goods_count+2)
            {
                let identify :String = "PlaceOrderCellIdentifierFive"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
            }
            else
            {
                let identify :String = "PlaceOrderCellIdentifierFive"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
            }
        }
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    var call_action = 0
    
    
    func  Request_create_order()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        
        
        
        
    /*

        
        for (int i = 0; i < buycarList.size(); i++)
        {
        BuycarGoods goods_temp = new BuycarGoods();
        goods_temp = buycarList.get(i);
        
        // 以下, 折扣,颜色,大小,型号为假数据
        goods_str += "<article GoodID=\"" + goods_temp.getID() + "\" ProductID=\"" + goods_temp.getID() + "\" Price=\"" + goods_temp.getPrice() + "\" Quantity=\""
        + goods_temp.getNumber() + "\"/>";
        }
        
        String send_str = "<?xml version=\"1.0\" encoding=\"GBK\"?><mobil_resp>" + "<UserID>" + User.UserID + "</UserID>"
        + "<AddressID>"+receive_address_id+"</AddressID>"
        + "<NeedInvoice>1</NeedInvoice>" + ((remark_temp.length() > 0) ? ("<Remark>" + remark_temp + "</Remark>") : ("")) + "<articlelist>" + goods_str
        + "</articlelist>"
        
        + "<hash>" + Des.encryptStr(random_, getDesKey()) + "</hash>" + "</mobil_resp>";
        
        var objxml  = "<mobil_resp><parameters><UserId>\(103)</UserId></parameters><hash>\(checktxt)</hash></mobil_resp>"
*/
        
        
        
        
        
        var goods_str = ""
        
        for var i = 0; i < cartData.count; i++
        {
            goods_str += "<article GoodID=\"\(cartData[i].ID)\" ProductID=\"\(cartData[i].ID)\" Price=\"\(cartData[i].price)\" Quantity=\"\(cartData[i].number)\"/>"
        }
        var objxml = "<mobil_resp><UserID>\(103)</UserID><AddressID>\(addressList[0].AddressID)</AddressID><NeedInvoice>1</NeedInvoice><articlelist>\(goods_str)</articlelist><hash>\(checktxt)</hash></mobil_resp>"
        
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_SaveCartOrder")
        
        
        create_order_success = false
        call_action = 2
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_SaveCartOrder", soapMessage: soapMsg)
    }

    func parserDidEndDocument(parser: NSXMLParser!) {
        if call_action  == 1
        {
            tableView.reloadData()
        }
        if call_action  == 2
        {
            showAlert("订单生成成功，请您尽快完成支付！")
        }
        
        call_action = 0
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
                var value:String = attributeDict["success"] as String
                if value == "Y"
                {
                    create_order_success = true
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
    
    func changeWord(controller:UIVC_SelectAddress,addressData:AddressList)
    {
        
        selectAddressId = addressData.AddressID
        
        request_get_addressList()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selece_address_segue"
        {
            var vc = segue.destinationViewController as UIVC_SelectAddress
            
            
            for var i=0; i < addressList.count; i++
            {
                if addressList[i].AddressID == selectAddressId
                {
                    
                    
                    vc.select_address = i
                    break
                }
            }

            
            vc.delegate = self
        }
    }
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
       // tableView.reloadData()
    }
    
}
