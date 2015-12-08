//
//  ViewController.m
//  lhShareTest
//
//  Created by bosheng on 15/11/20.
//  Copyright © 2015年 yutiandesan. All rights reserved.
//

#import "ViewController.h"
#import "lhGPS.h"

@interface ViewController ()

@end

@implementation ViewController

#warning 说明
/*
    1.实际项目中第三方资源不建议直接拖入工程中使用，这样会增大ipa的体积。可将包放到其他地方，在工程中导入使用。或者用第三方依赖库管理工具.(例如：CocoaPods)
    2.“分享”和“指纹验证”请用真机进行测试
    3.“导航”APIKey设置请看APIKey.h文件
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [lhColor assignmentForTempVC:self];
    
    UIButton * fxBtn = [UIButton new];
    fxBtn.backgroundColor = [UIColor blackColor];
    [fxBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fxBtn setTitle:@"分享" forState:UIControlStateNormal];
    [fxBtn addTarget:self action:@selector(fxBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fxBtn];
    
    __weak typeof(self) weakSelf = self;
    [fxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.view).with.offset(100);
        make.right.equalTo(weakSelf.view).with.offset(-100);
        make.height.mas_equalTo(@60);
    }];
    
    UIButton * goBtn = [UIButton new];
    goBtn.backgroundColor = [UIColor blackColor];
    [goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goBtn setTitle:@"导航" forState:UIControlStateNormal];
    [goBtn addTarget:self action:@selector(goBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBtn];
    
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fxBtn.mas_bottom).with.offset(30);
        make.left.width.height.equalTo(fxBtn);
    }];
    
    UIButton * validateBtn = [UIButton new];
    validateBtn.backgroundColor = [UIColor blackColor];
    [validateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [validateBtn setTitle:@"指纹验证" forState:UIControlStateNormal];
    [validateBtn addTarget:self action:@selector(validateBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:validateBtn];
    
    [validateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goBtn.mas_bottom).with.offset(30);
        make.left.width.height.equalTo(fxBtn);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 点击分享
- (void)fxBtnEvent
{
    NSString * cStr= @"您加油，我埋单。注册优品App即得50元优惠券，优品加油，在路上，最对味的加油软件来了。【长颈鹿阿普已出道】";
    UIImage * imgV = imageWithName(@"iconImg");
    [lhColor fxViewAppear:imgV conStr:cStr withUrlStr:@"http://www.up-oil.com/f"];
}

#pragma mark - 导航
- (void)goBtnEvent
{
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(30.257336, 104.065753);
    CLLocationCoordinate2D endCoord = CLLocationCoordinate2DMake(30.657336, 104.065753);
    [[lhGPS sharedInstanceGPS]prepareData:self startLocation:startCoord endLocation:endCoord];//准备数据
    
    [[lhGPS sharedInstanceGPS]startNaviGPS];//开始导航
}

#pragma mark - 指纹验证
- (void)validateBtnEvent
{
    
    if(IOS8){//指纹，iOS8以后才支持指纹识别
        [[lhColor shareColor] validateUser:^(validateType vt) {
            switch (vt) {
                case vaSuccess:{
                    NSLog(@"验证成功");
                    //验证成功
                    
                    break;
                }
                case notSetPas:{
                    NSLog(@"未设置");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先在设置->Touch ID与密码中进行指纹设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                    break;
                }
                case failValidate:{//验证失败，使用密码支付
                    NSLog(@"验证失败");

                    break;
                }
                case usePasPay:{
                    NSLog(@"使用密码支付");
                    
                    break;
                }
                case userCancel:{
                    NSLog(@"用户取消验证");
                    break;
                }
                default:{
                    NSLog(@"其他");
                    break;
                }
            }
        }];
        
    }

}

@end
