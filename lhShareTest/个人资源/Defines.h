//
//  Defines.h
//  lhShareTest
//
//  Created by bosheng on 15/11/20.
//  Copyright © 2015年 yutiandesan. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320

//初始化图片
#define imageWithName(name) [UIImage imageNamed:name]

//字体
#define nowFontName @"ArialMT"
#define contentTitleColorStr @"666666" //正文颜色较深

#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

//微信AppID
//#error 请用自己的微信appID
#define WeiXinAppID @"wx83c55ff5f2e5b"

#endif /* Defines_h */
