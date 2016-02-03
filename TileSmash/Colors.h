//
//  Colors.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/6/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Colors : NSObject

+ (Colors *) instance;

+ (SKColor *) yellowColor;
+ (SKColor *) redColor;
+ (SKColor *) greenColor;
+ (SKColor *) blueColor;
+ (SKColor *) purpleColor;
+ (SKColor *) orangeColor;

+ (SKColor *) gameSceneBackground;
+ (SKColor *) hudColor;
+ (SKColor *) specialTextColor;
+ (SKColor *) firstStageBlockedTilesBarColor;
+ (SKColor *) secondStageBlockedTilesBarColor;
+ (SKColor *) thirdStageBlockedTilesBarColor;

+ (SKColor *) messengerFontColor;

@property (strong, nonatomic, readonly) NSArray *values;

- (SKColor *) getRandomColor;

@end
