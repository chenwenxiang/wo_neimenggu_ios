

//

import UIKit

class UIVC_OrderDetail: UIViewController, ServiceHelperDelegate,NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate{

    
    @IBOutlet weak var order_goods_list: UITableView!
    var order_id:String?
    
    var goodsList = Array<OrderDetailGoodsList>()
    
 
    
    @IBOutlet weak var LABEL_OrderId: UILabel!
    
    @IBOutlet weak var LABEL_pay_price: UILabel!
    @IBOutlet weak var LABEL_goods_total_price: UILabel!
    var helper  = ServiceHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helper = ServiceHelper(delegate: self)
        
        Request_order_detail()
    }
 
    
    
    var show_num = 3
    
    
    // MARK - UITableViewDataSource
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goodsList.count
    }
    
    // Display the cell
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        // Must use 'self' here because searchResultsTableView needs to reuse the same cell in self.tableView
        let cell = self.order_goods_list.dequeueReusableCellWithIdentifier("order_goods_list") as UITableViewCell
        
        var goods_image = cell.viewWithTag(1001) as UIImageView
        //order_id.text = "订单编号：\(orderList[indexPath.row].OrderFormNum)"
        
        
        var goods_name = cell.viewWithTag(1002) as UILabel
        goods_name.text = "\(goodsList[indexPath.row].ProductName)"
        
        
        var goods_spec = cell.viewWithTag(1003) as UILabel
        //goods_spec.text = "\(goodsList[indexPath.row].Size),\(goodsList[indexPath.row].Color)"
        
        var goods_price = cell.viewWithTag(1004) as UILabel
        goods_price.text = "￥\(goodsList[indexPath.row].Price)"
        
        var goods_num = cell.viewWithTag(1005) as UILabel
        goods_num.text = "￥\(goodsList[indexPath.row].Quantity)"
        
        return cell
    }
    
    
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
//        
//        var uivc_searchlist = UIVC_OrderDetail()
//        uivc_searchlist.navigationController
//        
//        self.performSegueWithIdentifier("orderDetail", sender: self)
        
    }

    
    
    
    
    func  Request_order_detail()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        var objxml = "<mobil_resp><parameters> <OrderID>\(order_id!)</OrderID></parameters><hash>\(checktxt)</hash></mobil_resp>"
      
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_GetOrder")
        
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_GetOrder", soapMessage: soapMsg)
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
      
        
        
        
        var total_price_money:Float = 0.0
        for var i = 0; i < goodsList.count; i++
        {
            total_price_money += ((goodsList[i].Price as NSString).floatValue * (goodsList[i].Quantity as NSString).floatValue)
            
        } 

        
        LABEL_pay_price.text = "￥\(total_price_money)"
        LABEL_goods_total_price.text = "￥\(total_price_money)"
        
        if goodsList.count > 0
        {
            LABEL_OrderId.text = "订单号：\(goodsList[0].OrderFormNum)"
        }
        
       order_goods_list.reloadData()
    }
    
    var create_order_success = false
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
        
        if elementName == "article"
        {
            var addressTemp = OrderDetailGoodsList()

            var value: AnyObject? = attributeDict["OrderFormID"]
            addressTemp.OrderFormID = "\(value!)"
            
            value = attributeDict["OrderFormNum"]
            addressTemp.OrderFormNum = "\(value!)"
            
            value = attributeDict["ProductID"]
            addressTemp.ProductID = "\(value!)"
            
            value = attributeDict["ProductName"]
            addressTemp.ProductName = "\(value!)"
            
            value = attributeDict["Quantity"]
            addressTemp.Quantity = "\(value!)"
            
            value = attributeDict["Price"]
            addressTemp.Price = "\(value!)"
            
            value = attributeDict["totalPrice"]
            addressTemp.totalPrice = "\(value!)"
            
            value = attributeDict["totalDisscount"]
            addressTemp.totalDisscount = "\(value!)"
            
            value = attributeDict["Color"]
            addressTemp.Color = "\(value!)"
            
            value = attributeDict["Size"]
            addressTemp.Size = "\(value!)"
            
            value = attributeDict["Yyydm"]
            addressTemp.Yyydm = "\(value!)"
            
            goodsList.append(addressTemp)
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }
}
 