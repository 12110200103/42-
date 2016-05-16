//
//  NetViewController.m
//  42centerTwo
//
//  Created by dragon on 15/10/21.
//  Copyright © 2015年 dragon. All rights reserved.
//

#import "NetViewController.h"

@interface NetViewController () <UITextFieldDelegate>

@property (strong,nonatomic) UITextField* Logininfo;
@property (strong,nonatomic) UITextField* Pwdinfo;
@property (strong,nonatomic) UILabel *LoginLabel;
@property (strong,nonatomic) UILabel *PwdLabel;
@property (strong,nonatomic) UIButton *LoginButton;
@property (strong,nonatomic) UIButton *checkButton;
@property (strong,nonatomic) UILabel *infomation;
@property (strong,nonatomic) UIButton *Logout;
@property (strong,nonatomic) UILabel * Mytitle;
@property (strong,nonatomic) UILabel * remeberPwd;

@end

@implementation NetViewController

-(void) setMulitableValues {
    _pid = [NSString stringWithFormat:@"1"];
    _calg =[NSString stringWithFormat:@"12345678"];

}
-(void) setArrayWithNeusoft {
    _arrayValues= [[NSMutableArray alloc] initWithObjects:_Logininfo.text,_upass,@"0",@"1",@"00",@"123456", nil];
    _arrayKeys = [[NSMutableArray alloc] initWithObjects:@"DDDDD",@"upass",@"R1",@"R2",@"para",@"0MKKEY", nil];
}

-(NSMutableString *)md5:(NSMutableString *)str //MD5加密
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


