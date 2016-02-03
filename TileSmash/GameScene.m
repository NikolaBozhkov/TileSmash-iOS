//
//  GameScene.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/1/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "GameScene.h"
#import "Util.h"
#import "HudNode.h"
#import "TileNode.h"
#import "GameGridNode.h"
#import "Colors.h"
#import "Messenger.h"
#import "GameOverNode.h"
#import "MusicManager.h"
#import "TextureAtlases.h"
#import "PauseNode.h"
#import "GameCenterManager.h"
#import "PlayerProfile.h"
#import "AdManager.h"
#import "ImageNames.h"

static const NSInteger BlurFactor = 41;

static const CGFloat FontSizePercentage = 0.055;
static const CGFloat GameOverScreenYPercent = 0.55;
static const CGFloat PauseScreenYPercent = 0.5;
static const CGFloat GameOverWaitDuration = 1.0;

static NSString *const BlockSFXFileName = @"zoop_up.wav";
static NSString *const StreakSFXFileName = @"reminder.wav";

@implementation GameScene {
    SKNode *_gameLayer;
    HudNode *_hud;
    GameGridNode *_gameGrid;
    Messenger *_messenger;
    SKEffectNode *_blurNode;
    GameOverNode *_gameOverScreen;
    PauseNode *_pauseScreen;
    SKSpriteNode *_pauseButton;
    
    BOOL _blurred;
    BOOL _gameOver;
    BOOL _paused;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _timeSinceLastUpdate;
    NSTimeInterval _timeTillColorChange;
    NSTimeInterval _colorChangeInterval;
    NSTimeInterval _gameTime;
    
    NSUInteger _streakNumber;
}

- (void) applicationWillResignActive {
    [self pause];
}

- (void) applicationDidEnterBackground {
    [[MusicManager sharedManager] stopBackgroundMusic];
}

- (void) applicationWillEnterForeground {
    self.paused = YES;
}

- (void) didMoveToView:(SKView *)view {
    [[MusicManager sharedManager] playBackgroundMusic:GameplayMusicName ofType:@"mp3" numberOfLoops:-1];
    _colorChangeInterval = InitialColorChangeTime;
    _timeTillColorChange = _colorChangeInterval;
    _streakNumber = 0;
    
    _gameLayer = [SKNode new];
    [self addChild:_gameLayer];
    
    [self setUpBlurNode];
    [self setUpPauseScreen];
    [self setUpPauseButton];
    
    self.backgroundColor = [Colors gameSceneBackground];
    _hud = [HudNode hudWithPosition:CGPointMake(Margin, self.frame.size.height - Margin) frame:self.frame];
    [_gameLayer addChild:_hud];
    
    CGFloat gameGridY = self.frame.size.height * GameGridYPercent;
    _gameGrid = [GameGridNode gameGridWithPosition:CGPointMake(Margin, gameGridY) inFrame:self.frame view:view];
    [_gameLayer addChild:_gameGrid];
    
    CGFloat messengerFontSize = self.frame.size.height * FontSizePercentage;
    _messenger = [Messenger messengerWithFontName:MainFont fontSize:messengerFontSize color:[Colors messengerFontColor]];
    
    [self addObservers];
    [self toggleSelectedTiles];
}

- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:_hud selector:@selector(onTileDestroyed:) name:TileDestroyedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_gameGrid selector:@selector(onTileDestroyed:) name:TileDestroyedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_gameGrid selector:@selector(onTileChangedColor:) name:TileChangedColorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:AdViewActionSouldBeginNotification object:nil];
}

- (void) setUpPauseButton {
    _pauseButton = [SKSpriteNode spriteNodeWithTexture:[[TextureAtlases mainAtlas] textureNamed:[ImageNames pauseButton]]];
    _pauseButton.anchorPoint = CGPointMake(1, 1);
    _pauseButton.position = CGPointMake(ScreenWidth - Margin / 3, ScreenHeight - Margin / 3);
    _pauseButton.zPosition = _hud.zPosition + 1;
    [_gameLayer addChild:_pauseButton];
}

