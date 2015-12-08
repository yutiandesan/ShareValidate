//
//  lhColor.m
//  lhShareTest
//
//  Created by bosheng on 15/11/20.
//  Copyright © 2015年 yutiandesan. All rights reserved.
//

#import "lhColor.h"
#import "lhSymbolCustumButton.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

#import <LocalAuthentication/LocalAuthentication.h>

#define fxBgViewTag 300
#define fxLowViewTag 301
#define activityImgTag 198
#define activityTag 199
#define backBtnTag 302

//分享图片和描述
static NSString * fxConStr;
static UIImage * fxImg;
static NSString * fxUrlStr;

static UILabel * tempLabel;//提示显示label

static lhColor * onlyColor;//单例

static UIViewController * tempVC;//当前VC

@interface lhColor(){
    UIWebView * phoneCallWebView;//拨打电话View
}

@end

@implementation lhColor

//单例
+ (instancetype)shareColor
{
    if (onlyColor) {
        return onlyColor;
    }
    onlyColor = [[lhColor alloc]init];
    
    return onlyColor;
}

#pragma mark - 正在加载仅显示一个activity
//正在连接
+ (void)addActivityView:(UIView *)view
{
    UIView * aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    aView.layer.cornerRadius = 10;
    aView.layer.allowsEdgeAntialiasing = YES;
    aView.layer.masksToBounds = YES;
    aView.tag = activityTag;
    aView.center = view.center;
    aView.backgroundColor = [UIColor blackColor];
    [view addSubview:aView];
    
    UIActivityIndicatorView *waitActivity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    waitActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [aView addSubview:waitActivity];
    [waitActivity startAnimating];
    
    [lhColor closeUserEnable:view];
}

+ (void)disAppearActivitiView:(UIView *)view
{
    UIView * aView = (UIView *)[view viewWithTag:activityTag];
    UIImageView * imgView = (UIImageView *)[view viewWithTag:activityImgTag];
    if (aView) {
        if (imgView) {
            [imgView stopAnimating];
        }
        [aView removeFromSuperview];
        aView = nil;
    }
    [lhColor openUserEnable:view];
}

+ (void)closeUserEnable:(UIView *)viw
{
    for (UIView * v in viw.subviews) {
        if (v.tag != backBtnTag) {
            v.userInteractionEnabled = NO;
        }
    }
}

+ (void)openUserEnable:(UIView *)vie
{
    for (UIView * v in vie.subviews) {
        v.userInteractionEnabled = YES;
    }
}

//获取颜色
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

#pragma mark - 提示
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih
{
    if (!tempLabel) {
        tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, heih, DeviceMaxWidth, 40)];
        tempLabel.layer.cornerRadius = 5;
        tempLabel.layer.allowsEdgeAntialiasing = YES;
        tempLabel.layer.masksToBounds = YES;
        tempLabel.backgroundColor = [UIColor blackColor];
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.font = [UIFont fontWithName:nowFontName size:13];
        tempLabel.text = message;
        tempLabel.textAlignment = NSTextAlignmentCenter;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    else{
        tempLabel.alpha = 1;
        tempLabel.hidden = NO;
        tempLabel.text = message;
        
        [tempLabel sizeToFit];
        tempLabel.frame = CGRectMake((DeviceMaxWidth-tempLabel.frame.size.width)/2, heih, tempLabel.frame.size.width+20, 40);
    }
    
    [superView addSubview:tempLabel];
    
    [onlyColor performSelector:@selector(tempLabelDis) withObject:nil afterDelay:2];
    
}

- (void)tempLabelDis
{
    if (tempLabel) {
        [UIView animateWithDuration:0.5 animations:^{
            tempLabel.alpha = 0;
        }completion:^(BOOL finished) {
            [tempLabel removeFromSuperview];
            tempLabel = nil;
        }];
    }
}

#pragma mark - 拨打电话
- (void)detailPhone:(NSString *)phone
{
    //NSLog(@"拨打电话");
    [self dialPhoneNumber:phone];
}

- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark - 添加分享
+ (void)fxViewAppear:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr
{
    fxConStr = cStr;
    fxImg = Img;
    fxUrlStr = urlStr;
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:[lhColor shareColor] action:@selector(fxViewDisAppear)];
    UIView * grayV = [[UIView alloc]initWithFrame:tempVC.view.frame];
    grayV.tag = fxBgViewTag;
    grayV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [grayV addGestureRecognizer:tapG];
    [tempVC.view addSubview:grayV];
    
    UIView * fxView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 96*widthRate)];
    fxView.tag = fxLowViewTag;
    fxView.backgroundColor = [UIColor whiteColor];
    [tempVC.view addSubview:fxView];
    
    NSArray * a = @[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间"];
    for (int i = 0; i < 4; i++) {
        lhSymbolCustumButton * fxBtn = [[lhSymbolCustumButton alloc]initWithFrame:CGRectMake(80*widthRate*i, 0, 80*widthRate, 96*widthRate)];
        fxBtn.showsTouchWhenHighlighted = YES;
        fxBtn.tag = i;
        NSString * str = [NSString stringWithFormat:@"fxImage%d",i];
        [fxBtn setBackgroundImage:imageWithName(str) forState:UIControlStateNormal];
        fxBtn.tLabel.text = [a objectAtIndex:i];
        CGRect rec = fxBtn.tLabel.frame;
        rec.origin.y = 72*widthRate;
        fxBtn.tLabel.frame = rec;
        [fxBtn addTarget:[lhColor shareColor] action:@selector(fxBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        [fxView addSubview:fxBtn];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 1;
        fxView.frame = CGRectMake(0, DeviceMaxHeight-96*widthRate, DeviceMaxWidth, 96*widthRate);
    }];
    
}

- (void)fxBtnEvent:(UIButton *)button_
{
    [onlyColor fxViewDisAppear];
    
    ShareType type;
    switch (button_.tag) {
        case 0:{
            //微信好友
            type = ShareTypeWeixiSession;
            break;
        }
        case 1:{
            //微信朋友圈
            type = ShareTypeWeixiTimeline;
            break;
        }
        case 2:{
            //QQ好友
            type = ShareTypeQQ;
            
            break;
        }
        case 3:{
            //新浪微博
            //QQ空间
            type = ShareTypeQQSpace;
            break;
        }
        default:
            break;
    }
    
    [lhColor sendMessageToWeiXinSession:type];
    
}

#pragma mark - 分享
+ (void)sendMessageToWeiXinSession:(NSInteger)shareType
{
    
    ShareType type = (ShareType)shareType;
    
    if(type == ShareTypeQQ || type == ShareTypeQQSpace){
        if (![QQApiInterface isQQInstalled]) {
            [lhColor showAlertWithMessage:@"请先安装QQ客户端~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    else if(type == ShareTypeWeixiSession || type == ShareTypeWeixiTimeline){
        if (![WXApi isWXAppInstalled]) {
            [lhColor showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
        if(![WXApi isWXAppSupportApi]){
            [lhColor showAlertWithMessage:@"微信版本不支持分享~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
            return;
        }
    }
    
    id<ISSContent> publishContent = [ShareSDK content:fxConStr defaultContent:nil image:[ShareSDK pngImageWithImage:fxImg] title:type==ShareTypeWeixiTimeline?fxConStr:@"每一公里，油其关心" url:fxUrlStr description:fxConStr mediaType:type==ShareTypeSinaWeibo?SSPublishContentMediaTypeText: SSPublishContentMediaTypeNews];
    
    [lhColor addActivityView:tempVC.view];
    
    //2.分享
    [ShareSDK shareContent:publishContent type:type authOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        [lhColor disAppearActivitiView:tempVC.view];
        
        //如果分享成功
        if (state == SSResponseStateSuccess) {
            ////NSLog(@"分享成功");
            
            [lhColor showAlertWithMessage:@"分享成功~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
        }
        else if (state == SSResponseStateFail) {//如果分享失败
            NSLog(@"分享失败,错误码:%ld,错误描述%@",(long)[error errorCode],[error errorDescription]);
            
            if ([error errorCode] == -22003) {
                [lhColor showAlertWithMessage:@"请先安装微信客户端~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            else if([error errorCode] == -22005){
                [lhColor showAlertWithMessage:@"取消分享~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            else{
                [lhColor showAlertWithMessage:@"分享失败~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            }
            
        }
        else if (state == SSResponseStateCancel) {
            [lhColor showAlertWithMessage:@"取消分享~" withSuperView:tempVC.view withHeih:DeviceMaxHeight/2];
            
        }
        
    }];
    
}

- (void)fxViewDisAppear
{
    UIView * grayV = [tempVC.view viewWithTag:fxBgViewTag];
    UIView * fxView = [tempVC.view viewWithTag:fxLowViewTag];
    [UIView animateWithDuration:0.2 animations:^{
        grayV.alpha = 0;
        fxView.frame = CGRectMake(0, DeviceMaxHeight, DeviceMaxWidth, 120*widthRate);
    }completion:^(BOOL finished) {
        [grayV removeFromSuperview];
        [fxView removeFromSuperview];
    }];
}

#pragma mark - touch ID验证
- (void)validateUser:(ValidateUserBlock)vub
{
    LAContext * context = [[LAContext alloc]init];
    NSError * error = nil;
    
    validateType vt = failValidate;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {//支持
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证指纹以完成支付" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                vub(vaSuccess);
            }
            else{
                switch (error.code) {
                    case LAErrorSystemCancel:{
                        
                        vub(userCancel);
                        break;
                    }
                    case LAErrorUserCancel:{
                        
                        vub(userCancel);
                        break;
                    }
                    case LAErrorUserFallback:{
                       
                        vub(usePasPay);
                        break;
                    }
                    default:{
                        vub(failValidate);
                        break;
                    }
                }
            }
            
        }];
    }
    else{//不支持
        NSLog(@"设备不支持");
        switch (error.code) {
                
            case LAErrorTouchIDNotEnrolled:
                
            {
                //未录入
                vt = usePasPay;
                break;
                
            }
                
            case LAErrorPasscodeNotSet:
                
            {
                //系统未设置密码
                vt = notSetPas;
                
                break;
                
            }
            case LAErrorTouchIDNotAvailable:
                
            {
                //未打开
                vt = usePasPay;
                
                break;
                
            }
            default:
                
            {
                //不支持
                vt = usePasPay;
                
                break;
                
            }
                
        }
        vub(vt);
    }
    
}

#pragma mark - 给tempVC赋值
+ (void)assignmentForTempVC:(UIViewController *)temp
{
    tempVC = temp;
}

+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize titleSize = [text sizeWithAttributes:attribute];
    
    return titleSize;
}

+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)mSize lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle};
    CGSize detailsLabelSize = [text boundingRectWithSize:mSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return detailsLabelSize;
}

+ (void)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font rect:(CGRect)rect forWidth:(CGFloat)forWidth fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    UIFont * tempFont = font;
    tempFont = [UIFont systemFontOfSize:fontSize];
    
    NSDictionary *attributes = @{NSFontAttributeName: tempFont, NSParagraphStyleAttributeName: paragraphStyle,NSBaselineOffsetAttributeName:[NSNumber numberWithFloat:1.0]};
    [text drawInRect:rect withAttributes:attributes];
    
}

+ (void)drawInRectWhenIOS7:(NSString *)text rect:(CGRect)rect font:(UIFont *)font
{
    
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    
}

- (UIView *)playVedio:(NSString *)url
{
    
//    if (onlyColor.movie) {
//        onlyColor.movie = nil;
//    }
    
//    onlyColor.movie = [onlyColor.movie retain];
    
    onlyColor.movie = [[MPMoviePlayerViewController alloc] initWithContentURL :[NSURL fileURLWithPath :[[ NSBundle mainBundle ] pathForResource:url ofType:@"mp4"]]];
    onlyColor.movie.moviePlayer.controlStyle = MPMovieControlStyleNone;
    [onlyColor.movie.view setFrame:CGRectMake(15*widthRate, 64+10*widthRate, DeviceMaxWidth-30*widthRate, 150*widthRate)];
    onlyColor.movie.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    onlyColor.movie.moviePlayer.scalingMode = MPMovieScalingModeNone;
    [onlyColor.movie.moviePlayer play];
    
    
    return onlyColor.movie.view;
}

@end
