//
//  Messenger.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/24/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Messenger : NSObject

+ (instancetype) messengerWithFontName:(NSString *)fontName fontSize:(CGFloat)fontSize color:(SKColor *)color;

@property (strong, nonatomic) NSString *fontName;
@property (assign, nonatomic) CGFloat fontSize;
@property (strong, nonatomic) SKColor *color;

+ (NSTimeInterval) messageDuration;
- (void) showMessageWithText:(NSString *)text scene:(SKScene *)scene;

@end