- (void) setUpPauseScreen {
    CGPoint position = CGPointMake(CGRectGetMidX(self.frame), ScreenHeight * PauseScreenYPercent);
    _pauseScreen = [PauseNode pauseNodeWithPosition:position];
}

- (void) setUpBlurNode {
    _blurNode = [SKEffectNode node];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    NSInteger blurRadius = ScreenWidth / BlurFactor;
    [filter setValue:[NSNumber numberWithInteger:blurRadius] forKey:kCIInputRadiusKey];
    _blurNode.filter = filter;
    _blurNode.position = CGPointZero;
    _blurNode.blendMode = SKBlendModeAlpha;
    _blurNode.zPosition = 100;
}

- (void) setUpGameOverScreen {
    CGPoint position = CGPointMake(CGRectGetMidX(self.frame), ScreenHeight * GameOverScreenYPercent);
    _gameOverScreen = [GameOverNode gameOverNodeWithPosition:position hud:_hud];
    _gameOverScreen.zPosition = _blurNode.zPosition + 1;
}

- (void) toggleBlurredScene {
    for (SKNode *child in self.children) {
        [child removeFromParent];
        if (_blurred) {
            [_gameLayer addChild:child];
        } else {
            [_blurNode addChild:child];
        }
    }
    
    if (_blurred) {
        [_blurNode removeFromParent];
    } else {
        [self addChild:_blurNode];
    }
    
    _blurred = !_blurred;
}

- (void) pause {
    if (!_paused) {
        self.paused = YES;
        _paused = YES;
        [self addChild:_pauseScreen];
    }
}

- (void) unpause {
    [_pauseScreen removeFromParent];
    self.paused = NO;
    _paused = NO;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    NSArray *nodes = [self nodesAtPoint:location];
    if (!_gameOver && !_paused) {
        if ([_pauseButton isEqual:[self nodeAtPoint:location]]) {
            [self pause];
        }
        
        for (SKNode *node in nodes) {
            if ([node isKindOfClass:[TileNode class]]) {
                [node touchesBegan:touches withEvent:event];
                
                TileNode *tile = (TileNode *)node;
                if (tile.tileColor == _hud.selectedColor && !tile.isSelected && !tile.isBlocked) {
                    [tile toggleSelected];
                }
                
                // Change color if there are no tiles left with the current
                if ([_gameGrid.colorsCount[_hud.selectedColor] integerValue] <= 0) {
                    [self restartRound];
                }
            }
        }
    }
}

- (void)blockCurrentColorTiles {
    for (TileNode *tile in _gameGrid.children) {
        if ([tile isKindOfClass:[TileNode class]] && !tile.isBlocked && _hud.selectedColor.hash == tile.tileColor.hash) {
            [tile toggleSelected];
            [tile blockTile];
            [[MusicManager sharedManager] playActionSoundSFX:BlockSFXFileName target:self];
        }
    }
}

- (void) removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:_hud];
    [[NSNotificationCenter defaultCenter] removeObserver:_gameGrid];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) endGame {
    [self removeObservers];
    
    SKAction *block = [SKAction runBlock:^{
        [self setUpGameOverScreen];
        [self addChild:_gameOverScreen];
        self.userInteractionEnabled = YES;
    }];
    
    SKAction *sequence = [SKAction sequence:@[[SKAction waitForDuration:GameOverWaitDuration], block]];
    self.userInteractionEnabled = NO;
    [self toggleBlurredScene];
    [self runAction:sequence];
    
    // Save stats, overrides only if values are bigger
    [PlayerProfile sharedInstance].bestScore = _hud.bestScore;
    [PlayerProfile sharedInstance].mostTilesDestroyed = _hud.tilesDestroyed;
    [PlayerProfile sharedInstance].topStreak = _hud.topStreak;
    [PlayerProfile sharedInstance].longestGameTime = _gameTime;
    [PlayerProfile sharedInstance].totalGameTime += _gameTime;
    
    [GameCenterManager sharedManager].score = _hud.bestScore;
    [[GameCenterManager sharedManager] reportScore];
}

