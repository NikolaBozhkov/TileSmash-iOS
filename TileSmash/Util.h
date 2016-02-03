//
//  Util.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/2/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

static const CGFloat MarginPercent = 0.016;
CGFloat Margin;
NSInteger ScreenWidth;
NSInteger ScreenHeight;

static const CGFloat ButtonHighlightScale = 0.95;

static const CGFloat MaxMusicVolume = 0.7;
static const CGFloat DefaultMusicVolume = 0.5;
static NSString *const MusicVolumeKey = @"MusicVolume";

static const BOOL DefaultSfxOn = YES;
static NSString *const SfxOnKey = @"SfxOn";

static const BOOL DefaultTutorialOn = YES;
static NSString *const TutorialOnKey = @"TutorialOn";

static NSString *const MenuBackgroundMusicName = @"menu_background";
static NSString *const GameplayMusicName = @"gameplay";

static const NSTimeInterval InitialColorChangeTime = 6.0;
static const NSTimeInterval BlockedTileTimeDrop = 0.3;
static const NSTimeInterval TimeDropOverTime = 0.1;
static const NSTimeInterval TimeDropStartTime = 240;
static const NSTimeInterval TimeDropTimeInterval = 20;
static const NSTimeInterval TimeDropMax = 1.0;
static const NSUInteger MaxBlockedTiles = 10;

static const NSUInteger StreakStartAfterRounds = 2;
static const NSUInteger StreakStartBonus = 5;
static const NSUInteger StreakBonusMax = 200;

static NSString *const MainFont = @"Carter One";
static NSString *const SpecialFont = @"GoodDog Plain";
static NSString *const ButtonTapSFXName = @"bloop";
static NSString *const GameTitle = @"Tile Smash";

@interface Util : NSObject

+ (SKLabelNode *) labelWithFont:(NSString *)font text:(NSString *)text fontColor:(SKColor *)color fontSize:(NSInteger)fontSize;
+ (void) adjustFontSizeOfLabel:(SKLabelNode *)label byWidth:(CGFloat)width;

@end
