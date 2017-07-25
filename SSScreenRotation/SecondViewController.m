//
//  SecondViewController.m
//  SSScreenRotation
//
//  Created by swifterfit on 2017/7/25.
//  Copyright © 2017年 swifterfit. All rights reserved.
//

#import "SecondViewController.h"
#import "UIViewController+ScreenRotation.h"

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *urlString = @"https://cn.bing.com/videos/search?q=%E5%AD%99%E6%9D%A8%E7%A2%BE%E5%8E%8B%E5%A4%8D%E4%BB%87%E9%9C%8D%E9%A1%BF&FORM=VSTREQ";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    
#warning 暂时解决webview全屏播放视频status bar问题
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UIWindowDidRotateNotification" object:nil queue:nil usingBlock:^(NSNotification *note) {
        if ([note.userInfo[@"UIWindowOldOrientationUserInfoKey"] intValue] >= 3) {
            self.navigationController.navigationBar.frame = (CGRect){0, 0, self.view.frame.size.width, 64};
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"UIWindowDidRotateNotification"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
