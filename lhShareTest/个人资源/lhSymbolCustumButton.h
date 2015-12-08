//
//  lhSymbolCustumButton.h
//  Drive
//
//  Created by bosheng on 15/7/29.
//  Copyright (c) 2015年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义按钮
@interface lhSymbolCustumButton : UIButton

@property (nonatomic,strong)UIImageView * tImgView;//图片
@property (nonatomic,strong)UILabel * tLabel;//按钮名字

- (instancetype)initWithFrame1:(CGRect)frame;

@end
