//
//  SecondViewController.swift
//  TextTabbar
//
//  Created by q on 15/1/11.
//  Copyright (c) 2015 q. All rights reserved.
//

import UIKit

class TabCartViewController: MyViewController, UITableViewDataSource {
    
    
    var db:SQLiteDB!
    
    @IBOutlet weak var Button_cart_no_goods: UILabel!
    @IBOutlet weak var Button_total_price: UILabel!
    @IBOutlet weak var Button_all_choice: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var cartData = [CartData]()
    var choice = [Bool]()
    
    var saveData = SaveData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        
        //获取数据库实例
        db = SQLiteDB.sharedInstance()
        //如果表还不存在则创建表
       // db.execute("create table if not exists t_cartdata(ID VARCHAR,choose VARCHAR,name VARCHAR,price VARCHAR,old_price VARCHAR,number VARCHAR,imageUrl VARCHAR,time VARCHAR,color VARCHAR,size VARCHAR,cartId VARCHAR)")
        
        //如果有数据则加载
        initUser()
       // saveUser()
        
        
        Button_total_price.text = "总价：￥\(0.00)"
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //获取数据库实例
        db = SQLiteDB.sharedInstance()
        //如果表还不存在则创建表
        // db.execute("create table if not exists t_cartdata(ID VARCHAR,choose VARCHAR,name VARCHAR,price VARCHAR,old_price VARCHAR,number VARCHAR,imageUrl VARCHAR,time VARCHAR,color VARCHAR,size VARCHAR,cartId VARCHAR)")
        
