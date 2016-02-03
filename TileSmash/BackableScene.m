//
//  BackableScene.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 9/15/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "AdAdjustableScene+Protected.h"
#import "BackableScene.h"
#import "Util.h"
#import "AdManager.h"   
#import "ImageNames.h"

static const CGFloat BackButtonXPercent = 0.06;

@implementation BackableScene

@synthesize backButton = _backButton;

- (void) didMoveToView:(SKView *)view {
    _backButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames backButton] highlightScale:ButtonHighlightScale];
    CGFloat backButtonX = ScreenWidth * BackButtonXPercent;
    _backButton.anchorPoint = CGPointZero;
    _backButton.position = CGPointMake(backButtonX, backButtonX);
    if ([AdManager sharedManager].isActive) {
        [self adjustForAd];
    }
    
    [self addChild:_backButton];
}

@end