-(void) NetConnect {//网络连接
    
    [self setMulitableValues];

    NSString * myPassword = _Pwdinfo.text;
    NSMutableString * password = [[NSMutableString alloc] initWithString:_pid];
    [password appendString:myPassword];
    [password appendString:_calg];
    [password lowercaseString]; //转换成小写
    password = [self md5:password]; //加密
    _upass = [[NSMutableString alloc] initWithCapacity:14];
    [_upass appendString:password];
    [_upass appendString:_calg];
    [_upass appendString:_pid];
    [self setArrayWithNeusoft];
    
    
    NSMutableDictionary *words = [[NSMutableDictionary alloc] initWithObjects:_arrayValues forKeys:_arrayKeys];
    NSMutableString *postString = [[NSMutableString alloc] initWithCapacity:14];//要发送数据
    int i =0 ;
    for (NSString* key in [words allKeys]) { //组合
        [postString appendString:key];
        [postString appendString:@"="];
        [postString appendString:[words objectForKey:key]];
        if (i < 5) {
             [postString appendString:@"&"];
        }
       
        i++;
    }
    
    NSLog(@"postString: %@",postString);
    NSString *urlStr = @"http://172.24.254.138";
    NSURL * url = [NSURL URLWithString:urlStr];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event { //键盘隐藏
    [_Logininfo resignFirstResponder];
    [_Pwdinfo resignFirstResponder];
    [_LoginButton resignFirstResponder];
}

-(void)LoginButtonAction:(id)button {
    
    [self NetConnect];
    NSString *userFromData = @"123"; //从数据库中拿到账号密码，暂定为固定的
    NSString *pwdFromData = @"123";
    
    if ([[self.Logininfo text]  isEqual: userFromData] && [[self.Pwdinfo text] isEqual:pwdFromData]) {
        NSLog(@"ok!!!!");
        self.Logininfo.enabled = NO; //用户名不可修改
        self.Pwdinfo.enabled = NO;  //密码不可修改
        self.LoginButton.enabled = NO; // 按钮不可点击
        self.infomation.text = @"登陆成功"; //显示登录成功
    }
    
    else {
        //设置提醒框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号或者密码错误" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
        [alert addAction:alertAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

//记住密码的按钮的响应事件
-(void) isRemeberPwd {
    
}


//注销
-(void)LogoutButtonAction:(id)button {
    
    
    _urlStr = @"http://172.24.254.138/F.html";
    NSURL * url = [NSURL URLWithString:_urlStr];
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
    
    
    NSLog(@"注销！！");
    _Logininfo.text = nil;
    _Logininfo.enabled = YES;
    _Pwdinfo.text = nil;
    _Pwdinfo.enabled = YES;
    _infomation.text = @"注销成功";
    _LoginButton.enabled = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注销成功！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:alertAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void) storyBoardDesign {
    
    [self.view setBackgroundColor:[UIColor whiteColor]]; // 背景暂时设置为白色
    
    //标题
    _Mytitle = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, (self.view.frame.size.height)/10, (self.view.frame.size.width)/3, (self.view.frame.size.height)/13)];
    _Mytitle.backgroundColor = [UIColor whiteColor];
    [_Mytitle setText:@"校园网络助手"];
    [self.view addSubview:_Mytitle];
    
    //账号控件
    _Logininfo = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/5, (self.view.frame.size.height)/5 ,2*(self.view.frame.size.width)/3,(self.view.frame.size.height)/13)];
    _Logininfo.backgroundColor = [UIColor grayColor]; // 账号输入框设置为白色
    _Logininfo.placeholder = [NSString stringWithFormat:@"请输入账号"];
    _Logininfo.clearButtonMode = UITextFieldViewModeWhileEditing;
    _Logininfo.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_Logininfo];
    
    //密码控件
    _Pwdinfo = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/5, (self.view.frame.size.height)/5 +  (self.view.frame.size.height)/9 , 2*(self.view.frame.size.width)/3, (self.view.frame.size.height)/13)];
    _Pwdinfo.backgroundColor = [UIColor grayColor]; // 账号输入框设置为白色
    _Pwdinfo.placeholder = [NSString stringWithFormat:@"请输入密码"];
    _Pwdinfo.clearButtonMode = UITextFieldViewModeWhileEditing;
    _Pwdinfo.secureTextEntry = YES;
    _Pwdinfo.clearsOnBeginEditing = YES;
    [self.view addSubview:_Pwdinfo];
    
    //账号信息
    _LoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(self.view.frame.size.height)/5,50,40)];
    [_LoginLabel setText:@"账号"];
    _LoginLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_LoginLabel];
    
    //密码信息
    _PwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,(self.view.frame.size.height)/5 + (self.view.frame.size.height)/9,50,40)];
    [_PwdLabel setText:@"密码"];
    _PwdLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_PwdLabel];
    
    //记住密码选择框
    _checkButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/5, (self.view.frame.size.height)/3 + (self.view.frame.size.height)/13, (self.view.frame.size.width)/10, (self.view.frame.size.width)/10)];
    _checkButton.backgroundColor = [UIColor blueColor];
    [_checkButton addTarget:self action:@selector(isRemeberPwd) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:_checkButton];
    
    _remeberPwd = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/3, (self.view.frame.size.height)/3 + (self.view.frame.size.height)/13, (self.view.frame.size.width)/3, (self.view.frame.size.width)/10)];
    _remeberPwd.backgroundColor = [UIColor whiteColor];
    [_remeberPwd setText:@"记住密码"];
    [self.view addSubview:_remeberPwd];
    
    
    //登陆按钮
    _LoginButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/4, (self.view.frame.size.height)/3 + (self.view.frame.size.height)/6, (self.view.frame.size.width)/2, (self.view.frame.size.width)/10)];
    [_LoginButton setTintColor:[UIColor whiteColor]];
    [_LoginButton setTitle:@"登陆" forState:UIControlStateNormal];
    _LoginButton.backgroundColor = [UIColor redColor];
    [_LoginButton addTarget:self action:@selector(LoginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_LoginButton];
    
    //注销按钮
    _Logout = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width)/4, (self.view.frame.size.height)/3 + (self.view.frame.size.height)/6+(self.view.frame.size.width)/7, (self.view.frame.size.width)/2, (self.view.frame.size.width)/10)];
    [_Logout setTintColor:[UIColor whiteColor]];
    [_Logout setTitle:@"注销" forState:UIControlStateNormal];
    _Logout.backgroundColor = [UIColor redColor];
    [_Logout addTarget:self action:@selector(LogoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_Logout];
    
    //登陆状态显示
    _infomation = [[UILabel alloc] initWithFrame:CGRectMake(10, 3*(self.view.frame.size.height)/4, 8 * (self.view.frame.size.width)/9, (self.view.frame.size.width)/9)];
    [_infomation setTintColor:[UIColor redColor]];
    _infomation.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_infomation];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self storyBoardDesign];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField ==  _Pwdinfo) {
        [_LoginButton becomeFirstResponder];
    }
    
    return YES;
}







@end
