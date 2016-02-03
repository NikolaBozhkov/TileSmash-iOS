//
//  AdManager.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/21/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

extern NSString *const AdViewActionSouldBeginNotification;
extern NSString *const AdShownNotification;
extern NSString *const AdHiddenNotification;

@interface AdManager : NSObject<ADBannerViewDelegate>

+ (instancetype) sharedManager;

@property (assign, nonatomic, readonly) BOOL isActive;

- (void) addAdBannerToView:(UIView *)view;

@end
