//
//  FirstViewController.swift
//  TextTabbar
//
//  Created by q on 15/1/11.
//  Copyright (c) 2015q. All rights reserved.
//

import UIKit


class TabHomeViewController: UIViewController,UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,NSXMLParserDelegate,ServiceHelperDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var screen_r = UIScreen.mainScreen().applicationFrame
    
    //var adsArr: NSMutableArray?
    
    var mainScrollView: CycleScrollView?
    
    var adList = Array<ADList>()
    var seckill_list = Array<MainWinData>()
    var superValu = Array<SuperValu>()
    var mobileSpecial = Array<MainWinData>()
    var themeList = Array<ThemeListItem>()
    
    
    var adddata: NSString?
    var img: NSString?
    var explain: NSString?
    var urlS: NSString?
    var startdate: NSString?
    var enddate: NSString?
    
    var call_count = 0
    var call_action = ["WSQuery","WSQuery_SecKill","WSQuery_SearchOverFlow","WSQuery_MobileExclusive","WSQuery_Theme"]
    
    var call_goods_list_type = -1
    
    var helper  = ServiceHelper()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        var vvv = userDefaults.stringForKey("UserID")
        println(vvv)
        if vvv != nil
        {
            userData.UserID = vvv!
            // println("userData?.UserID=\(userData.UserID )")
        }
        vvv = userDefaults.stringForKey("UserName")
        if vvv != nil
        {
            userData.UserName = vvv!
            
            //println("userData?.UserName=\(userData.UserName )")
        }
        vvv = userDefaults.stringForKey("Passwd")
        if vvv != nil
        {
            userData.passwd = vvv!
            //println("userData?.passwd=\(userData.passwd )")
        }
        
        
        
        self.tableView.rowHeight = 44.0
        
        helper = ServiceHelper(delegate: self)
        
        call_count = 0
        query_get_data()
        
    }
    
   
    
    func UIIV_handle_EthnicBuy(sender:AnyObject)
    {
        call_goods_list_type = 1
        self.performSegueWithIdentifier("search_list", sender: self)
    }
    func UIIV_handle_Seckill_list(sender:AnyObject)
    {
        
        call_goods_list_type = 2
        self.performSegueWithIdentifier("search_list", sender: self)
    }
    
    var superValue_select = -1//超值购有3个图片，0-2记录最近哪一个被点击了
    func UIIV_handle_SureValu_item(sender:AnyObject)
    {
        
        var sender_temp = sender as UITapGestureRecognizer

        if sender_temp.view?.tag == 2001
        {
              superValue_select = 1
        }
        else  if sender_temp.view?.tag == 2002
        {
            superValue_select = 2
        } else if sender_temp.view?.tag == 2003
        {
            superValue_select = 3
        }
        self.performSegueWithIdentifier("segue_keyword_goods_list", sender: self)
        //
        //        println("fffffffffff")
        //        call_goods_list_type = 2
        //        self.performSegueWithIdentifier("search_list", sender: self)
    }
    
    func UIIV_handle_More_SureValu(sender:AnyObject)
    {
        superValue_select = 0
        self.performSegueWithIdentifier("segue_keyword_goods_list", sender: self)
        
        
//        
//        println("fffffffffff")
//        call_goods_list_type = 2
//        self.performSegueWithIdentifier("search_list", sender: self)
    }
    
    
    @IBAction func handle_member_center(sender: AnyObject) {
        self.performSegueWithIdentifier("segue_member_center", sender: self)
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if(indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                return  211.0
            }
            
            
            if (indexPath.row == 1 || indexPath.row == 3)
            {
                return 190.0
            }
            
            if (indexPath.row == 2)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var  cell:UITableViewCell?
        
        println("indexPath=\(indexPath)")
        
        if(indexPath.section == 0)
        {
            
            if (indexPath.row == 0)
            {
                let identify :String = "MW_FourFunctonCell"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
                
                
                var imagevvv_4 =  cell!.viewWithTag(141) as UIImageView
             //   imagevvv_4.userInteractionEnabled = true;
                
                let singleTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "UIIV_handle_EthnicBuy:" )
                imagevvv_4.addGestureRecognizer(singleTap)
            }
            else if (indexPath.row == 1)
            {
                let identify :String = "MW_SecKillCell"
                cell = (tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell)
                
                
                var button_22 =  cell!.viewWithTag(1050) as UIButton
                //   imagevvv_4.userInteractionEnabled = true;
                
                let singleTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "UIIV_handle_Seckill_list:" )
                button_22.addGestureRecognizer(singleTap)
                
                
                var UIView_SecKill = cell!.viewWithTag(8339)! as UIView
                //var UIView_SecKill =  (cell!.viewWithTag(8339) as UIView)
                
                var seckill_count:Int = 3
                
                if seckill_list.count < 3
                {
                    seckill_count = seckill_list.count
                }
                
                var screen_width = self.screen_r.width
                
                for var i:Int = 0; i < seckill_count; i++
                {
                    
                    
                    //var UIView_temp = UIView(frame: CGRect(x: i*(screen_width/seckill_count), y: 0, width: 160.0, height: 100))
                    var one_view_width = Float(screen_width) / Float(seckill_count)
                    var xxx_temp:Int = (Int)(((Int)(i)) * (Int)(one_view_width))
                    var UIView_temp = UIView(frame: CGRect(x: xxx_temp, y: 0, width: Int(one_view_width), height: 100))
                    
                    
                    var UIIV_goods = UIImageView(frame: CGRect(x: xxx_temp, y: 0, width: Int(one_view_width), height: 100))
                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(seckill_list[i].ProductImgUrl)")!
                    UIIV_goods.hnk_setImageFromURL(URL)
                    
                    
                    UIView_temp.addSubview(UIIV_goods)
                }
                
                
                
                println(  "self.screen_r.width=\(self.screen_r.width))")
//
//                
//                if seckill_list.count > 0
//                {
//                    var imagevvv_1 = cell!.viewWithTag(1001) as UIImageView
//                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(seckill_list[0].ProductImgUrl)")!
//                    imagevvv_1.hnk_setImageFromURL(URL)
//              
//                    var lab_goodsname_1 = cell!.viewWithTag(1002) as UILabel
//                    lab_goodsname_1.text = seckill_list[0].ProductName
//                
//                    var lab_goodsprice_1 = cell!.viewWithTag(1003) as UILabel
//                    lab_goodsprice_1.text = seckill_list[0].CurrentPrice
//                
//                }
//                if seckill_list.count > 1
//                {
//                    var imagevvv_2 = cell!.viewWithTag(1011) as UIImageView
//                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(seckill_list[1].ProductImgUrl)")!
//                    imagevvv_2.hnk_setImageFromURL(URL)
//                
//                    var lab_goodsname_2 = cell!.viewWithTag(1012) as UILabel
//                    lab_goodsname_2.text = seckill_list[1].ProductName
//                
//                    var lab_goodsprice_2 = cell!.viewWithTag(1013) as UILabel
//                    lab_goodsprice_2.text = seckill_list[1].CurrentPrice
//                
//                }
//                
//                if seckill_list.count > 2
//                {
//                    var imagevvv_3 = cell!.viewWithTag(1021) as UIImageView
//                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(seckill_list[2].ProductImgUrl)")!
//                    imagevvv_3.hnk_setImageFromURL(URL)
//                
//                    var lab_goodsname_3 = cell!.viewWithTag(1022) as UILabel
//                    lab_goodsname_3.text = seckill_list[2].ProductName
//                
//                    var lab_goodsprice_3 = cell!.viewWithTag(1023) as UILabel
//                    lab_goodsprice_3.text = seckill_list[2].CurrentPrice
//                }
            }
            else if (indexPath.row == 2)
            {
                let identify :String = "MW_SuperValuCell"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
                
                
                
                
                var imagevvv_4 =  cell!.viewWithTag(2004) as UIButton
                //   imagevvv_4.userInteractionEnabled = true;
                
                let singleTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "UIIV_handle_More_SureValu:" )
                //singleTap.view?.tag = 2004
                imagevvv_4.addGestureRecognizer(singleTap)
                
                if superValu.count > 0
                {
                    var imagevvv_1 = cell!.viewWithTag(2001) as UIImageView
                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(superValu[0].ImageUrl)")!
                    
                    println(URL)
                    imagevvv_1.hnk_setImageFromURL(URL)
                    
                    
                    
                    
                    
                    superValue_select = 0
                    
                    let singleTap_1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "UIIV_handle_SureValu_item:" )
                  //  singleTap.view?.tag = 2001
                    imagevvv_1.addGestureRecognizer(singleTap_1)
                }
                if superValu.count > 1
                {
                    var imagevvv_2 = cell!.viewWithTag(2002) as UIImageView
                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(superValu[1].ImageUrl)")!
                    imagevvv_2.hnk_setImageFromURL(URL)
                    
                    
                    
                    superValue_select = 1
                    
                    let singleTap_2 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "UIIV_handle_SureValu_item:" )
                   // singleTap.view?.tag = 2002
                    imagevvv_2.addGestureRecognizer(singleTap_2)
                }
                
                if superValu.count > 2
                {
                    var imagevvv_3 = cell!.viewWithTag(2003) as UIImageView
                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(superValu[2].ImageUrl)")!
                    imagevvv_3.hnk_setImageFromURL(URL)
                    
                    
                    superValue_select = 2
                    
                    let singleTap_3 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "UIIV_handle_SureValu_item:" )
                  //  singleTap.view?.tag = 2003
                    imagevvv_3.addGestureRecognizer(singleTap_3)
                }
            }
            else if (indexPath.row == 3)
            {
                let identify :String = "MW_MobileExclusiveCell"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
                
                
                if seckill_list.count > 0
                {
                    var imagevvv_1 = cell!.viewWithTag(3000) as UIImageView
                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(seckill_list[0].ProductImgUrl)")!
                    imagevvv_1.hnk_setImageFromURL(URL)
                    
                    var lab_goodsname_1 = cell!.viewWithTag(3001) as UILabel
                    lab_goodsname_1.text = seckill_list[0].ProductName
                    
                    var lab_goodsprice_1 = cell!.viewWithTag(3002) as UILabel
                    lab_goodsprice_1.text = seckill_list[0].CurrentPrice
                    
                }
                if seckill_list.count > 1
                {
                    var imagevvv_2 = cell!.viewWithTag(3010) as UIImageView
                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(seckill_list[1].ProductImgUrl)")!
                    imagevvv_2.hnk_setImageFromURL(URL)
                    
                    var lab_goodsname_2 = cell!.viewWithTag(3011) as UILabel
                    lab_goodsname_2.text = seckill_list[1].ProductName
                    
                    var lab_goodsprice_2 = cell!.viewWithTag(3012) as UILabel
                    lab_goodsprice_2.text = seckill_list[1].CurrentPrice
                    
                }
                
                if seckill_list.count > 2
                {
                    var imagevvv_3 = cell!.viewWithTag(3020) as UIImageView
                    var URL = NSURL(string: "\(URL_IMAGE_BASE)\(seckill_list[2].ProductImgUrl)")!
                    imagevvv_3.hnk_setImageFromURL(URL)
                    
                    var lab_goodsname_3 = cell!.viewWithTag(3021) as UILabel
                    lab_goodsname_3.text = seckill_list[2].ProductName
                    
                    var lab_goodsprice_3 = cell!.viewWithTag(3022) as UILabel
                    lab_goodsprice_3.text = seckill_list[2].CurrentPrice
                }
            }
            else if (indexPath.row == 4)
            {
                let identify :String = "MW_ThemePovilionCell"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
            }
            else
            {
                let identify :String = "MW_ADCell"
                cell = tableView.dequeueReusableCellWithIdentifier(identify) as UITableViewCell
            }
        }
        
        return cell!
    }
    
    var segueUrlString:NSString?
    
    func pushToAdsDetail(pageIndex: Int)
    {
    }
    
    var viewsArray : NSMutableArray?
    var adsInt: NSInteger?
    
    func initAds()
    {
        
        var cgRect = CGRect(x: 0,y: 0,width: screen_r.width,height: 124)
        
        viewsArray = NSMutableArray(array: [])
        
//        var dataModel = AdDataModel.adDataModelWithImageNameAndAdTitleArray()
//        // 如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
//        
//        var dataModelArray = NSArray(array: dataModel.imageNameArray)
//        
        //println( dataModelArray );
        
        
        if adList.count <= 0
        {
            return
        }
        
        for var i=0; i<adList.count; ++i
        {
            
            var imageview = UIImageView(frame: cgRect)
            ///imageview.image = UIImage(named: dataModelArray.objectAtIndex(i) as NSString)
            
            
            
            //var imagevvv_1 = cell!.viewWithTag(3000) as UIImageView
            
            
            var URL = NSURL(string:  "\(URL_IMAGE_BASE)\(adList[i].imgUrl)")!
            imageview.hnk_setImageFromURL(URL)
            
           
            
            
            viewsArray?.addObject(imageview)
        }
        
        var headerView = UIView(frame: cgRect)
        
        
        self.mainScrollView = CycleScrollView(frame: cgRect, animationDuration: 5)
        self.mainScrollView?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
        
        
        func get_ad_index( ppp_index: NSInteger)->UIView{
            
            return viewsArray?.objectAtIndex(ppp_index) as UIView
        }
        
        self.mainScrollView?.fetchContentViewAtIndex = get_ad_index
        var adsInt = viewsArray?.count
        
        func get_ads_count()->NSInteger{
            
            return adsInt!
        }
        
        self.mainScrollView?.totalPagesCount = get_ads_count
        
        func push_to_ad_detail(pageIndex: NSInteger){
            self.pushToAdsDetail(pageIndex)
        }
        
        self.mainScrollView?.TapActionBlock = push_to_ad_detail
        
        headerView.addSubview(self.mainScrollView!)
        tableView.tableHeaderView = headerView
        tableView.reloadData()
    }
    
    
    
    
    func query_get_data()
    {
        
        
        if call_count >= call_action.count
        {
            
            return;
        }
        
        var action_str = call_action[call_count]
        
        var aFraction = Base64codeFunc()
        var checktxt = aFraction.encryptUseDES("aabbccddee", key: "dtapp100")
        var arr = NSMutableArray()
        
        //获取ＡＤ和其他的调用方式有点差别，需分开处理
        if call_count == 0
        {
            var objxml  = "<mobil_resp><parameters></parameters><hash>\(checktxt)</hash></mobil_resp>"
            
            objxml = objxml.stringByReplacingOccurrencesOfString("<", withString: "&lt;", options: nil, range: nil)
            objxml = objxml.stringByReplacingOccurrencesOfString(">", withString: "&gt;", options: nil, range: nil)
            objxml = objxml.stringByReplacingOccurrencesOfString("\"", withString: "&quot;", options: nil, range: nil)
            
            println("=======异步请求开始======\n")
            
            var dictionary = NSDictionary(object: objxml, forKey: "objXml")
            arr.addObject(dictionary)
            
            var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
            arr.addObject(dictionary_2)
            
        }
        else
        {
            
            var dictionary = NSDictionary(object: checktxt, forKey: "HashValue")
            arr.addObject(dictionary)
            var dictionary_2 = NSDictionary(object: "aabbccddee", forKey: "checktxt")
            arr.addObject(dictionary_2)
        }
        
        var soapMsg = SoapHelper.arrayToDefaultSoapMessage(arr, methodName: action_str)
        
        
        println("=======异步请求开始======\n")
        helper.asynServiceMethod(action_str, soapMessage: soapMsg)
        
    }
    
    
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
        
        if call_count == 0
        {
            initAds()
        }
        else if call_count == 1
        {
            
            self.tableView.reloadData()
        } else if call_count == 2
        {
            
            self.tableView.reloadData()
        }else if call_count == 3
        {
            
            
            self.tableView.reloadData()
        }
        else if call_count == 4
        {
            self.tableView.reloadData()
        }
        
        
        
        call_count++
        
        if call_count < call_action.count
        {
            query_get_data()
        }
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        println(elementName)
        
        
        if call_count == 0
        {
            if elementName == "article"
            {
                var data_item = ADList()
                var value = attributeDict["ADID"]
                data_item.ADID = "\(value!)"
                
                value = attributeDict["imgUrl"]
                data_item.imgUrl = "\(value!)"
                
                value = attributeDict["adName"]
                data_item.adName = "\(value!)"
                
                value = attributeDict["LinkUrl"]
                data_item.LinkUrl = "\(value!)"
                
                
                
                adList.append(data_item)
            }
        }
        else if call_count == 1
        {
            if elementName == "article"
            {
                var data_item = MainWinData()
                var value = attributeDict["ProductID"]
                data_item.ProductID = "\(value!)"
                
                value = attributeDict["ProductName"]
                data_item.ProductName = "\(value!)"
                
                value = attributeDict["ProductImgUrl"]
                data_item.ProductImgUrl = "\(value!)"
                
                value = attributeDict["Inputer"]
                data_item.Inputer = "\(value!)"
                
                value = attributeDict["CurrentPrice"]
                data_item.CurrentPrice = "\(value!)"
                
                value = attributeDict["BeginDate"]
                data_item.BeginDate = "\(value!)"
                
                value = attributeDict["EndDate"]
                data_item.EndDate = "\(value!)"
                
                value = attributeDict["SystemDate"]
                data_item.SystemDate = "\(value!)"
                
                
                seckill_list.append(data_item)
            }
        } else if call_count == 2
        {
            if elementName == "article"
            {
                var data_item = SuperValu()
                var value = attributeDict["ID"]
                data_item.ID = "\(value!)"
                
                value = attributeDict["NAME"]
                data_item.NAME = "\(value!)"
                
                value = attributeDict["ImageUrl"]
                data_item.ImageUrl = "\(value!)"
                data_item.ImageUrl =  data_item.ImageUrl.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
               
                superValu.append(data_item)
            }
        }else if call_count == 3
        {
            if elementName == "article"
            {
                var data_item = MainWinData()
                var value = attributeDict["ProductID"]
                data_item.ProductID = "\(value!)"
                
                value = attributeDict["ProductName"]
                data_item.ProductName = "\(value!)"
                
                value = attributeDict["ProductImgUrl"]
                data_item.ProductImgUrl = "\(value!)"
                
                value = attributeDict["Inputer"]
                data_item.Inputer = "\(value!)"
                
                value = attributeDict["CurrentPrice"]
                data_item.CurrentPrice = "\(value!)"
                
                value = attributeDict["BeginDate"]
                data_item.BeginDate = "\(value!)"
                
                value = attributeDict["EndDate"]
                data_item.EndDate = "\(value!)"
                
                value = attributeDict["SystemDate"]
                if value != nil
                {
                    data_item.SystemDate = "\(value!)"
                }
                
                
                mobileSpecial.append(data_item)
            }
        }
        else if call_count == 4
        {
            if elementName == "article"
            {
                var data_item = ThemeListItem()
                var value = attributeDict["ClassID"]
                data_item.ClassID = "\(value!)"
                
                value = attributeDict["ClassName"]
                data_item.ClassName = "\(value!)"
                
                value = attributeDict["SmallIntImageUrl"]
                data_item.SmallIntImageUrl = "\(value!)"
                
                themeList.append(data_item)
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
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // CollectionThemeCell
        
        let identify = "CollectionThemeCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identify, forIndexPath: indexPath) as UICollectionViewCell
        
        
        ( cell.contentView.viewWithTag(101) as UILabel).text = themeList[indexPath.row].ClassName
        
        
        var imagevvv = cell.viewWithTag(102) as UIImageView
        
        let URL = NSURL(string: "\(URL_IMAGE_BASE)\(themeList[indexPath.row].SmallIntImageUrl)")!
        imagevvv.hnk_setImageFromURL(URL)
        
        return cell
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "search_list"
        {
            var vc = segue.destinationViewController as UIVC_SearchList
           
            
            if call_goods_list_type == 1
            {
                vc.call_type = vc.WS_MoreMzq
            }
            else if call_goods_list_type == 2
            {  
                vc.call_type = vc.WS_Query_MoreSecKill
            }
        }
        else if segue.identifier == "segue_keyword_goods_list"
        {
            var vc = segue.destinationViewController as UIVC_SearchKeyword
            
            
            //更多超值购
            if superValue_select == 0
            {
                
                vc.call_type = vc.WS_SearchMoreCzg
            }
            //超值购
            else
            {
                vc.CzgID = superValu[superValue_select-1].ID
                vc.call_type = vc.WS_SearchGoodByCzg
            }
        }
    }
}









