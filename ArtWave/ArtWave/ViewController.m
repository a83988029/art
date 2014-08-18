//
//  ViewController.m
//  ArtWave
//
//  Created by BossTiao on 14-8-7.
//  Copyright (c) 2014年 datatech. All rights reserved.
//

#import "ViewController.h"
#import "CommonUtil.h"
#import "TencentOpenAPI.framework/Headers/TencentOpenSDK.h"

@interface ViewController ()<TencentSessionDelegate>
@property (nonatomic,strong)TencentOAuth *tencentOAuth;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAccessToken;
@property (nonatomic,strong)NSArray *permissions;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1101987694" andDelegate:self];
    _permissions =  [NSArray arrayWithObjects:@"get_user_info",  nil];


}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if ([CommonUtil readIntroducePlist] == 1) {
        if (SCREEN_HEIGHT<568) {
            [self buildIntro480];
        }
        else{
            [self buildIntro568];
        }

        [CommonUtil writeToIntroducePlist:0];
    }

}

- (IBAction)qqlogin:(UIButton *)sender {
    [_tencentOAuth authorize:_permissions inSafari:NO];

}

- (void)tencentDidLogin{
    _labelTitle.text = @"登录完成";

    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        _labelAccessToken.text = _tencentOAuth.accessToken;
    }
    else
    {
        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled)
    {
        _labelTitle.text = @"用户取消登录";
    }
    else
    {
        _labelTitle.text = @"登录失败";
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{

    _labelTitle.text=@"无网络连接，请设置网络";
}

#pragma mark - Build MYBlurIntroductionView
-(void)buildIntro568{

    //Create Panel From Nib
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-568h-1"];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-568h-2"];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-568h-3"];
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-568h-4"];
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3, panel4];

    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;

    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];

    //Add the introduction to your view
    [self.view addSubview:introductionView];
}
-(void)buildIntro480{

    //Create Panel From Nib
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-480h-1"];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-480h-2"];
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-480h-3"];
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"introPage-480h-4"];
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3, panel4];

    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
//    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;

    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];

    //Add the introduction to your view
    [self.view addSubview:introductionView];
}

#pragma mark - MYIntroduction Delegate

-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %d", panelIndex);


}

-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    NSLog(@"Introduction did finish");
}


@end
