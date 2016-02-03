//
//  StatsScene.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/9/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "AdAdjustableScene+Protected.h"
#import "StatsScene.h"
#import "Util.h"
#import "TextureAtlases.h"
#import "PlayerProfile.h"
#import "HighlightSpriteNode.h"
#import "MusicManager.h"
#import "HomeScene.h"
#import "AdManager.h"
#import "ImageNames.h"

static const CGFloat StatsTitleYPercent = 0.9;
static const CGFloat TopLabelYPercent = 0.8;
static const CGFloat LabelMarginXPercent = 0.06;
static const CGFloat LabelMarginYPercent = 0.025;
static const CGFloat FontSizePercent = 0.06;
static const CGFloat BackButtonXPercent = 0.06;

@implementation StatsScene

@synthesize backButton = _backButton;

- (void) didMoveToView:(SKView *)view {
    [self placeBackgroundImage];
    
    _backButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames backButton] highlightScale:ButtonHighlightScale];
    CGFloat backButtonX = ScreenWidth * BackButtonXPercent;
    _backButton.anchorPoint = CGPointZero;
    _backButton.position = CGPointMake(backButtonX, backButtonX);
    if ([AdManager sharedManager].isActive) {
        [self adjustForAd];
    }
    
    [self addChild:_backButton];
    
    CGFloat fontSize = ScreenWidth * FontSizePercent;
    CGFloat labelMarginX = ScreenWidth * LabelMarginXPercent;
    CGFloat labelMarginY = ScreenHeight * LabelMarginYPercent;
    
    // Best Score
    SKLabelNode *bestScoreLabel = [self createLabelWithText:@"Best Score:" font:MainFont fontSize:fontSize];
    bestScoreLabel.position = CGPointMake(labelMarginX, ScreenHeight * TopLabelYPercent);
    [self addChild:bestScoreLabel];
    
    NSString *bestScoreStr = [NSString stringWithFormat:@"%ld", (long)[PlayerProfile sharedInstance].bestScore];
    SKLabelNode *bestScore = [self createLabelWithText:bestScoreStr font:MainFont fontSize:fontSize];
    bestScore.position = CGPointMake(ScreenWidth - labelMarginX - bestScore.frame.size.width, bestScoreLabel.position.y);
    [self addChild:bestScore];
    
    // Most Tiles Smashed
    SKLabelNode *mostTilesLabel = [self createLabelWithText:@"Most Tiles Smashed:" font:MainFont fontSize:fontSize];
    mostTilesLabel.position = CGPointMake(labelMarginX, bestScoreLabel.position.y - bestScoreLabel.frame.size.height - labelMarginY);
    [self addChild:mostTilesLabel];
    
    NSString *mostTilesStr = [NSString stringWithFormat:@"%ld", (long)[PlayerProfile sharedInstance].mostTilesDestroyed];
    SKLabelNode *mostTiles = [self createLabelWithText:mostTilesStr font:MainFont fontSize:fontSize];
    mostTiles.position = CGPointMake(ScreenWidth - labelMarginX - mostTiles.frame.size.width, mostTilesLabel.position.y);
    [self addChild:mostTiles];
    
    // Top Streak
    SKLabelNode *topStreakLabel = [self createLabelWithText:@"Top Streak:" font:MainFont fontSize:fontSize];
    topStreakLabel.position = CGPointMake(labelMarginX, mostTilesLabel.position.y - mostTilesLabel.frame.size.height - labelMarginY);
    [self addChild:topStreakLabel];
    
    NSString *topStreakStr = [NSString stringWithFormat:@"%ld", (long)[PlayerProfile sharedInstance].topStreak];
    SKLabelNode *topStreak = [self createLabelWithText:topStreakStr font:MainFont fontSize:fontSize];
    topStreak.position = CGPointMake(ScreenWidth - labelMarginX - topStreak.frame.size.width, topStreakLabel.position.y);
    [self addChild:topStreak];
    
    // Longest Game Time
    SKLabelNode *longestGameLabel = [self createLabelWithText:@"Longest Game:" font:MainFont fontSize:fontSize];
    longestGameLabel.position = CGPointMake(labelMarginX, topStreakLabel.position.y - topStreakLabel.frame.size.height - labelMarginY + 3);
    [self addChild:longestGameLabel];
    
    NSString *longestGameStr = [NSString stringWithFormat:@"%@", [self formatTimeInterval:[PlayerProfile sharedInstance].longestGameTime]];
    SKLabelNode *longestGame = [self createLabelWithText:longestGameStr font:MainFont fontSize:fontSize];
    longestGame.position = CGPointMake(ScreenWidth - labelMarginX - longestGame.frame.size.width, longestGameLabel.position.y);
    [self addChild:longestGame];
    
    // Total Game Time
    SKLabelNode *totalGameTimeLabel = [self createLabelWithText:@"Total Game Time:" font:MainFont fontSize:fontSize];
    totalGameTimeLabel.position = CGPointMake(labelMarginX, longestGameLabel.position.y - longestGameLabel.frame.size.height - labelMarginY + 3);
    [self addChild:totalGameTimeLabel];
    
    NSString *totalGameTimeStr = [NSString stringWithFormat:@"%@", [self formatTimeInterval:[PlayerProfile sharedInstance].totalGameTime]];
    SKLabelNode *totalGameTime = [self createLabelWithText:totalGameTimeStr font:MainFont fontSize:fontSize];
    totalGameTime.position = CGPointMake(ScreenWidth - labelMarginX - totalGameTime.frame.size.width, totalGameTimeLabel.position.y);
    [self addChild:totalGameTime];
}

- (SKLabelNode *) createLabelWithText:(NSString *)text font:(NSString *)font fontSize:(CGFloat)fontSize {
    SKLabelNode *label = [Util labelWithFont:font text:text fontColor:[SKColor whiteColor] fontSize:fontSize];
    label.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    return label;
}

- (NSString *) formatTimeInterval:(NSTimeInterval)interval {
    unsigned int seconds = (unsigned int)round(interval);
    NSString *string = [NSString stringWithFormat:@"%u:%02u:%02u", seconds / 3600, (seconds / 60) % 60, seconds % 60];
    return string;
}

- (void) placeBackgroundImage {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:[ImageNames stripesBackground]];
    background.anchorPoint = CGPointZero;
    background.zPosition = -1;
    [self addChild:background];
    
    SKSpriteNode *statsTitle = [SKSpriteNode spriteNodeWithTexture:[[TextureAtlases mainAtlas] textureNamed:[ImageNames statsLabel]]];
    statsTitle.position = CGPointMake(ScreenWidth / 2, ScreenHeight * StatsTitleYPercent);
    [self addChild:statsTitle];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    if ([_backButton containsPoint:location]) {
        [_backButton highlight];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    if ([_backButton containsPoint:location]) {
        [_backButton highlight];
    } else {
        [_backButton unhighlight];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    if ([_backButton containsPoint:location]) {
        [[MusicManager sharedManager] playSoundSFX:ButtonTapSFXName ofType:@"wav"];
        HomeScene *scene = [HomeScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

@end
