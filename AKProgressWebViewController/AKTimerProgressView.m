//
//  AKTimerProgressView.m
//  NormalTest
//
//  Created by Aston Z on 15/9/26.
//  Copyright © 2015年 Aston Z. All rights reserved.
//


#import "AKTimerProgressView.h"

CGFloat const kProgressFirstStopValue = 0.3f;
CGFloat const kProgressSeconTopValue = 0.85f;

CGFloat const kProgressLargeStepValue = 0.005f;
CGFloat const kProgressSmallStepValue = 0.002f;

@interface AKTimerProgressView ()
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) CADisplayLink *dispayTimer;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation AKTimerProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"progress gone");
}


- (void)buildUI
{
    CGRect bounds = self.bounds;
    _progressView = [[UIProgressView alloc] initWithFrame:bounds];
    _progressView.trackTintColor = [UIColor lightGrayColor];
    _progressView.progressTintColor = [UIColor magentaColor];
    _progressView.progress   = 0.f;
    _progressView.transform = CGAffineTransformMakeScale(1.f, 3.f);
    [_progressView addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:_progressView];
}


#pragma mark -
#pragma mark ---------KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"]) {
//         NSLog(@"change %@",change);
        float new = [change[@"new"] floatValue];
        if (new == 1.f) {
            typeof(self) wkSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (wkSelf) {
                    if (wkSelf.progressView.hidden == NO && wkSelf.progressView.progress >= 0.95 && wkSelf.isLoading == NO) {
                        wkSelf.progressView.hidden = YES;
                    }
                }
            });
        }
    }
}


#pragma mark -
#pragma mark ---------Public Interfaces

/** 载入结束 **/
- (void)loadFinished
{
    _isLoading = NO;
    [self stopTimerAction];
    [_progressView setProgress:1.f animated:NO];
}



/** 刚开始载入 **/
- (void)loadStart
{
    _isLoading = YES;
    self.progressView.hidden = NO;
    self.progressView.progress = 0.f;
    [self startTimerAction];
}

//WebViewDealloc的时候调用
- (void)loadInvalidStopActivity
{
    [_progressView removeObserver:self forKeyPath:@"progress"];
    [self stopTimerAction];
}

- (void)loadFaild
{
    _isLoading = NO;
    self.progressView.hidden = YES;
    self.progressView.progress = 0.f;
    [self stopTimerAction];
}

- (void)setProgressBarColor:(UIColor *)progressBarColor
{
    if (progressBarColor != nil) {
        _progressBarColor = progressBarColor;
        self.progressView.progressTintColor = progressBarColor;
    }
}

#pragma mark -
#pragma mark ---------Private Methods

- (void)startTimerAction
{
    if (_dispayTimer == nil) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(actionTimer)];
        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        link.frameInterval = 2;//20帧 要求不要那么高
        _dispayTimer = link;
    }
    
    if (_dispayTimer.isPaused == YES) {
        _dispayTimer.paused = NO;
    }
}

- (void)stopTimerAction
{
    if (_dispayTimer.isPaused == NO) {
        _dispayTimer.paused = YES;
    }
    if (_dispayTimer) {
        [_dispayTimer invalidate];//自动从runloop移除
        _dispayTimer = nil;
    }
}


- (void)actionTimer
{
    float curValue = self.progressView.progress;
    
    //前期快速加载一段
    if (curValue <= kProgressFirstStopValue) {
        curValue += kProgressLargeStepValue;
        [self.progressView setProgress:curValue animated:NO];
        return;
    }
    
    //中间慢慢加载
    curValue+=kProgressSmallStepValue;
    if (curValue < kProgressSeconTopValue) {
        [self.progressView setProgress:curValue animated:NO];
    }else{
        [self stopTimerAction];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
