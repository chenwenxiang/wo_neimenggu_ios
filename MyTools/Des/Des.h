//
//  Des.h
//  TextTabbar
//
//  Created by q on 15/3/12.
//  Copyright (c) 2015年 q. All rights reserved.
//

#import <Foundation/Foundation.h>

/******字符串转base64（包括DES加密）******/
#define __BASE64( text )        [Base64codeFunc base64StringFromText:text]

/******base64（通过DES解密）转字符串******/
#define __TEXT( base64 )        [Base64codeFunc textFromBase64String:base64]

@interface Base64codeFunc : NSObject


-(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;



@end