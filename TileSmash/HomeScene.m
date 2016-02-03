//
//  HomeScene.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/15/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "HomeScene.h"
#import "GameScene.h"
#import "OptionsScene.h"
#import "Util.h"
#import "MusicManager.h"
#import "HighlightSpriteNode.h"
#import "StatsScene.h"
#import "TutorialScene.h"
#import "AdManager.h"
#import "ImageNames.h"

NSString *const ShowLeaderboardNotification = @"ShowLeaderboard";

static const CGFloat TopButtonYPercent = 0.78;
static const CGFloat ButtonMarginPercent = 0.023;
static const CGFloat SideButtonInsetPercent = 0.055;

@implementation HomeScene {
    HighlightSpriteNode *_playButton;
    HighlightSpriteNode *_optionsButton;
    HighlightSpriteNode *_leaderboardButton;
    HighlightSpriteNode *_statsButton;
    HighlightSpriteNode *_tutorialButton;
    NSSet *_buttons;
}

- (void) didMoveToView:(SKView *)view {
    [[MusicManager sharedManager] playBackgroundMusic:MenuBackgroundMusicName ofType:@"mp3" numberOfLoops:-1];
    [self placeBackgroundImage];

    CGFloat buttonMargin = ScreenHeight * ButtonMarginPercent;
    CGFloat centerX = ScreenWidth / 2;
    
    _playButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames playButton] highlightScale:ButtonHighlightScale];
    CGFloat buttonHeight = _playButton.frame.size.height;
    _playButton.position = CGPointMake(centerX, self.frame.size.height * TopButtonYPercent);
    [self addChild:_playButton];
    
    _optionsButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames optionsButton] highlightScale:ButtonHighlightScale];
    _optionsButton.position = CGPointMake(centerX, _playButton.position.y - buttonHeight - buttonMargin);
    [self addChild:_optionsButton];
    
    _leaderboardButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames leaderboardButton] highlightScale:ButtonHighlightScale];
    _leaderboardButton.position = CGPointMake(centerX, _optionsButton.position.y - buttonHeight - buttonMargin);
    [self addChild:_leaderboardButton];
    
    _statsButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames statsButton] highlightScale:ButtonHighlightScale];
    _statsButton.anchorPoint = CGPointMake(0, 0.5);
    _statsButton.position = CGPointMake(ScreenWidth * SideButtonInsetPercent, _leaderboardButton.position.y - buttonHeight - buttonMargin);
    [self addChild:_statsButton];
    
    _tutorialButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames tutorialButton] highlightScale:ButtonHighlightScale];
    _tutorialButton.anchorPoint = CGPointMake(1, 0.5);
    _tutorialButton.position = CGPointMake(ScreenWidth - ScreenWidth * SideButtonInsetPercent, _statsButton.position.y);
    [self addChild:_tutorialButton];
    
    _buttons = [NSSet setWithObjects:_playButton, _optionsButton, _leaderboardButton, _statsButton, _tutorialButton, nil];
}

- (void) placeBackgroundImage {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:[ImageNames homeBackground]];
    background.anchorPoint = CGPointZero;
    [self addChild:background];
    background.zPosition = -1;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    for (HighlightSpriteNode *button in _buttons) {
        if ([button containsPoint:location]) {
            [button highlight];
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    for (HighlightSpriteNode *button in _buttons) {
        if ([button containsPoint:location]) {
            [button highlight];
        } else {
            [button unhighlight];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    for (HighlightSpriteNode *button in _buttons) {
        if ([button containsPoint:location]) {
            [[MusicManager sharedManager] playSoundSFX:ButtonTapSFXName ofType:@"wav"];
            [button unhighlight];
        }
    }

    if ([_playButton containsPoint:location]) {
        [[MusicManager sharedManager] stopBackgroundMusic];
        GameScene *scene = [GameScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
    
    if ([_optionsButton containsPoint:location]) {
        OptionsScene *scene = [OptionsScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
    
    if ([_leaderboardButton containsPoint:location]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLeaderboardNotification object:nil];
    }
    
    if ([_statsButton containsPoint:location]) {
        StatsScene *scene = [StatsScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
    
    if ([_tutorialButton containsPoint:location]) {
        TutorialScene *scene = [TutorialScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

@end
