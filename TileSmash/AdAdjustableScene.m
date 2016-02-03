//
//  AdAdjustableScene.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/24/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "AdAdjustableScene.h"
#import "AdAdjustableScene+Protected.h"
#import "AdManager.h"

@implementation AdAdjustableScene

- (instancetype) initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustForAd) name:AdShownNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustToOriginal) name:AdHiddenNotification object:nil];
    }
    
    return self;
}

- (void) adjustForAd {
    self.backButton.position = CGPointMake(self.backButton.position.x, self.backButton.position.y + 50);
}

- (void) adjustToOriginal {
    self.backButton.position = CGPointMake(self.backButton.position.x, self.backButton.position.x);
}

- (void) removeObeservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) willMoveFromView:(SKView *)view {
    [self removeObeservers];
}

@end
