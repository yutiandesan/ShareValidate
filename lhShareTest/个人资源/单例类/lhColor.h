//
//  lhColor.h
//  lhShareTest
//
//  Created by bosheng on 15/11/20.
//  Copyright © 2015年 yutiandesan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MediaPlayer/MediaPlayer.h>

//touch ID状态
typedef enum : NSUInteger {
    vaSuccess=1,
    userCancel,
    failValidate,
    notSetPas,
    usePasPay,
} validateType;

typedef void (^ ValidateUserBlock)(validateType vt);//验证block

@interface lhColor : NSObject

@property (nonatomic,strong)MPMoviePlayerViewController * movie;

+ (instancetype)shareColor;//单例

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;//获取颜色
+ (void)assignmentForTempVC:(UIViewController *)temp;

//正在加载，有黑底
+ (void)addActivityView:(UIView *)view;
+ (void)disAppearActivitiView:(UIView *)view;

//分享
+ (void)fxViewAppear:(UIImage *)Img conStr:(NSString *)cStr withUrlStr:(NSString *)urlStr;

/**
 *指纹验证（touch ID）
 */
- (void)validateUser:(ValidateUserBlock)vub;

/**
 *提示显示
 */
+ (void)showAlertWithMessage:(NSString *)message withSuperView:(UIView *)superView withHeih:(CGFloat)heih;

/**
 *拨打电话
 */
- (void)detailPhone:(NSString *)phone;

/**
 *sizeWithFont替换
 */
+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font;

/**
 *sizeWithFont: constrainedToSize: lineBreakMode: 替换
 */
+ (CGSize)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)mSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *drawAtPoint:
 forWidth:
 withFont:
 fontSize:
 lineBreakMode:
 baselineAdjustment:替换
 */
+ (void)sizeWithFontWhenIOS7:(NSString *)text font:(UIFont *)font rect:(CGRect)rect forWidth:(CGFloat)forWidth fontSize:(CGFloat)fontSize lineBreakMode:(NSLineBreakMode)lineBreakMode baselineAdjustment:(UIBaselineAdjustment)baselineAdjustment;

/**
 *drawInRect:(CGRect)rect withFont:替换
 */
+ (void)drawInRectWhenIOS7:(NSString *)text rect:(CGRect)rect font:(UIFont *)font;

/**
 *aa
 */
- (UIView *)playVedio:(NSString *)url;

@end
