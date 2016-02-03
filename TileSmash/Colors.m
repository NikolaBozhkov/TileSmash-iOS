//
//  Colors.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/6/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "Colors.h"

@interface Colors ()

@property (strong, nonatomic) NSArray *values;

@end

@implementation Colors

- (instancetype) init {
    if (self = [super init]) {
        self.values = [NSArray arrayWithObjects:[Colors yellowColor],
                                                [Colors redColor],
                                                [Colors greenColor],
                                                [Colors blueColor],
                                                [Colors purpleColor],
                                                nil];
    }
    
    return self;
}

+ (instancetype) instance {
    static Colors *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (SKColor *) yellowColor {
    static SKColor *_yellowColor = nil;
    
    if (_yellowColor == nil) {
        _yellowColor = [SKColor colorWithRed:220.0 / 255 green:206.0 / 255 blue:4.0 / 255  alpha:1.0];// Original -20
    }
    
    return _yellowColor;
}

+ (SKColor *) redColor {
    static SKColor *_redColor = nil;
    
    if (_redColor == nil) {
        _redColor = [SKColor colorWithRed:217.0 / 255 green:30.0 / 255 blue:24.0 / 255  alpha:1.0]; // Thunder bird
    }
    
    return _redColor;
}

+ (SKColor *) greenColor {
    static SKColor *_greenColor = nil;
    
    if (_greenColor == nil) {
        _greenColor = [SKColor colorWithRed:59.0 / 255 green:180.0 / 255 blue:74.0 / 255  alpha:1.0];
    }
    
    return _greenColor;
}

+ (SKColor *) blueColor {
    static SKColor *_blueColor = nil;
    
    if (_blueColor == nil) {
        _blueColor = [SKColor colorWithRed:9.0 / 255 green:115.0 / 255 blue:185.0 / 255  alpha:1.0];
    }
    
    return _blueColor;
}

+ (SKColor *) purpleColor {
    static SKColor *_purpleColor = nil;
    
    if (_purpleColor == nil) {
        _purpleColor = [SKColor colorWithRed:142.0 / 255 green:68.0 / 255 blue:173.0 / 255  alpha:1.0]; // Studio
    }
    
    return _purpleColor;
}

+ (SKColor *) orangeColor {
    static SKColor *_orangeColor = nil;
    
    if (_orangeColor == nil) {
        _orangeColor = [SKColor colorWithRed:232.0 / 255 green:106.0 / 255 blue:23.0 / 255  alpha:1.0];
    }
    
    return _orangeColor;
}

+ (SKColor *) gameSceneBackground {
    static SKColor *_gameSceneBackground = nil;
    
    if (_gameSceneBackground == nil) {
        _gameSceneBackground = [SKColor colorWithRed:236.0 / 255 green:240.0 / 255 blue:241.0 / 255 alpha:1.0];
    }
    
    return _gameSceneBackground;
}

+ (SKColor *) hudColor {
    static SKColor *_hudColor = nil;
    
    if (_hudColor == nil) {
        _hudColor = [SKColor colorWithRed:69.0 / 255 green:79.0 / 255 blue:86.0 / 255  alpha:1.0]; // grey-blue
    }
    
    return _hudColor;
}

+ (SKColor *) specialTextColor {
    static SKColor *_specialTextColor = nil;
    
    if (_specialTextColor == nil) {
        _specialTextColor = [SKColor colorWithRed:30.0 / 255 green:167.0 / 255 blue:225.0 / 255 alpha:1.0];
    }
    
    return _specialTextColor;
}

+ (SKColor *) firstStageBlockedTilesBarColor {
    static SKColor *_firstStageBlockedTilesBarColor = nil;
    
    if (_firstStageBlockedTilesBarColor == nil) {
        _firstStageBlockedTilesBarColor = [SKColor greenColor];
    }
    
    return _firstStageBlockedTilesBarColor;
}

+ (SKColor *) secondStageBlockedTilesBarColor {
    static SKColor *_secondStageBlockedTilesBarColor = nil;
    
    if (_secondStageBlockedTilesBarColor == nil) {
        _secondStageBlockedTilesBarColor = [SKColor orangeColor];
    }
    
    return _secondStageBlockedTilesBarColor;
}

+ (SKColor *) thirdStageBlockedTilesBarColor {
    static SKColor *_thirdStageBlockedTilesBarColor = nil;
    
    if (_thirdStageBlockedTilesBarColor == nil) {
        _thirdStageBlockedTilesBarColor = [SKColor redColor];
    }
    
    return _thirdStageBlockedTilesBarColor;
}

+ (SKColor *) messengerFontColor {
    static SKColor *_messengerFontColor = nil;
    
    if (_messengerFontColor == nil) {
        _messengerFontColor = [SKColor colorWithRed:81.0 / 255 green:81.0 / 255 blue:81.0 / 255 alpha:1.0];
    }
    
    return _messengerFontColor;
}

- (SKColor *) getRandomColor {
    return self.values[arc4random_uniform((uint)self.values.count)];
}

@end
