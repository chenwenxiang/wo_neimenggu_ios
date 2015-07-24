//
//  UIVC_SearchList.swift
//  TextTabbar
//
//  Created by q on 15/1/21.
//  Copyright (c) 2015 q. All rights reserved.
//

import UIKit



class UIVC_SearchKeyword: UIViewController,ServiceHelperDelegate, UITableViewDataSource, NSXMLParserDelegate,UITableViewDelegate{
    
    //调用接口的类型，此界面是重复利用界面，所以需要指定调用方式
    //var call_type = WS_SearchGoodByKeyword
    
    let WS_SearchByKeyword =  0
    let WS_SearchGoodByCzg = 1
    let WS_SearchMoreCzg = 2
    
    var call_type = 0
    
    var WebServiceFunctions =
    [
        "WSQuery_SearchGoodByKeyword",
        "WSQuery_SearchGoodByCzg",
        "WSQuery_SearchMoreCzg",
    ];
    
    
    
    var helper  = ServiceHelper()
    var moreSuperValu = Array<MoreSuperValuList>()
    var goodsDataList = Array<SearchListItem>()
    
    
    
    var show_num = 13
    
    var search_keyword = ""
    var CzgID = ""  //获取超值购ＩＤ为这个的商品
    
    
    var des_key = "dtapp100"
    var random = "aaaaabbbbb"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = ServiceHelper(delegate: self)
        
        call_server()
    }
    
    
    
    
    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if call_type == WS_SearchMoreCzg
        {
            return moreSuperValu.count
        }else
        {
            return goodsDataList.count
            
        }
    }
    
    // Display the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var  cell:UITableViewCell?
        
        if call_type == WS_SearchMoreCzg
        {
            cell = self.tableView.dequeueReusableCellWithIdentifier("SuperValuCell") as UITableViewCell
            
            
            var title = cell!.viewWithTag(201) as UILabel
            title.text = moreSuperValu[indexPath.row].NAME
            
            
            var imagevvv = cell!.viewWithTag(202) as UIImageView
            
            let URL = NSURL(string: "http://116.113.88.50\(moreSuperValu[indexPath.row].ImageUrl)")!
            imagevvv.hnk_setImageFromURL(URL)
        }
        else
        {
            cell = self.tableView.dequeueReusableCellWithIdentifier("todoCell") as UITableViewCell
            
            
            
            var title = cell!.viewWithTag(102) as UILabel
            title.text = goodsDataList[indexPath.row].productName
            
            
            var price = cell!.viewWithTag(101) as UILabel
            price.text = "￥\(goodsDataList[indexPath.row].currentPrice)"
            
            var imagevvv = cell!.viewWithTag(100) as UIImageView
            
            let URL = NSURL(string: "http://116.113.88.50\(goodsDataList[indexPath.row].productImgUrl)")!
            imagevvv.hnk_setImageFromURL(URL)
        }
        
        
        return cell!
    }
    
    var goodsInfoId:String?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if call_type == WS_SearchMoreCzg
        {
            self.performSegueWithIdentifier("segue_keyword_goods_list", sender: self)

            call_type = WS_SearchGoodByCzg
            CzgID = moreSuperValu[indexPath.row].ID
            
        }
        else
        {
        
        goodsInfoId = goodsDataList[indexPath.row].productID
//        var uivc_searchlist = UIVC_GoodsIntroduction()
//        uivc_searchlist.navigationController
                self.performSegueWithIdentifier("GoodsIntroSearchWordList", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   // let serverUrl = "http://116.113.88.50:81/PosWebService.ASMX";
    //请求发送到的路径
    var action = ""
    
    func  call_server()
    {
        var call_action = WebServiceFunctions[0]
        if call_type > 0 || call_type < WebServiceFunctions.count
        {
            call_action = WebServiceFunctions[call_type]
        }
        
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        var add_str = ""
        if call_type == WS_SearchByKeyword
        {
            add_str = "<Keyword>\(search_keyword)</Keyword>"
        }
        if call_type == WS_SearchGoodByCzg
        {
            add_str = "<CzgID>\(CzgID)</CzgID>"
        }
        
        var objxml  = "<mobil_resp><parameters>\(add_str)<Page>1</Page><MaxPerPage>20</MaxPerPage><SortID>1</SortID><SaleNM>10</SaleNM><SaleType>1</SaleType></parameters><hash>\(checktxt)</hash></mobil_resp>"
        
        println("objxml=\(objxml)")
        println("checktxt=\(checktxt)")
        
        objxml = objxml.stringByReplacingOccurrencesOfString("<", withString: "&lt;", options: nil, range: nil)
        objxml = objxml.stringByReplacingOccurrencesOfString(">", withString: "&gt;", options: nil, range: nil)
        objxml = objxml.stringByReplacingOccurrencesOfString("\"", withString: "&quot;", options: nil, range: nil)
        

        
        println("=======异步请求开始======\n")
        
        var arr = NSMutableArray()
        
        var dictionary = NSDictionary(object: objxml, forKey: "objXml")
        
        arr.addObject(dictionary)
        
        var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
        arr.addObject(dictionary_2)
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: call_action)
        
      //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod(call_action, soapMessage: soapMsg)
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        self.tableView.reloadData()
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
        /*
<?xml version="1.0" encoding="GBK"?><mobil_resp success="Y" COUNT="3"><article_list>
        <article ID="1" NAME="民族情特产系列" ImageUrl="/UploadFile/ShopPic/201301/201301034921.jpg" />
        <article ID="2" NAME="中秋酒夜购" ImageUrl=" /UploadFile/ShopPic/201301/201301035744.jpg" /><article ID="3" NAME="圣诞狂欢" ImageUrl="/UploadFile/ShopPic/201301/201301033551.jpg" /></article_list></mobil_resp>
*/
        
        if call_type == WS_SearchMoreCzg
        {
            if elementName == "article"
            {
                var data_item = MoreSuperValuList()
                var value = attributeDict["ID"]
                data_item.ID = "\(value!)"
                
                value = attributeDict["NAME"]
                data_item.NAME = "\(value!)"
                
                value = attributeDict["ImageUrl"]
                data_item.ImageUrl = "\(value!)"
                 data_item.ImageUrl = data_item.ImageUrl.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " !"))
                
                
                moreSuperValu.append(data_item)
            }
        }
        else
        {
        
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
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoodsIntroSearchWordList"
        {
            var vc = segue.destinationViewController as UIVC_GoodsIntroduction
            vc.productId = goodsInfoId
        }
    }
    
    
    
  
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
        tableView.reloadData()
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
        var name = dic.description
        
        println("队列,请求完成\n")
        println("队列返回的xml为\n\(name)\n")
        
    }
    
    func finishSingleRequestFailed(error: NSError!, userInfo dic: [NSObject : AnyObject]!) {
        var name = dic.description
        
        println("队列,请求失败\n")
        println("队列请求失败：\n\(name)\n")
    }
}
