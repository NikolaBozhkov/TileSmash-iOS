//
//  PauseNode.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/27/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "PauseNode.h"
#import "TextureAtlases.h"
#import "Util.h"
#import "SwitchButton.h"
#import "HighlightSpriteNode.h"
#import "MusicManager.h"
#import "HomeScene.h"
#import "ImageNames.h"
#import "GameScene.h"

static const CGFloat ButtonOffsetXPercent = 0.027;
static const CGFloat TopButtonYPercent = 0.73;
static const CGFloat ButtonMarginPercent = 0.045;
static const CGFloat HighlightScale = 0.95;
static const NSInteger zPosition = 10;

@implementation PauseNode {
    SKSpriteNode *_background;
    HighlightSpriteNode *_resumeButton;
    HighlightSpriteNode *_restartButton;
    HighlightSpriteNode *_homeButton;
    SwitchButton *_musicButton;
    SwitchButton *_sfxButton;
    NSSet *_buttons;
}

+ (instancetype) pauseNodeWithPosition:(CGPoint)position {
    PauseNode *pauseNode = [self new];
    pauseNode.position = position;
    pauseNode.zPosition = zPosition;
    pauseNode.userInteractionEnabled = YES;
    
    [pauseNode setUpBackground];
    [pauseNode setUpButtons];
    
    return pauseNode;
}

- (void) setUpBackground {
    _background = [SKSpriteNode spriteNodeWithTexture:[[TextureAtlases mainAtlas] textureNamed:[ImageNames pausedBackground]]];
    _background.anchorPoint = CGPointMake(0.5, 0);
    _background.position = CGPointMake(_background.position.x, -_background.frame.size.height / 2);
    [self addChild:_background];
}

- (void) setUpButtons {
    CGFloat buttonOffsetX = ScreenWidth * ButtonOffsetXPercent;
    
    // resume button
    _resumeButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames resumeButton] highlightScale:HighlightScale];
    _resumeButton.position = CGPointMake(-buttonOffsetX, _background.frame.size.height * TopButtonYPercent);
    _resumeButton.zPosition = 1;
    [_background addChild:_resumeButton];
    
    CGFloat margin = ScreenWidth * ButtonMarginPercent;
    
    // restart button
    _restartButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames restartButton] highlightScale:HighlightScale];
    _restartButton.position = CGPointMake(-buttonOffsetX, _resumeButton.position.y - _resumeButton.frame.size.height - margin);
    _restartButton.zPosition = 1;
    [_background addChild:_restartButton];
    
    // home button
    _homeButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames homeButton] highlightScale:HighlightScale];
    _homeButton.position = CGPointMake(-buttonOffsetX, _restartButton.position.y - _restartButton.frame.size.height - margin);
    _homeButton.zPosition = 1;
    [_background addChild:_homeButton];
    
    // music button
    _musicButton = [SwitchButton switchButtonWithOnImageNamed:[ImageNames musicButtonOn] offImageNamed:[ImageNames musicButtonOff]
                                               highlightScale:HighlightScale on:[MusicManager sharedManager].musicOn];
    _musicButton.position = CGPointMake(-buttonOffsetX - margin - _musicButton.frame.size.width / 2,
                                        _homeButton.position.y - _homeButton.frame.size.height / 2 - _musicButton.frame.size.height / 2 - margin);
    _musicButton.zPosition = 1;
    [_background addChild:_musicButton];
    
    // sfx button
    _sfxButton = [SwitchButton switchButtonWithOnImageNamed:[ImageNames soundsButtonOn] offImageNamed:[ImageNames soundsButtonOff]
                                             highlightScale:HighlightScale on:[MusicManager sharedManager].sfxOn];
    _sfxButton.position = CGPointMake(margin + _sfxButton.frame.size.width / 2,
                                      _homeButton.position.y - _homeButton.frame.size.height / 2 - _sfxButton.frame.size.height / 2 - margin);
    _sfxButton.zPosition = 1;
    [_background addChild:_sfxButton];
    
    _buttons = [NSSet setWithObjects:_resumeButton, _restartButton, _homeButton, _musicButton, _sfxButton, nil];
}

- (void) toggleMusic {
    [_musicButton toggleState];
    if (_musicButton.on) {
        [MusicManager sharedManager].volume = DefaultMusicVolume;
    } else {
        [MusicManager sharedManager].volume = 0;
    }
}

- (void) toggleSounds {
    [_sfxButton toggleState];
    [MusicManager sharedManager].sfxOn = _sfxButton.on;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    for (HighlightSpriteNode *button in _buttons) {
        if ([button isEqual:node]) {
            [button highlight];
        }
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    for (HighlightSpriteNode *button in _buttons) {
        if ([button isEqual:node]) {
            [button highlight];
        } else {
            [button unhighlight];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    for (HighlightSpriteNode *button in _buttons) {
        if ([button isEqual:node]) {
            [[MusicManager sharedManager] playSoundSFX:ButtonTapSFXName ofType:@"wav"];
            [button unhighlight];
        }
    }
    
    if ([_resumeButton isEqual:node]) {
        [(GameScene *)self.scene unpause];
    } else if ([_restartButton isEqual:node]) {
        GameScene *scene = [GameScene sceneWithSize:self.scene.frame.size];
        [self.scene.view presentScene:scene];
    } else if ([_homeButton isEqual:node]) {
        [[MusicManager sharedManager] stopBackgroundMusic];
        [[MusicManager sharedManager] playBackgroundMusic:MenuBackgroundMusicName ofType:@"mp3" numberOfLoops:-1];
        HomeScene *scene = [HomeScene sceneWithSize:self.scene.frame.size];
        [self.scene.view presentScene:scene];
    } else if ([_musicButton isEqual:node]) {
        [self toggleMusic];
    } else if ([_sfxButton isEqual:node]) {
        [self toggleSounds];
    }
}

@end
