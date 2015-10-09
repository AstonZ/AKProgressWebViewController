//
//  WebViewController.m
//  AKProgressWebViewController
//
//  Created by 张良 on 15/10/9.
//  Copyright © 2015年 Aston. All rights reserved.
//

#import "WebViewController.h"
#import "AKTimerProgressView.h"
//调试输出
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]\n""[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif
@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) AKTimerProgressView *progressView;


@end

@implementation WebViewController


-(void)dealloc {
    [_progressView loadInvalidStopActivity];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _progressView = [[AKTimerProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    [self.webView addSubview:_progressView];
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.webView loadRequest:request];
    
    //这个可以防止空白页面左右拖动webView出现的黑色框框
    _webView.opaque = NO;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"");

    [self.progressView loadStart];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"");
    [self.progressView loadFinished];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error) {
         DLog(@"Error: %@", error);

    }
    [self.progressView loadFaild];
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
