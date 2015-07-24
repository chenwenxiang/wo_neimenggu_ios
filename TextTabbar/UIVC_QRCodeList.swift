//
//  UIVC_QRCodeList.swift
//  TextTabbar
//
//  Created by q on 15/7/11.
//  Copyright (c) 2015年 q. All rights reserved.
//





import UIKit
import Foundation
import AVFoundation



var scanDataList = NSMutableArray()

class UIVC_QRCodeList: MyViewController,ServiceHelperDelegate,UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate
{
    var helper  = ServiceHelper()
    var QRCode_Str :String?
    
    
    
    var exit_for_QRScan_agian = false
    var qRGoodsinfo:QRCodeGoodsInfo?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        scanDataList.removeAllObjects()
        
        helper = ServiceHelper(delegate: self)
        self.Quest_getGoodsInfo_server()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        exit_for_QRScan_agian = false
    }
    
    @IBAction func handle_scanQR_again(sender: AnyObject)
    {
        exit_for_QRScan_agian = true
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scanDataList.count
    }
    
    // Display the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        // Must use 'self' here because searchResultsTableView needs to reuse the same cell in self.tableView
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Segue_ScanData") as UITableViewCell
        
        
//        var title = cell.viewWithTag(102) as UILabel
//        title.text = goodsDataList[indexPath.row].productName
//        
    
        
        return cell
    }

    
    
    
    func  Quest_getGoodsInfo_server()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        println("=======异步请求开始======\n")
        
        var arr = NSMutableArray()
        
        var dictionary = NSDictionary(object: checktxt, forKey: "HashValue")
        arr.addObject(dictionary)
        
        var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
        arr.addObject(dictionary_2)
        
        var dictionary_3 = NSDictionary(object: QRCode_Str!, forKey: "sXML")
        arr.addObject(dictionary_3)

        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_GetSPXX_XML2")
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_GetSPXX_XML2", soapMessage: soapMsg)
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser!)
    {
        if success == "N"
        {
            showAlert(prompt)
        }
        else if success == "Y"
        {
            var alertView = UIAlertView()
            alertView.title = ""
            alertView.message = "添加成功！"
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
            println("buttonIndex == alertView.cancelButtonIndex")
            
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!)
    {
        
        println(elementName)

        if elementName == "article"
        {
            
            qRGoodsinfo = QRCodeGoodsInfo()
            
            var value: AnyObject? = attributeDict["SP_ID"]
            qRGoodsinfo?.SP_ID = "\(value!)"
            
            value = attributeDict["DEPTID"]
            qRGoodsinfo?.DEPTID = "\(value!)"
            
            value = attributeDict["BMMC"]
            qRGoodsinfo?.BMMC = "\(value!)"
            
            value = attributeDict["SPCODE"]
            qRGoodsinfo?.SPCODE = "\(value!)"
            
            value = attributeDict["NAME"]
            qRGoodsinfo?.NAME = "\(value!)"
            
            value = attributeDict["LSDJ"]
            qRGoodsinfo?.LSDJ = "\(value!)"
            
            value = attributeDict["SPFL"]
            qRGoodsinfo?.SPFL = "\(value!)"
            
            value = attributeDict["FLMC"]
            qRGoodsinfo?.FLMC = "\(value!)"
            
            value = attributeDict["SBMC"]
            qRGoodsinfo?.SBMC = "\(value!)"
            
            value = attributeDict["GHDW"]
            qRGoodsinfo?.GHDW = "\(value!)"
            
            value = attributeDict["GHDWMC"]
            qRGoodsinfo?.GHDWMC = "\(value!)"
            
            value = attributeDict["SPGG"]
            qRGoodsinfo?.SPGG = "\(value!)"
            
            value = attributeDict["HYLSDJ"]
            qRGoodsinfo?.HYLSDJ = "\(value!)"
            
            value = attributeDict["SB"]
            qRGoodsinfo?.SB = "\(value!)"
            
            value = attributeDict["ZKDBH"]
            qRGoodsinfo?.ZKDBH = "\(value!)"
            
            value = attributeDict["ZKL"]
            qRGoodsinfo?.ZKL = "\(value!)"
            
            value = attributeDict["ZKJE"]
            qRGoodsinfo?.ZKJE = "\(value!)"
            
            value = attributeDict["YT"]
            qRGoodsinfo?.YT = "\(value!)"
            
            
            scanDataList.addObject(qRGoodsinfo!)
            
            self.tableView.reloadData()
        }
    }
    
    func finishFailRequest(error: NSError!)
    {
        println("异步请发生失败:\(error.description)\n")
    }
    
    func finishSuccessRequest(xml: String!)
    {
        println("异步请求返回867xml:\n\(xml)\n")
        println("=======异步请求结束======\n")

        var getxml = xml.stringByReplacingOccurrencesOfString("<?xml version=\"1.0\" encoding=\"GBK\"?>", withString: "<?xml version=\"1.0\" encoding=\"utf-8\"?>", options: nil, range: nil)
        
        var data = getxml.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        var parser = NSXMLParser(data: data)
        parser.delegate = self
        
        var parse_sc =  parser.parse()
    }
    
    func finishQueueComplete()
    {
        println("=====所有队列请求完成=====\n")
    }
    
    func finishSingleRequestSuccess(xml: String!, userInfo dic: [NSObject : AnyObject]!)
    {
        var name = dic.description
        
        println("队列,请求完成\n")
        println("队列返回的xml为\n\(name)\n")
    }
    
    func finishSingleRequestFailed(error: NSError!, userInfo dic: [NSObject : AnyObject]!)
    {
        var name = dic.description
        
        println("队列,请求失败\n")
        println("队列请求失败：\n\(name)\n")
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var vc = segue.destinationViewController as UIVC_QRCode
        vc.return_mode = 1
        
        if exit_for_QRScan_agian == false
        {
            vc.return_mode = 100
        }
    }
    
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }
    
    
}