- (void) restartRound {
    CGFloat previousBlockedTilesCount = _hud.blockedTilesCount;
    
    [self blockCurrentColorTiles];
    // Check for game over
    if (_hud.blockedTilesCount >= MaxBlockedTiles) {
        _gameOver = YES;
        _timeTillColorChange = 0;
        _hud.colorTimerLabel.text = [NSString stringWithFormat:@"%.2lf", _timeTillColorChange];
        [self endGame];
        return;
    }
    
    // Change selected color
    do {
        _hud.selectedColor = [[Colors instance] getRandomColor];
    } while ([_gameGrid.colorsCount[_hud.selectedColor] integerValue] <= 0);
    
    [self toggleSelectedTiles];
    
    // Decrease color change time interval
    CGFloat blockedTilesDifference = _hud.blockedTilesCount - previousBlockedTilesCount;
    if (blockedTilesDifference > 0) {
        CGFloat timeToDecrease = blockedTilesDifference * BlockedTileTimeDrop;
        _colorChangeInterval -= timeToDecrease;
        [_messenger showMessageWithText:[NSString stringWithFormat:@"-%.2lf seconds", timeToDecrease] scene:self];
    }
    
    CGFloat longGameTimeReduction = 0;
    if (_gameTime >= TimeDropStartTime) {
        // Reduce time by 0.1 sec every 30 sec, to a min of 5 sec
        longGameTimeReduction = (int)((_gameTime - TimeDropStartTime) / TimeDropTimeInterval) * TimeDropOverTime;
        longGameTimeReduction = longGameTimeReduction > TimeDropMax ? TimeDropMax : longGameTimeReduction;
    }
    
    _timeTillColorChange = _colorChangeInterval - longGameTimeReduction;
    
    // Calculate and add streak bonus
    _streakNumber = previousBlockedTilesCount >= _hud.blockedTilesCount ? _streakNumber + 1 : 0;
    if (_streakNumber > StreakStartAfterRounds) {
        NSUInteger actualStreak = _streakNumber - StreakStartAfterRounds;
        _hud.topStreak = actualStreak > _hud.topStreak ? actualStreak : _hud.topStreak;
        NSUInteger streakBonus = actualStreak * StreakStartBonus;
        streakBonus = streakBonus > StreakBonusMax ? StreakBonusMax : streakBonus;
        _hud.score += streakBonus;
        [[MusicManager sharedManager] playActionSoundSFX:StreakSFXFileName target:self];
        [_messenger showMessageWithText:[NSString stringWithFormat:@"+%lu", (unsigned long)streakBonus] scene:self];
    }
}

- (void) toggleSelectedTiles {
    for (TileNode *tile in _gameGrid.children) {
        if ([tile isKindOfClass:[TileNode class]] && !tile.isBlocked && _hud.selectedColor.hash == tile.tileColor.hash) {
            [tile toggleSelected];
        }
    }
}

-(void) update:(CFTimeInterval)currentTime {
    if (_lastUpdateTime) {
        _timeSinceLastUpdate = currentTime - _lastUpdateTime;
    }
    
    if (!_gameOver && !_paused) {
        _gameTime += _timeSinceLastUpdate;
        _timeTillColorChange -= _timeSinceLastUpdate;
        _hud.colorTimerLabel.text = [NSString stringWithFormat:@"%.2lf", _timeTillColorChange >= 0.0f ? _timeTillColorChange : 0.0f];
        
        if (_timeTillColorChange <= 0) {
            [self restartRound];
        }
    }
    
    _lastUpdateTime = currentTime;
}

- (void) willMoveFromView:(SKView *)view {
    [self removeObservers];
}

@end
