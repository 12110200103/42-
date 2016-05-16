//
//  NSObject+NetOperation.m
//  42Certer-Three
//
//  Created by dragon on 15/11/29.
//  Copyright © 2015年 dragon. All rights reserved.
//

#import "NetOperation.h"

@implementation NetOperation

#pragma MD5-16位加密方法
-(NSMutableString *)md5:(NSMutableString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSMutableString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma 初始化
-(void)DataInitialization {
    pid = PID;
    calg = CALG;
    arrayKeys = [[NSMutableArray alloc] initWithObjects:KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,nil];
    arrayValues = [[NSMutableArray alloc] initWithObjects:userName,password,VALUE3,VALUE4,VALUE5, nil];
    words = [[NSMutableDictionary alloc] initWithObjects:arrayValues forKeys:arrayKeys];
    //密码加密处理
    [upass appendString:pid];
    [upass appendString:password];
    [upass appendString:calg];
    [upass lowercaseString];
    upass = [self md5:upass];
    [upass appendString:calg];
    [upass appendString:pid];
    //数据整合成一个字符串
    int i = 0;
    for (NSString *key in [words allKeys]) {
        [postString appendString:key];
        [postString appendString:@"="];
        [postString appendString:[words objectForKey:key]];
        if (i < 5) {
            [postString appendString:@"&"];
        }
        
        i++;
    }
    
}

#pragma 网络连接
-(void)connectNet {
    [self DataInitialization];
    NSURL *url = [NSURL URLWithString:LOGINURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];   //声明http请求
    [request setHTTPMethod:@"POST"];//POST请求
    [request setTimeoutInterval:4.0]; // 超时时间
    NSMutableString *content = postString;//发送内容
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];//发送
    
    NSOperationQueue * queue = [NSOperationQueue mainQueue];//声明线程队列
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *returnResponse,NSData *data,NSError * error){//异步请求
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) returnResponse; //响应
        //NSInteger statusCode =
        [httpResponse statusCode];//状态码
        NSDictionary *responseHeaders = [httpResponse allHeaderFields]; //头信息
        if (error || data == nil){
            NSLog(@"请求失败");
        }
        else {
            NSLog(@"%ld",(long)[httpResponse statusCode]);
            NSLog(@"%@",responseHeaders);
            NSLog(@"%s",data.bytes);
        }
        
    }];
}

#pragma 网络注销
-(void)LoginOutNet {
    loginOutUrl = LOGIOUTURL;
    NSURL *url = [NSURL URLWithString:loginOutUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:2.0];
    NSOperationQueue * queue = [NSOperationQueue mainQueue];//声明线程队列
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *returnResponse,NSData *data,NSError * error){//异步请求
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) returnResponse; //响应
        //NSInteger statusCode =
        [httpResponse statusCode];//状态码
        NSDictionary *responseHeaders = [httpResponse allHeaderFields]; //头信息
        if (error || data == nil){
            NSLog(@"请求失败");
        }
        else {
            NSLog(@"%ld",(long)[httpResponse statusCode]);
            NSLog(@"%@",responseHeaders);
            NSLog(@"%s",data.bytes);
        }
        
    }];
}

@end

