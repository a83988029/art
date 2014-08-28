//
//  ViewController.m
//  ArtWave
//
//  Created by BossTiao on 14-8-7.
//  Copyright (c) 2014年 datatech. All rights reserved.
//

#import "ViewController.h"
#import "CommonUtil.h"
#import "UIImageView+WebCache.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelAccessToken;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getnoti:) name:@"test" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1101987694" andDelegate:self];
    _permissions =  [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil];

}

-(void)getnoti:(NSNotification*)noti{
    _labelAccessToken.text = [noti.userInfo objectForKey:@"url"];


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
    _tencentOAuth.openId = [[NSUserDefaults standardUserDefaults] valueForKey:@"openid"];
    _tencentOAuth.expirationDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"expireDate"];
    _tencentOAuth.accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accesstoken"];

    if ([_tencentOAuth isSessionValid]) {
        [_tencentOAuth getUserInfo];
//分享文本
        QQApiTextObject *sendObj = [QQApiTextObject objectWithText:@"啦啦啦"];
//分享链接
//        QQApiURLObject *sendurlObj = [QQApiURLObject objectWithURL:<#(NSURL *)#> title:<#(NSString *)#> description:<#(NSString *)#> previewImageData:<#(NSData *)#> targetContentType:<#(QQApiURLTargetType)#>];
//分享视频
//        QQApiVideoObject *sendVideoObj = [QQApiVideoObject objectWithURL:<#(NSURL *)#> title:<#(NSString *)#> description:<#(NSString *)#> previewImageData:<#(NSData *)#> targetContentType:<#(QQApiURLTargetType)#>];

        SendMessageToQQReq *message = [SendMessageToQQReq reqWithContent:sendObj];
        QQApiSendResultCode *result = [QQApiInterface sendReq:message];
        //处理分享结果
        NSLog(@"result:%d",result);

    }else{
        [_tencentOAuth authorize:_permissions inSafari:NO];
    }

}

- (void)tencentDidLogin{
    _labelTitle.text = @"登录完成";

    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        _labelAccessToken.text = _tencentOAuth.accessToken;

        NSString *openid = _tencentOAuth.openId;
        NSDate *expireDate = _tencentOAuth.expirationDate;


        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:openid forKey:@"openid"];
        [userDefault setObject:_labelAccessToken.text forKey:@"accesstoken"];
        [userDefault setObject:expireDate forKey:@"expireDate"];
        [userDefault synchronize];

    }
    else
    {
        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }

}


/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@"%@",response);
    NSURL *headImageUrl_100 = [NSURL URLWithString:[response.jsonResponse objectForKey:@"figureurl_qq_2"]];
    [_headImage sd_setImageWithURL:headImageUrl_100 placeholderImage:[UIImage imageNamed:@"default_head_small"]];

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
