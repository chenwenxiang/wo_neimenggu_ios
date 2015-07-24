//
//  SecondViewController.swift
//  TextTabbar
//
//  Created by q on 15/1/11.
//  Copyright (c) 2015年 q. All rights reserved.
//

import UIKit

class TabCategoryViewController: UIViewController, ServiceHelperDelegate,NSXMLParserDelegate,MultiTablesViewDataSource, MultiTablesViewDelegate {
 
    @IBOutlet weak var rootMultiTablesView: MultiTablesView!
    var helper  = ServiceHelper()
    
    
    var categoryOneList = Array<CategoryOneList>()
    var categoryTwoList = Array<CategoryOneList>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        helper = ServiceHelper(delegate: self)
        
        request_getFirseClass()
    }


    
    /////////////   配置 MultiTablesViewDataSource        /////////////
    
    func numberOfLevelsInMultiTablesView(multiTablesView: MultiTablesView!) -> Int {
        return 2
    }
    
    func multiTablesView(multiTablesView: MultiTablesView!, numberOfSectionsAtLevel level: Int) -> Int {
        return 1
    }
    
//    func multiTablesView(multiTablesView: MultiTablesView!, level: Int, titleForHeaderInSection section: Int) -> String! {
//        return "{\(section), \(level)}"
//    }
    
    func multiTablesView(multiTablesView: MultiTablesView!, level: Int, titleForFooterInSection section: Int) -> String! {
        
        return nil
    }
    
    
    func multiTablesView(multiTablesView: MultiTablesView!, level: Int, numberOfRowsInSection section: Int) -> Int {
        
        if(level == 0)
        {
            return categoryOneList.count
        }
        else
        {
            return categoryTwoList.count
        }
        
//        println("level * section + 5=\(level * section + 5)")
//        return level * section + 5
    }

    var first_select = 0
    var select_row = 0
    
    func multiTablesView(multiTablesView: MultiTablesView!, level: Int, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var  CellIdentifier = "Cell"
        
        var cell = multiTablesView.dequeueReusableCellForLevel(level, withIdentifier: CellIdentifier)
        
        
        if(cell == nil)
        {
            cell = UITableViewCell()
        }
        
        if(level == 0)
        {
            cell.textLabel?.text = categoryOneList[indexPath.row].ClassNmae
        }
            
        else if(level == 1)
        {
            cell.textLabel?.text = categoryTwoList[indexPath.row].ClassNmae
        }
        
        return cell
    }
    
    func multiTablesView(multiTablesView: MultiTablesView!, level: Int, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    func multiTablesView(multiTablesView: MultiTablesView!, level: Int, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
         println("TabCategoryViewController didSelectRowAtIndexPath,level=\(level), indexPath=\(indexPath.item)")
        
        println("level=\(level)")
        
        if( level == 0)
        {
            categoryTwoList = Array<CategoryOneList>()
            first_select = indexPath.item
            request_getSecondClass()
        }
        else if( level == 1)
        {
            select_row = indexPath.row
            
            println("select_row=\(select_row)")
            var uivc_searchlist = UIVC_SearchGoodsByClass()
            self.performSegueWithIdentifier("category_goods_list", sender: self)
        }
    }
    
    func multiTablesView(multiTablesView: MultiTablesView!, level: Int, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
//    func multiTablesView(multiTablesView: MultiTablesView!, fixedTableHeaderViewAtLevel level: Int) -> UIView!
//    {
//        var screen_r = UIScreen.mainScreen().applicationFrame
//        var fixedTableHeaderView =  UILabel(frame: CGRect(x: 0, y:0, width: screen_r.width, height:22))
//        
//        fixedTableHeaderView.backgroundColor = UIColor.redColor()
//        fixedTableHeaderView.text = "Level \(level)"
//        
//        return fixedTableHeaderView
//    }
    var which_request = 0
    
    
    func request_getFirseClass()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        var objxml  = "<mobil_resp><parameters></parameters><hash>\(checktxt)</hash></mobil_resp>"
        
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_GetGoodBigClass")
        
        which_request = 1
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_GetGoodBigClass", soapMessage: soapMsg)
    }
    
    
    
    func  request_getSecondClass()
    {
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        
        var objxml  = "<mobil_resp><parameters><ParentId>\(categoryOneList[first_select].ClassID)</ParentId><FunctionID>1</FunctionID></parameters><hash>\(checktxt)</hash></mobil_resp>"
        
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
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: "WSQuery_GetGoodChildClass")
        
        which_request = 2
        
        //  AppHelper.showHUD("加载中...")
        helper.asynServiceMethod("WSQuery_GetGoodChildClass", soapMessage: soapMsg)
    }

    
    func parserDidEndDocument(parser: NSXMLParser!)
    {
        if which_request == 1
        {
        
            rootMultiTablesView.reloadData()
        }
        else         if which_request == 2
        {
            
            rootMultiTablesView.reloadDataCurrent(1)
        }
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        if which_request == 1
        {
        
            if elementName == "article"
            {
            var data_item = CategoryOneList()
            var value = attributeDict["ClassID"]
            data_item.ClassID = "\(value!)"
            
            value = attributeDict["ClassNmae"]
            data_item.ClassNmae = "\(value!)"
            

            categoryOneList.append(data_item)
            }
        }
        else if which_request == 2
        {
            
            if elementName == "article"
            {
                var data_item = CategoryOneList()
                var value = attributeDict["ClassID"]
                data_item.ClassID = "\(value!)"
                
                value = attributeDict["ClassNmae"]
                data_item.ClassNmae = "\(value!)"
                
                
                categoryTwoList.append(data_item)
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

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "category_goods_list"
        {
            var vc = segue.destinationViewController as UIVC_SearchGoodsByClass
            
            vc.categore_key = categoryTwoList[select_row].ClassID
            //vc.call_type = WS_SearchGoodByKeyword
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

