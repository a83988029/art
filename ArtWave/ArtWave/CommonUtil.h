//
//  CommonUtil.h
//  ArtWave
//
//  Created by BossTiao on 14-8-7.
//  Copyright (c) 2014年 datatech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject


//读写文件，控制是否需要显示引导页
+ (int)readIntroducePlist;
+ (void)writeToIntroducePlist:(int)vl;

@end
