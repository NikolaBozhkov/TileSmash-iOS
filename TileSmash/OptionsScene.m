//
//  SettingsScene.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/25/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "AdAdjustableScene+Protected.h"
#import "OptionsScene.h"
#import "MusicManager.h"
#import "Util.h"
#import "HomeScene.h"
#import "CustomSlider.h"
#import "HighlightSpriteNode.h"
#import "SwitchButton.h"
#import "TextureAtlases.h"
#import "AdManager.h"
#import "ImageNames.h"

static const CGFloat OptionsTitleYPercent = 0.9;
static const CGFloat TopButtonYPercent = 0.74;
static const CGFloat TopButtonXPercent = 0.18;
static const CGFloat BackButtonXPercent = 0.06;
static const CGFloat DevInfoYPercent = 0.545;

@implementation OptionsScene {
    UISlider *_musicVolumeSlider;
    
    SwitchButton *_musicButton;
    SwitchButton *_soundsButton;
    
    NSSet *_buttons;
}

@synthesize backButton = _backButton;

- (void) didMoveToView:(SKView *)view {
    [self placeBackground];
    [self createMusicButton];
    [self createMusicVolumeSlider];
    [self createSoundsButton];
    
    _backButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames backButton] highlightScale:ButtonHighlightScale];
    CGFloat backButtonX = ScreenWidth * BackButtonXPercent;
    _backButton.anchorPoint = CGPointZero;
    _backButton.position = CGPointMake(backButtonX, backButtonX);
    if ([AdManager sharedManager].isActive) {
        [self adjustForAd];
    }
    
    [self addChild:_backButton];
    
    _buttons = [NSSet setWithObjects:_musicButton, _soundsButton, _backButton, nil];
}

- (void) placeBackground {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:[ImageNames stripesBackground]];
    background.anchorPoint = CGPointZero;
    background.zPosition = -2;
    [self addChild:background];
    
    SKSpriteNode *devInfoImage = [SKSpriteNode spriteNodeWithImageNamed:[ImageNames devInfo]];
    devInfoImage.anchorPoint = CGPointMake(0.5, 1);
    devInfoImage.position = CGPointMake(ScreenWidth / 2, ScreenHeight * DevInfoYPercent);
    devInfoImage.zPosition = -1;
    [self addChild:devInfoImage];
    
    SKSpriteNode *optionsTitle = [SKSpriteNode spriteNodeWithTexture:[[TextureAtlases mainAtlas] textureNamed:[ImageNames optionsLabel]]];
    optionsTitle.position = CGPointMake(ScreenWidth / 2, ScreenHeight * OptionsTitleYPercent);
    [self addChild:optionsTitle];
}

- (void) createMusicButton {
    BOOL on = [[NSUserDefaults standardUserDefaults] floatForKey:MusicVolumeKey] != 0;
    _musicButton = [SwitchButton switchButtonWithOnImageNamed:[ImageNames musicButtonOnSmall] offImageNamed:[ImageNames musicButtonOffSmall] highlightScale:ButtonHighlightScale on:on];
    _musicButton.position = CGPointMake(self.frame.size.width * TopButtonXPercent, self.frame.size.height * TopButtonYPercent);
    [self addChild:_musicButton];
}

- (void) createMusicVolumeSlider {
    CGFloat sliderX = _musicButton.position.x + _musicButton.frame.size.width / 2 + Margin * 2;
    CGFloat sliderY = self.frame.size.height - _musicButton.position.y;
    CGFloat sliderWidth = self.frame.size.width - sliderX - _musicButton.position.x + _musicButton.frame.size.width / 2; // ends and the mirror "x" as the button
    CGFloat sliderHeight = _musicButton.frame.size.height;
    CGRect musicVolumeSliderFrame = CGRectMake(sliderX, sliderY, sliderWidth, sliderHeight);
    
    _musicVolumeSlider = [[CustomSlider alloc] initWithFrame:musicVolumeSliderFrame];
    [_musicVolumeSlider addTarget:self action:@selector(volumeChanged) forControlEvents:UIControlEventValueChanged];
    _musicVolumeSlider.minimumValue = 0;
    _musicVolumeSlider.maximumValue = MaxMusicVolume;
    _musicVolumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:MusicVolumeKey];
    _musicVolumeSlider.continuous = YES;
    [self.view addSubview:_musicVolumeSlider];
}

- (void) createSoundsButton {
    BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:SfxOnKey];
    _soundsButton = [SwitchButton switchButtonWithOnImageNamed:[ImageNames soundsButtonOnSmall] offImageNamed:[ImageNames soundsButtonOffSmall] highlightScale:ButtonHighlightScale on:on];
    _soundsButton.position = CGPointMake(_musicButton.position.x,
                                         _musicButton.position.y - _musicButton.frame.size.height / 2 - _soundsButton.frame.size.height / 2 - Margin);
    [self addChild:_soundsButton];
}

- (void) volumeChanged {
    [MusicManager sharedManager].volume = _musicVolumeSlider.value;
    if ((_musicVolumeSlider.value == 0 && _musicButton.on)
            || (_musicVolumeSlider.value != 0 && !_musicButton.on)) {
        [_musicButton toggleState];
    }
}

- (void) toggleMusic {
    [_musicButton toggleState];
    if (_musicButton.on) {
        _musicVolumeSlider.value = DefaultMusicVolume;
    } else {
        _musicVolumeSlider.value = 0;
    }
    
    [self volumeChanged];
}

- (void) toggleSounds {
    [_soundsButton toggleState];
    [MusicManager sharedManager].sfxOn = _soundsButton.on;
}

- (void) removeUIElements {
    [_musicVolumeSlider removeFromSuperview];
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
    
    if ([_musicButton containsPoint:location]) {
        [self toggleMusic];
    } else if ([_soundsButton containsPoint:location]) {
        [self toggleSounds];
    } else if ([_backButton containsPoint:location]) {
        HomeScene *scene = [HomeScene sceneWithSize:self.view.frame.size];
        [self.view presentScene:scene];
    }
}

- (void) willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    [self removeUIElements];
}

@end
