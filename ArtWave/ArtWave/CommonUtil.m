//
//  CommonUtil.m
//  ArtWave
//
//  Created by BossTiao on 14-8-7.
//  Copyright (c) 2014年 datatech. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil





/**
 *  readIntroducePlist 读取plist
 *
 *  @return 1:需要展示引导界面 0:不需要展示引导界面
 */
+ (int)readIntroducePlist {
    int bl;

    NSFileManager *fm = [NSFileManager defaultManager];

    //找到Documents文件所在的路径

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    //取得第一个Documents文件夹的路径

    NSString *filePath = [path objectAtIndex:0];

    //把Plist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"introduce.plist"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    //开始创建文件
    if (![fm fileExistsAtPath:plistPath]) {
        bl = 1;

        //在沙盒创建plist文件，并写入版本号以及是否需要引导界面
        [fm createFileAtPath:plistPath contents:nil attributes:nil];

        NSDictionary *dics =[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"introduceImage",version,@"version", nil];

        //把数据写入plist文件
        [dics writeToFile:plistPath atomically:YES];
    } else {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        NSString *storeVersion = [dic objectForKey:@"version"];

        if ([storeVersion isEqualToString:version]) {//同一个版本

            bl = [[dic objectForKey:@"introduceImage"] intValue];

        } else {//新版本

            bl=1;
            NSDictionary *dics =[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"introduceImage",version,@"version", nil];

            //把数据写入plist文件
            [dics writeToFile:plistPath atomically:YES];
        }
    }

    return bl;
}

/**
 *  writeToIntroducePlist
 *
 *  @param vl
 */
+ (void)writeToIntroducePlist:(int)vl {

    NSFileManager *fm = [NSFileManager defaultManager];

    //找到Documents文件所在的路径

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    //取得第一个Documents文件夹的路径

    NSString *filePath = [path objectAtIndex:0];

    //把Plist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"introduce.plist"];

    //开始创建文件
    if (![fm fileExistsAtPath:plistPath]) {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"introduceImage",@"1", nil];

        //把数据写入plist文件
        [dic writeToFile:plistPath atomically:YES];
    } else {
        NSMutableDictionary *introduceDic = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        NSNumber *number = [NSNumber numberWithInt:vl];
        [introduceDic setValue:number forKey:@"introduceImage"];
        [introduceDic writeToFile:plistPath atomically:YES];
    }
}

@end
