//
//  Format.swift
//  Haneke
//
//  Created by Hermes Pique on 8/27/14.
//  Copyright (c) 2014 Haneke. All rights reserved.
//

import UIKit

class SaveData
{
    
    func readCartData() -> Array<CartData>
    {
        
        var db:SQLiteDB!
        db = SQLiteDB.sharedInstance()
        
        
        
        let data = db.query("select * from t_cartdata")
        
        var cartDataList = Array<CartData>()
        
        cartDataList.removeAll(keepCapacity: true)
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
            
            
            
            cartDataList.append(cartDataTemp)
        }
        
        return cartDataList
        
    }
    
    func insert_goods_to_database(cartData_temp: CartData) -> Bool
    {
        
        var db:SQLiteDB!
        db = SQLiteDB.sharedInstance()
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        let sql = "insert into t_cartdata(ID,choose,name,price,old_price,number,imageUrl,time,color,size,cartId) values('\(db.esc(cartData_temp.ID))','\(db.esc(cartData_temp.choose))','\(db.esc(cartData_temp.name))','\(db.esc(cartData_temp.price))','\(db.esc(cartData_temp.oldprice))','\(db.esc(cartData_temp.number))','\(db.esc(cartData_temp.imageUrl))','\(db.esc(cartData_temp.time))','\(db.esc(cartData_temp.color))','\(db.esc(cartData_temp.size))','\(db.esc(cartData_temp.time))')"
        println("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
        
        
        
        
        return true
        
        
    }
    
    func update_goods_to_database(cartData_temp: CartData) -> Bool
    {
        
        var db:SQLiteDB!
        db = SQLiteDB.sharedInstance()
        //插入数据库，这里用到了esc字符编码函数，其实是调用bridge.m实现的
        //UPDATE " + TABLENAMES + " SET number
//        let sql = "UPDATE  t_cartdata(ID,choose,name,price,old_price,number,imageUrl,time,color,size,cartId) values('\(db.esc(cartData_temp.ID))','\(db.esc(cartData_temp.choose))','\(db.esc(cartData_temp.name))','\(db.esc(cartData_temp.price))','\(db.esc(cartData_temp.oldprice))','\(db.esc(cartData_temp.number))','\(db.esc(cartData_temp.imageUrl))','\(db.esc(cartData_temp.time))','\(db.esc(cartData_temp.color))','\(db.esc(cartData_temp.size))','\(db.esc(cartData_temp.time))')"
//        
        
        
        
        let sql = "UPDATE t_cartdata SET number = \(cartData_temp.number) WHERE ID = '\(cartData_temp.ID)'"
        println("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql)
        println("result.successor()=\(result)")
        
        
        return true
    }
    
    func add_goods_to_database(goods: CartData)-> Bool
    {
        
        var cartGoodsList =  readCartData()
        
        if cartGoodsList.count <= 0
        {
            goods.number = "1"
            return insert_goods_to_database(goods)
        }
        
        for var i = 0; i < cartGoodsList.count; i++
        {
            if (cartGoodsList[i].ID == goods.ID)
            {
                goods.number = "\((cartGoodsList[i].number as NSString).intValue + 1)"

                return update_goods_to_database( goods);
            }
        }
        
        goods.number = "1"
        return insert_goods_to_database( goods);
    }
    
    func substract_goods_to_database(goods: CartData)-> Bool
    {
        var db:SQLiteDB!
        db = SQLiteDB.sharedInstance()
        
        var cartGoodsList =  readCartData()
        
       	if (goods.number as NSString).intValue > 0
        {
            
            
            
            let sql = "UPDATE t_cartdata SET number = number-1 WHERE ID = '\(goods.ID)'"
            println("sql: \(sql)")
            //通过封装的方法执行sql
            let result = db.execute(sql)

        }
        else
        {
            let sql = "DELETE FROM t_cartdata WHERE ID = '\( goods.ID )'"
            
            let result = db.execute(sql)
        }
        
        
        return true
    }
    func delete_goods_to_database(goods: CartData)-> Bool
    {
        var db:SQLiteDB!
        db = SQLiteDB.sharedInstance()
        
   

            let sql = "DELETE FROM t_cartdata WHERE ID = '\( goods.ID )'"
            
            let result = db.execute(sql)
    
        
        
        return true
    }
 
}
