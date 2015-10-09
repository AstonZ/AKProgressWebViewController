//
//  AKTimerProgressView.h
//  NormalTest
//
//  Created by Aston Z on 15/9/26.
//  Copyright © 2015年 Aston Z. All rights reserved.
//


/*****************************************************
 
 @Author             Aston
 
 @Function          webView的加载条
 
 @Remarks
 
 用法:
 
 _progressView = [[AKTimerProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
 [self.webView addSubview:_progressView];
 
 -(void)webViewDidStartLoad:(UIWebView *)webView
 {
 [self.progressView loadStart];
 }
 
 -(void)webViewDidFinishLoad:(UIWebView *)webView
 {
 [self.progressView loadFinished];
 }
 
 -(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
 {
 [self.progressView loadFaild];
 }
 
 
 -(void)dealloc {
 [_progressView loadInvalidStopActivity];
 }
 
 *****************************************************/

#import <UIKit/UIKit.h>

@interface AKTimerProgressView : UIView

@property (nonatomic, strong)UIColor *progressBarColor;

/** 载入结束 **/
- (void)loadFinished;

/** 刚开始载入 **/
- (void)loadStart;

/** 载入失败 **/
- (void)loadFaild;

//WebViewDealloc的时候调用
- (void)loadInvalidStopActivity;
@end
