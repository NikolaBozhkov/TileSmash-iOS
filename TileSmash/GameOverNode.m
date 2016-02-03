//
//  GameOverNode.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/10/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "GameOverNode.h"
#import "HighlightSpriteNode.h"
#import "Util.h"
#import "Colors.h"
#import "MusicManager.h"
#import "GameScene.h"
#import "HomeScene.h"
#import "ImageNames.h"
#import "HudNode.h"

static const CGFloat TopLabelYPercent = 0.66;
static const CGFloat LabelCenterXPercent = 0.52;
static const CGFloat ButtonsYPercent = 0.27;
static const CGFloat ButtonsXPercent = 0.3;
static const CGFloat FontSizePercent = 0.064;

@implementation GameOverNode {
    NSSet *_buttons;
}

+ (instancetype) gameOverNodeWithPosition:(CGPoint)position hud:(HudNode *)hud {
    GameOverNode *gameOverNode = [self node];
    gameOverNode.position = position;
    gameOverNode.userInteractionEnabled = YES;
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:[ImageNames gameOverBackground]];
    [gameOverNode addChild:background];
    
    CGFloat labelX = background.frame.size.width * LabelCenterXPercent - background.frame.size.width / 2; // simulate (0, 0) anchor
    CGFloat fontSize = background.frame.size.width * FontSizePercent;
    CGFloat labelYMargin = Margin * 1.5;
    CGFloat numbersLabelMaxWidth = background.frame.size.width / 2 - labelX - Margin * 3;
    
    // Score
    SKLabelNode *scoreLabel = [Util labelWithFont:MainFont text:@"SCORE:" fontColor:[Colors orangeColor] fontSize:fontSize];
    scoreLabel.position = CGPointMake(labelX - scoreLabel.frame.size.width / 2, TopLabelYPercent * background.frame.size.height - background.frame.size.height / 2);
    scoreLabel.zPosition = gameOverNode.zPosition + 1;
    [gameOverNode addChild:scoreLabel];
    
    NSString *scoreText = [NSString stringWithFormat:@"%ld", (long)hud.score];
    SKLabelNode *score = [Util labelWithFont:MainFont text:scoreText fontColor:[SKColor whiteColor] fontSize:fontSize];
    [Util adjustFontSizeOfLabel:score byWidth:numbersLabelMaxWidth];
    score.position = CGPointMake(labelX + score.frame.size.width / 2 + Margin, scoreLabel.position.y);
    score.zPosition = gameOverNode.zPosition + 1;
    [gameOverNode addChild:score];
    
    if (hud.newBest) {
        SKLabelNode *newBestLabel = [Util labelWithFont:SpecialFont text:@"NEW BEST" fontColor:[Colors specialTextColor] fontSize:fontSize];
        newBestLabel.position = CGPointMake(labelX + newBestLabel.frame.size.width / 2 + Margin,
                                            score.position.y + score.frame.size.height / 2 + newBestLabel.frame.size.height / 2 + Margin);
        newBestLabel.zPosition = gameOverNode.zPosition + 1;
        [gameOverNode addChild:newBestLabel];
    }
    
    // Tiles Destroyed
    SKLabelNode *tilesLabel = [Util labelWithFont:MainFont text:@"TILES:" fontColor:[Colors orangeColor] fontSize:fontSize];
    tilesLabel.position = CGPointMake(labelX - tilesLabel.frame.size.width / 2,
                                      scoreLabel.position.y - scoreLabel.frame.size.height / 2 - tilesLabel.frame.size.height / 2 - labelYMargin);
    tilesLabel.zPosition = gameOverNode.zPosition + 1;
    [gameOverNode addChild:tilesLabel];
    
    NSString *tilesText = [NSString stringWithFormat:@"%ld", (long)hud.tilesDestroyed];
    SKLabelNode *tiles = [Util labelWithFont:MainFont text:tilesText fontColor:[SKColor whiteColor] fontSize:fontSize];
    [Util adjustFontSizeOfLabel:tiles byWidth:numbersLabelMaxWidth];
    tiles.position = CGPointMake(labelX + tiles.frame.size.width / 2 + Margin, tilesLabel.position.y);
    tiles.zPosition = gameOverNode.zPosition + 1;
    [gameOverNode addChild:tiles];
    
    // Top Streak
    SKLabelNode *topStreakLabel = [Util labelWithFont:MainFont text:@"TOP STREAK:" fontColor:[Colors orangeColor] fontSize:fontSize];
    topStreakLabel.position = CGPointMake(labelX - topStreakLabel.frame.size.width / 2,
                                      tilesLabel.position.y - tilesLabel.frame.size.height / 2 - topStreakLabel.frame.size.height / 2 - labelYMargin);
    topStreakLabel.zPosition = gameOverNode.zPosition + 1;
    [gameOverNode addChild:topStreakLabel];
    
    NSString *topStreakText = [NSString stringWithFormat:@"%ld", (long)hud.topStreak];
    SKLabelNode *topStreak = [Util labelWithFont:MainFont text:topStreakText fontColor:[SKColor whiteColor] fontSize:fontSize];
    [Util adjustFontSizeOfLabel:topStreak byWidth:numbersLabelMaxWidth];
    topStreak.position = CGPointMake(labelX + topStreak.frame.size.width / 2 + Margin, topStreakLabel.position.y);
    topStreak.zPosition = gameOverNode.zPosition + 1;
    [gameOverNode addChild:topStreak];
    
    [gameOverNode setupButtonsWithBackground:background];
    
    return gameOverNode;
}

- (void) setupButtonsWithBackground:(SKSpriteNode *)background {
    _restartButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames restartButtonSmall] highlightScale:ButtonHighlightScale];
    _restartButton.zPosition = 1;
    _restartButton.position = CGPointMake(background.frame.size.width * ButtonsXPercent - background.frame.size.width / 2,
                                          background.frame.size.height * ButtonsYPercent - background.frame.size.height / 2);
    [self addChild:_restartButton];
    
    _homeButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames homeButtonSmall] highlightScale:ButtonHighlightScale];
    _homeButton.zPosition = 1;
    _homeButton.position = CGPointMake(_restartButton.position.x + _homeButton.frame.size.width * 1.5, _restartButton.position.y);
    [self addChild:_homeButton];
    
    _buttons = [NSSet setWithObjects:_restartButton, _homeButton, nil];
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
        }
    }
    
    if ([_restartButton containsPoint:location]) {
        GameScene *scene = [GameScene sceneWithSize:self.scene.view.bounds.size];
        [self.scene.view presentScene:scene];
    } else if ([_homeButton containsPoint:location]) {
        HomeScene *scene = [HomeScene sceneWithSize:self.scene.view.bounds.size];
        [[MusicManager sharedManager] stopBackgroundMusic];
        [[MusicManager sharedManager] playBackgroundMusic:MenuBackgroundMusicName ofType:@"mp3" numberOfLoops:-1];
        [self.scene.view presentScene:scene];
    }
}

@end
