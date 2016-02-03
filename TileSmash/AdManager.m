//
//  AdManager.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/21/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "AdManager.h"
#import "Util.h"
#import "MusicManager.h"

static const NSTimeInterval AdFadeDuration = 0.5;
NSString *const AdViewActionSouldBeginNotification = @"AdViewActionSouldBegin";
NSString *const AdShownNotification = @"AdShown";
NSString *const AdHiddenNotification = @"AdHidden";

@interface AdManager ()

@property (assign, nonatomic) BOOL isActive;
@end

@implementation AdManager {
    ADBannerView *_adBanner;
}

- (instancetype) init {
    if (self = [super init]) {
        _adBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        _adBanner.frame = CGRectMake(0, ScreenHeight - _adBanner.frame.size.height, _adBanner.frame.size.width, _adBanner.frame.size.height);
        _adBanner.alpha = 0.0;
        _adBanner.delegate = self;
    }
    
    return self;
}

+ (instancetype) sharedManager {
    static AdManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AdManager alloc] init];
    });
    
    return sharedManager;
}

- (void) addAdBannerToView:(UIView *)view {
    [view addSubview:_adBanner];
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_isActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AdShownNotification object:nil];
        [UIView animateWithDuration:AdFadeDuration animations:^{
            _adBanner.alpha = 1;
        }];
        
        _isActive = YES;
    }
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (_isActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AdHiddenNotification object:nil];
        [UIView animateWithDuration:AdFadeDuration animations:^{
            _adBanner.alpha = 0;
        }];
        
        _isActive = NO;
    }
}

- (BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [[NSNotificationCenter defaultCenter] postNotificationName:AdViewActionSouldBeginNotification object:nil];
    [[MusicManager sharedManager] pauseBackgroundMusic];
    return YES;
}

- (void) bannerViewActionDidFinish:(ADBannerView *)banner {
    [[MusicManager sharedManager] resumeBackgroundMusic];
}

@end
