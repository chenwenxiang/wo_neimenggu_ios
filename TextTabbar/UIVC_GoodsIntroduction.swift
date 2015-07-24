//
//  UIVC_GoodsIntroduction.swift
//  TextTabbar
//
//  Created by q on 15/2/5.
//  Copyright (c) 2015年 q. All rights reserved.
//


import UIKit

class UIVC_GoodsIntroduction:  MyViewController,ServiceHelperDelegate,UITableViewDataSource, NSXMLParserDelegate,UITableViewDelegate, UIPageViewControllerDelegate, UIScrollViewDelegate{
    
   
    @IBOutlet weak var tab_goods_base: UIButton!
    
    @IBOutlet weak var tab_goods_detail: UIButton!
    
    
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var db:SQLiteDB!
    var productId: String?
    
    var helper  = ServiceHelper()
    var goodDetail :GoodsDetail?
    
    
    var screen_r = UIScreen.mainScreen().applicationFrame
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if productId?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) > 0
        {
            
            helper = ServiceHelper(delegate: self)
            getAddressList_server()
        }
    }
    
    @IBAction func button_add_to_cart(sender: AnyObject) {
        
        
        var cartData_temp = CartData()
        
        var date:NSDate = NSDate()
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        var dateString = formatter.stringFromDate(date)
        println(dateString)
        
        //获取数据库实例
        db = SQLiteDB.sharedInstance()
        //如果表还不存在则创建表
        db.execute("create table if not exists t_cartdata(ID VARCHAR,choose VARCHAR,name VARCHAR,price VARCHAR,old_price VARCHAR,number VARCHAR,imageUrl VARCHAR,time VARCHAR,color VARCHAR,size VARCHAR,cartId VARCHAR)")

        
        
        
        
//        buycar.setColor(spec1_select);
//        buycar.setSize(spec2_select);
        cartData_temp.ID = goodDetail!.productID
        cartData_temp.name = goodDetail!.productName
        cartData_temp.price = goodDetail!.currentPrice
        cartData_temp.oldprice = goodDetail!.standPrice
        cartData_temp.time = dateString
        cartData_temp.discmoney = goodDetail!.productName
        cartData_temp.number = "1"
        cartData_temp.imageUrl = goodDetail!.productImgUrl
        
        var saveData = SaveData()
        
        if saveData.add_goods_to_database(cartData_temp) == true
        {
            showAlert("加入购物车成功！")
        }
        
//        
//        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
//        let sql = "insert into t_cartdata(ID,choose,name,price,old_price,number,imageUrl,time,color,size,cartId) values('\(db.esc(cartData_temp.ID))','\(db.esc(cartData_temp.choose))','\(db.esc(cartData_temp.name))','\(db.esc(cartData_temp.price))','\(db.esc(cartData_temp.oldprice))','\(db.esc(cartData_temp.number))','\(db.esc(cartData_temp.imageUrl))','\(db.esc(cartData_temp.time))','\(db.esc(cartData_temp.color))','\(db.esc(cartData_temp.size))','\(db.esc(cartData_temp.time))')"
//        println("sql: \(sql)")
//        //通过封装的方法执行sql
//        let result = db.execute(sql)
//        println("result.successor()=\(result)")

    }
    
    @IBAction func button_buy_now(sender: AnyObject) {
        self.performSegueWithIdentifier("now_buy_segue", sender: self)
    }
    
    
    @IBAction func selectGoodsBase(sender: AnyObject) {

        tableView.hidden = false
        webview.hidden = true
        tableView.reloadData()
        
        tab_goods_base.backgroundColor = DEFAULT_COLOR
        tab_goods_base.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        tab_goods_detail.backgroundColor = UIColor.whiteColor()
        tab_goods_detail.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)

    }
    
    @IBAction func selectGoodsDetail(sender: AnyObject) {
        tableView.hidden = true
        webview.hidden = false
        tab_goods_detail.backgroundColor = DEFAULT_COLOR
        tab_goods_detail.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        tab_goods_base.backgroundColor = UIColor.whiteColor()
        tab_goods_base.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }
    
    func  getAddressList_server()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        
        var objxml  = "<mobil_resp><parameters><ProductId>\(productId!)</ProductId></parameters><hash>\(checktxt)</hash></mobil_resp>"
        
        
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_GetGoodInfo")
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_GetGoodInfo", soapMessage: soapMsg)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                return  186.0
            }
            
            
            if (indexPath.row == 1 )
            {
                return 151.0
            }
            
            if (indexPath.row == 2)
            {
                
                return 239.0
            }
            
            if (indexPath.row == 3)
            {
                
                return 239.0
            }
            if (indexPath.row == 4)
            {
                
                return 270.0
            }
        }
        
        return 80.0
    }
    
    
    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if goodDetail == nil || goodDetail!.productID.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) <= 0
        {
            return 0
        }
        else if tableView.hidden == true
        {
            println("tableView.hidden == false")
            
            return 0
        }
        else
        {
        
            return 4
        }
    }
    
    // Display the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var  cell:UITableViewCell?
        
        println("indexPath=\(indexPath)")
        
        if(indexPath.section == 0)
        {
            
            if (indexPath.row == 0)
            {
                let identify :String = "ProductDetailVcCellIdentifierOne"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
                
                var imagevvv = cell?.viewWithTag(180) as UIImageView
                
                let URL = NSURL(string: "http://116.113.88.50\(goodDetail!.productImgUrl)")!
                imagevvv.hnk_setImageFromURL(URL)
            }
            else if (indexPath.row == 1)
            {
                let identify :String = "ProductDetailVcCellIdentifierTwo"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
                
                var label_goods_name = cell?.viewWithTag(181) as UILabel
                label_goods_name.text = goodDetail!.productName
                
                var label_goods_inputer = cell?.viewWithTag(182) as UILabel
                label_goods_inputer.text  = "品牌：\(goodDetail!.inputer)"
                
                var label_goods_stock = cell?.viewWithTag(186) as UILabel
                label_goods_stock.text  = "库存：\(goodDetail!.stock)"
                
                var label_goods_price = cell?.viewWithTag(183) as UILabel
                label_goods_price.text  = goodDetail!.currentPrice
                
                var label_goods_standprice = cell?.viewWithTag(1183) as UILabel
                label_goods_standprice.text  = goodDetail!.standPrice

            }
            else if (indexPath.row == 2)
            {
                let identify :String = "ProductDetailVcCellIdentifierTen"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
            }
            else
            {
                let identify :String = "ProductDetailVcCellIdentifierTen"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
            }

        }
        
        return cell!
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        self.tableView.reloadData()
        
        if goodDetail!.productIntro.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
        {
            webview.loadHTMLString(goodDetail!.productIntro, baseURL: nil)
        }
        else
        {
            webview.loadHTMLString("<html>暂无内容</html>", baseURL: nil)
        }
        

    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
        println( "parser.description=\(parser.description)")
        println( "namespaceURI=\(namespaceURI)")
        println( "qName=\(qName)")
        println( "attributeDict=\(attributeDict.description)")

        
        if elementName == "article"
        {
            goodDetail = GoodsDetail()
            var value: AnyObject? = attributeDict["ProductID"]
            goodDetail?.productID = "\(value!)"
            
            value = attributeDict["ProductName"]
            goodDetail?.productName = "\(value!)"
            
            value = attributeDict["ProductImgUrl"]
            goodDetail?.productImgUrl = "\(value!)"
            
            value = attributeDict["Inputer"]
            goodDetail?.inputer = "\(value!)"
            
            value = attributeDict["CurrentPrice"]
            goodDetail?.currentPrice = "\(value!)"
            
            value = attributeDict["StandPrice"]
            goodDetail?.standPrice = "\(value!)"
            
            value = attributeDict["Stocks"]
            goodDetail?.stock = "\(value!)"
            
            value = attributeDict["Color"]
            goodDetail?.color = "\(value!)"
            
            value = attributeDict["Size"]
            goodDetail?.size = "\(value!)"
            
            value = attributeDict["ProductIntro"]
            goodDetail?.productIntro = "\(value!)"

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
    
    
    func segmentedControlChangedValue(segmentedControl:HMSegmentedControl)
    {
        println("segmentedControlChangedValue")
            if (segmentedControl.selectedIndex == 0) {
                
                tableView.reloadData()
                tableView.hidden = false
                webview.hidden = true
            }else if(segmentedControl.selectedIndex == 1){
                tableView.hidden = true
                webview.hidden = false
            }
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
        if segue.identifier == "now_buy_segue"
        {
            var vc = segue.destinationViewController as UIVC_WriteOrder
  
            
            var cartDataList_temp = Array<CartData>()
            
            var cartData_temp = CartData()
            cartData_temp.ID = goodDetail!.productID
            cartData_temp.name = goodDetail!.productName
            cartData_temp.price = goodDetail!.currentPrice
            cartData_temp.oldprice = goodDetail!.standPrice
            cartData_temp.discmoney = goodDetail!.productName
            cartData_temp.number = "1"
            cartData_temp.imageUrl = goodDetail!.productImgUrl
            
            cartDataList_temp.append(cartData_temp)
            
            vc.cartData = cartDataList_temp
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

class GoodsDetail 
{
    var productID = ""
    var productName = ""
    var productImgUrl = ""
    var inputer = ""
    var currentPrice = ""
    var standPrice = ""
    var stock = ""
    var color = ""
    var size = ""
    var productIntro = ""
}