        //如果有数据则加载
        initUser()
        

    }
    
    
    //从SQLite加载数据
    func initUser() {
        let data = db.query("select * from t_cartdata")
        
        
        Button_cart_no_goods.hidden = true
        if data.count <= 0
        {
            Button_cart_no_goods.hidden = false
        }
        
        cartData.removeAll(keepCapacity: true)
        choice.removeAll(keepCapacity: true)
        
        for var i = 0 ;i < data.count; i++
        {
            
            var cartDataTemp = CartData()
            //获取最后一行数据显示
            let user = data[i] as SQLRow
            cartDataTemp.ID =  user["ID"]!.string
            cartDataTemp.choose = user["choose"]!.string
            cartDataTemp.name = user["name"]!.string
            cartDataTemp.price = user["price"]!.string
           // cartDataTemp.old_price = user["old_price"]!.string
            cartDataTemp.number = user["number"]!.string
            cartDataTemp.imageUrl = user["imageUrl"]!.string
            cartDataTemp.time = user["time"]!.string
            cartDataTemp.color = user["color"]!.string
            cartDataTemp.size = user["size"]!.string
            cartDataTemp.cartId = user["cartId"]!.string
            
            cartData.append(cartDataTemp)
            
            
            choice.append(false)
        }
        
        tableView.reloadData()
    }
    
    //保存数据到SQLite
    func saveUser() {
        let uname = "asdfghjkl;"
        let mobile = "1234567890"
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into t_user(uname,mobile) values('\(db.esc(uname))','\(db.esc(mobile))')"
        println("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var allchoice = false
    
    
    // MARK - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cartData.count
    }
    
    @IBOutlet weak var button_cartMode: UIButton!
    
    func showTotalPrice()
    {
        
        var total_price_money:Float = 0.0
        for var i = 0; i < cartData.count; i++
        {
            if choice[i] == true
            {
                total_price_money += ((cartData[i].price as NSString).floatValue * (cartData[i].number as NSString).floatValue)
            }
        }
        
        Button_total_price.text = "总价：￥\(total_price_money)"
    }
    
    @IBAction func handle_checkout(sender: AnyObject) {
        
//        if userData?.UserID.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) >  0
//        {
            self.performSegueWithIdentifier("cart_buy_segue", sender: self)
         
//        }
//        else
//        {
//            showlogin()
//        }
    }
    
    @IBAction func handle_all_choice(sender: AnyObject) {
        
        if allchoice == true
        {
            allchoice = false
            for var i = 0; i < cartData.count; i++
            {
                choice[i] = false
            }
            Button_all_choice.setImage(UIImage(named: "icon_multiOff.png"),forState:.Normal)
            
            Button_total_price.text = "总价：￥\(0.00)"
        }
        else
        {
            allchoice = true
            Button_all_choice.setImage(UIImage(named: "icon_multiOn.png"),forState:.Normal)
            
            for var i = 0; i < cartData.count; i++
            {
                 choice[i] = true
            }

            showTotalPrice()

        }
        
        tableView.reloadData()
    }
    
    
    func Button_addGoodsNum(button:UIButton)
    {
        var but_tag = button.tag-100
        
       // button.
        
        if but_tag < cartData.count
        {
            
            
            if saveData.add_goods_to_database(cartData[but_tag]) == true
            {
             //   cartData[but_tag].number = "\((cartData[but_tag].number as NSString).intValue + 1)"
            }
            
            tableView.reloadData()
        }
        
        showTotalPrice()
    }
    
    func Button_subGoodsNum(button:UIButton)
    {
        var but_tag = button.tag-200
        
        if (cartData[but_tag].number as NSString).intValue <= 1
        {
            return
        }
        
        if saveData.substract_goods_to_database(cartData[but_tag]) == true
        {
            cartData[but_tag].number = "\((cartData[but_tag].number as NSString).intValue - 1)"
        }
        
   
            
       tableView.reloadData()
        
        
        
        showTotalPrice()
    }
    
    
    func Button_deleteGoodsNum(button:UIButton)
    {
        
        var but_tag = button.tag-300
        
        if but_tag < cartData.count
        {
            
            if saveData.delete_goods_to_database(cartData[but_tag]) == true
            {
                cartData.removeAtIndex(but_tag)
                choice.removeAtIndex(but_tag)
            }
            
            tableView.reloadData()
        }
        
        showTotalPrice()
    }
    
    
    
    func Button_choiceGoods(button:UIButton)
    {
        
        var but_tag = button.tag-400
        
        if but_tag < cartData.count
        {
            if choice[but_tag ] == true
            {
                choice[but_tag ] = false
            }else
            {
                choice[but_tag ] = true
            }
            tableView.reloadData()

            showTotalPrice()
            
            var total_price_money:Float = 0.0
            for var i = 0; i < cartData.count; i++
            {
                if choice[i] == false
                {
                    
                    Button_all_choice.setImage(UIImage(named: "icon_multiOff.png"),forState:.Normal)
                    
                    tableView.reloadData()
                    return
                }
            }
            Button_all_choice.setImage(UIImage(named: "icon_multiOn.png"),forState:.Normal)
        }
    }
    
    
    let mode_normal = "完成"
    let mode_edit = "编辑"
    
    var cartMode_Normal = true
    
    @IBAction func changeCartMode(sender: AnyObject) {
        cartMode_Normal = !cartMode_Normal
        if(cartMode_Normal)
        {
            button_cartMode.setTitle( mode_edit, forState: UIControlState.Normal)
        }
        else
        {
            button_cartMode.setTitle (mode_normal, forState: UIControlState.Normal)
        }
        
        tableView.reloadData()
    }

    // Display the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(cartMode_Normal)
        {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cartCellNormal") as UITableViewCell
            
            
            var order_image = cell.viewWithTag(1002) as UIImageView
            
            
            let URL = NSURL(string: "http://116.113.88.50\(cartData[indexPath.row].imageUrl)")!
            order_image.hnk_setImageFromURL(URL)
            
            
            var goods_name = cell.viewWithTag(1003) as UILabel
            goods_name.text = "\(cartData[indexPath.row].name)"
            
            
            var goods_cate = cell.viewWithTag(1004) as UILabel
            goods_cate.text = "\(cartData[indexPath.row].color),\(cartData[indexPath.row].size)"
            
            var goods_price = cell.viewWithTag(1005) as UILabel
            goods_price.text = "￥\(cartData[indexPath.row].price)"
            
            var goods_num = cell.viewWithTag(1006) as UILabel
            goods_num.text = "x\(cartData[indexPath.row].number)"
            
            
            
            if cell.viewWithTag(1001) != nil
            {
                var button_choice = cell.viewWithTag(1001)  as UIButton
                button_choice.tag = indexPath.row + 400
                
                
                button_choice.addTarget(self, action: "Button_choiceGoods:", forControlEvents: UIControlEvents.TouchUpInside);

            }
            else
            {
                
                var button_choice = cell.viewWithTag(400+indexPath.row)  as UIButton
                if choice[indexPath.row] == false
                {
                    button_choice.setImage(UIImage(named: "icon_multiOff.png"),forState:.Normal)
                }
                else
                {
                    button_choice.setImage(UIImage(named: "icon_multiOn.png"),forState:.Normal)
                }
            }
            
            return cell
        }
        else
        {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cartCellEdit") as UITableViewCell
            
            var order_image = cell.viewWithTag(2002) as UIImageView
            
            
            let URL = NSURL(string: "http://116.113.88.50\(cartData[indexPath.row].imageUrl)")!
            order_image.hnk_setImageFromURL(URL)
            
            
            var goods_price = cell.viewWithTag(2003) as UILabel
            goods_price.text = "￥\(cartData[indexPath.row].price)"
            
            var goods_num = cell.viewWithTag(2004) as UILabel
            goods_num.text = "\(cartData[indexPath.row].number)"
            
            if cell.viewWithTag(2006) != nil
            {
                var button_add = cell.viewWithTag(2006)  as UIButton
            
            
                button_add.tag = 100+indexPath.row
            
                button_add.addTarget(self, action: "Button_addGoodsNum:", forControlEvents: UIControlEvents.TouchUpInside);
            }
            
            if cell.viewWithTag(2005) != nil
            {
                var button_sub = cell.viewWithTag(2005) as UIButton
                button_sub.tag = 200+indexPath.row
                
                button_sub.addTarget(self, action: "Button_subGoodsNum:", forControlEvents: UIControlEvents.TouchUpInside);
            }
            
            
            if cell.viewWithTag(2007) != nil
            {
                var button_sub = cell.viewWithTag(2007) as UIButton
                button_sub.tag = 300+indexPath.row
                
                button_sub.addTarget(self, action: "Button_deleteGoodsNum:", forControlEvents: UIControlEvents.TouchUpInside);
            }
            
            if cell.viewWithTag(2001) != nil
            {
                var button_choice = cell.viewWithTag(2001)  as UIButton
                button_choice.tag = indexPath.row + 400
                
                
                button_choice.addTarget(self, action: "Button_choiceGoods:", forControlEvents: UIControlEvents.TouchUpInside);
                
            }
            else
            {
                
                var button_choice = cell.viewWithTag(400+indexPath.row)  as UIButton
                if choice[indexPath.row] == false
                {
                    button_choice.setImage(UIImage(named: "icon_multiOff.png"),forState:.Normal)
                }
                else
                {
                    button_choice.setImage(UIImage(named: "icon_multiOn.png"),forState:.Normal)
                }
            }

            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cart_buy_segue"
        {
            var vc = segue.destinationViewController as UIVC_WriteOrder
            
            
            var cartDataList_temp = Array<CartData>()
            
//            var cartData = [CartData]()
//            var choice = [Bool]()
            for var i = 0; i < cartData.count; i++
            {
                
                if choice[i] == true
                {
                    cartDataList_temp.append(cartData[i])
                }
            }
            
            
            vc.cartData = cartDataList_temp
            
        }
    }

    
    
    @IBAction func back_key(segue: UIStoryboardSegue)
    {
        tableView.reloadData()
    }
}

