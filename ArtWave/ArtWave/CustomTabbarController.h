//
//  CustomTabbarController.h
//  ArtWave
//
//  Created by BossTiao on 14-8-8.
//  Copyright (c) 2014年 datatech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabbarController : UITabBarController {
    NSMutableArray *buttons;
    int currentSelectedIndex;
    UIImageView *slideBg;

}

@property (nonatomic,assign) int currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;



@end