//
//  ViewController.h
//  ArtWave
//
//  Created by BossTiao on 14-8-7.
//  Copyright (c) 2014年 datatech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYBlurIntroductionView.h"
#import "TencentOpenAPI.framework/Headers/TencentOpenSDK.h"

@class TencentOAuth;
@interface ViewController : UIViewController<MYIntroductionDelegate,TencentSessionDelegate>
@property (nonatomic,strong)TencentOAuth *tencentOAuth;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (nonatomic,strong)NSArray *permissions;
@end
