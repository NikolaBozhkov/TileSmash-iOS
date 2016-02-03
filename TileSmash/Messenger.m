//
//  Messenger.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/24/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "Messenger.h"
#import "Util.h"
#import "GameGridNode.h"

static const CGFloat ScaleFrom = 0.5;
static const CGFloat ScaleTo = 1.1;
static const NSTimeInterval ScaleToDuration = 0.2;
static const NSTimeInterval ScaleToNormalDuration = 0.1;

static const NSTimeInterval ShowDuration = 0.6;
static const CGFloat MessageMarginPercent = 0.012;

@implementation Messenger

+ (instancetype) messengerWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize color:(SKColor *)color {
    Messenger *messenger = [Messenger new];
    
    messenger.fontName = fontName;
    messenger.fontSize = fontSize;
    messenger.color = color;
    
    return messenger;
}

+ (NSTimeInterval) messageDuration {
    return ScaleToDuration + ScaleToNormalDuration + ShowDuration;
}

+ (SKAction *) scaleAnimation {
    static SKAction *_scaleAnimation = nil;
    
    if (_scaleAnimation == nil) {
        NSArray *sequence = @[[SKAction scaleTo:ScaleFrom duration:0],
                              [SKAction scaleTo:ScaleTo duration:ScaleToDuration],
                              [SKAction scaleTo:1 duration:ScaleToNormalDuration],
                              [SKAction waitForDuration:ShowDuration],
                              [SKAction removeFromParent]];
        _scaleAnimation = [SKAction sequence:sequence];
    }
    
    return _scaleAnimation;
}

- (void) showMessageWithText:(NSString *)text scene:(SKScene *)scene {
    SKLabelNode *message = [Util labelWithFont:_fontName text:text fontColor:_color fontSize:_fontSize];
    message.position = CGPointMake(ScreenWidth / 2, ScreenHeight * (GameGridYPercent + MessageMarginPercent));
    
    [scene addChild:message];
    [message runAction:[Messenger scaleAnimation]];
}

@end

