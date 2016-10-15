//
//  NSObject+NetOperation.h
//  42Certer-Three
//
//  Created by dragon on 15/11/29.
//  Copyright © 2015年 dragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> // 加密导入的头文件

#define PID @"1"
#define CALG @"12345678"
#define LOGINURL @"http://172.24.254.138"
#define LOGIOUTURL @"http://172.24.254.138/F.html"
//保存到arrayKeys
#define KEY1 @"DDDDD"
#define KEY2 @"upass"
#define KEY3 @"R1"
#define KEY4 @"R2"
#define KEY5 @"para"
#define KEY6 @"0MKKEY"
//保存到arrayValues
#define VALUE3 @"0"
#define VALUE4 @"1"
#define VALUE5 @"00"
#define VALUE6 @"123456"

@interface NetOperation : NSObject
{
    NSString *pid; //pid
    NSString *calg; //calg
    NSMutableArray *arrayKeys;  //存储写死的数据
    NSMutableArray *arrayValues; //存储写死的数据
    NSMutableString *upass;  //加密后的字符串
    NSString *loginOutUrl; //注销需要访问的网页
    NSString *userName; //用户名
    NSString *password; //密码
    NSMutableDictionary *words; //两组写死的数据组合
    NSMutableString *postString; //要发送的数据（字符串）
}


-(void)connectNet;
-(void)LoginOutNet;
@end
