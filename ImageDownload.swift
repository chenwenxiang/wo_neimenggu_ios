//
//  ImageDownload.swift
//  TextTabbar
//
//  Created by q on 15/3/8.
//  Copyright (c) 2015 q. All rights reserved.
//


import UIKit


class ImageDownload
{
    
    
    func getImage( iv:UIImageView, url:String )
    {
        var nsd = NSData(contentsOfURL:NSURL(string: url)!)
        iv.image = UIImage(data: nsd!)
    }
} 