//
//  UIVC_SearchList.swift
//  TextTabbar
//
//  Created by q on 15/1/21.
//  Copyright (c) 2015年 q. All rights reserved.
//

import UIKit



class UIVC_SearchList: UIViewController,ServiceHelperDelegate, NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate{
    
    //调用接口的类型，此界面是重复利用界面，所以需要指定调用方式

    
    let WS_MoreMzq =  0
    let WS_Query_MoreSecKill = 1
    let WS_SearchGoodByClass = 2
    
    var call_type = 0
    
    var WebServiceFunctions =
    [
        "WSQuery_MoreMzq",
        "WSQuery_MoreSecKill",
    ];
    
    
    var goodsDataList = Array<SearchListItem>()
    
    var show_num = 13
    var search_keyword = ""

    @IBOutlet weak var tableView: UITableView!
    var helper  = ServiceHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
        
        call_server()
        
        
    }
    
    
    
    
    
    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return goodsDataList.count
    }
    
    // Display the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        // Must use 'self' here because searchResultsTableView needs to reuse the same cell in self.tableView
        let cell = self.tableView.dequeueReusableCellWithIdentifier("todoCell") as UITableViewCell
        
        
        var title = cell.viewWithTag(102) as UILabel
        title.text = goodsDataList[indexPath.row].productName
        
        
        var price = cell.viewWithTag(101) as UILabel
        price.text = "￥\(goodsDataList[indexPath.row].currentPrice)"
        
        var imagevvv = cell.viewWithTag(100) as UIImageView
        
        let URL = NSURL(string: "http://116.113.88.50\(goodsDataList[indexPath.row].productImgUrl)")!
        imagevvv.hnk_setImageFromURL(URL)
        
        return cell
    }
    
    var goodsInfoId:String?
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        goodsInfoId = goodsDataList[indexPath.row].productID
        //        var uivc_searchlist = UIVC_GoodsIntroduction()
        //        uivc_searchlist.navigationController
        self.performSegueWithIdentifier("GoodsIntroSearchWordList", sender: self)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let serverUrl = "http://116.113.88.50:81/PosWebService.ASMX";
 

    
    func  call_server()
    {
        
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        var call_action = WebServiceFunctions[0]
        if call_type > 0 || call_type < WebServiceFunctions.count
        {
            call_action = WebServiceFunctions[call_type]

        }
        

        
        println("=======异步请求开始======\n")
        
        println("民族情＝checktxt=\(checktxt)")
        
        var arr = NSMutableArray()
        
        
        
        
        var dictionary = NSDictionary(object: "aabbccddee", forKey: "checktxt")
        arr.addObject(dictionary)
        var dictionary2 = NSDictionary(object: checktxt, forKey: "HashValue")
        arr.addObject(dictionary2)
        var dictionary3 = NSDictionary(object: "1", forKey: "Page")
        arr.addObject(dictionary3)
        var dictionary4 = NSDictionary(object: "20", forKey: "MaxPerPage")
        arr.addObject(dictionary4)
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: call_action)
        
        
        
        //AppHelper.showHUD("加载中...")
        helper.asynServiceMethod(call_action, soapMessage: soapMsg)
        
        
        
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        self.tableView.reloadData()
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
        if elementName == "article"
        {
            var data_item = SearchListItem()
            var value = attributeDict["ProductID"]
            data_item.productID = "\(value!)"
            
            value = attributeDict["ProductName"]
            data_item.productName = "\(value!)"
            
            value = attributeDict["ProductImgUrl"]
            data_item.productImgUrl = "\(value!)"
            value = attributeDict["Inputer"]
            data_item.inputer = "\(value!)"
            value = attributeDict["CurrentPrice"]
            data_item.currentPrice = "\(value!)"
            
            
            
            goodsDataList.append(data_item)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoodsIntroSearchWordList"
        {
            var vc = segue.destinationViewController as UIVC_GoodsIntroduction
            
            vc.productId = goodsInfoId
        }
    }
    
    
    
  
    
    func finishFailRequest(error: NSError!) {
        println("异步请发生失败:\(error.description)\n")
        
    }
    
    func finishSuccessRequest(xml: String!) {
        
        
        
        
        
        
        println("异步请求返回民族情xml:\n\(xml)\n")
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
        tableView.reloadData()
    }
}
