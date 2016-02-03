//
//  HudNode.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/2/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "HudNode.h"
#import "Util.h"
#import "TileNode.h"
#import "Colors.h"
#import "DoubleLineLabel.h"
#import "BlockLabel.h"
#import "TextureAtlases.h"
#import "PlayerProfile.h"
#import "ImageNames.h"

static const CGFloat MarginMultiplier = 3;

static const CGFloat BlockCornerRadius = 5.0;
static const CGFloat BarCornerRadius = 5.0;

static const CGFloat BlockLabelLineHeight = 10;
static const CGFloat FontSizePercent = 0.032;
static NSString *const ScoreText = @"SCORE";
static NSString *const BestScoreText = @"BEST";

static NSUInteger const SecondStageBlockedTilesCount = 3;
static NSUInteger const ThirdStageBlockedTilesCount = 6;

static NSTimeInterval const BlockedTilesBarScaleDuration = 1.0;

@interface HudNode ()

@property (assign, nonatomic) NSUInteger bestScore;

@property (strong, nonatomic) BlockLabel *colorTimerBlockLabel;

@end

@implementation HudNode {
    DoubleLineLabel *_scoreLabel;
    DoubleLineLabel *_bestScoreLabel;
    
    BlockLabel *_scoreBlockLabel;
    BlockLabel *_bestScoreBlockLabel;
    
    SKShapeNode *_blockedTilesCounterBar;
}

- (void) setScore:(NSUInteger)score {
    _score = score;
    _scoreLabel.secondLineLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_score];
    [Util adjustFontSizeOfLabel:_scoreLabel.secondLineLabel byWidth:_scoreBlockLabel.block.frame.size.width - Margin * 2];
    
    if (_score > _bestScore) {
        self.bestScore = _score;
        _newBest = YES;
    }
}

- (void) setBestScore:(NSUInteger)bestScore {
    _bestScore = bestScore;
    _bestScoreLabel.secondLineLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_bestScore];
    [Util adjustFontSizeOfLabel:_bestScoreLabel.secondLineLabel byWidth:_bestScoreBlockLabel.block.frame.size.width - Margin * 2];
}

- (void) setSelectedColor:(SKColor *)selectedColor {
    _selectedColor = selectedColor;
    _colorTimerBlockLabel.block.fillColor = selectedColor;
}

- (void) setBlockedTilesCount:(NSUInteger)blockedTilesCount {
    _blockedTilesCount = blockedTilesCount > MaxBlockedTiles ? MaxBlockedTiles : blockedTilesCount;
    [self updateBlockedTilesCounterBar];
}

+ (instancetype) hudWithPosition:(CGPoint)position frame:(CGRect)frame {
    
    HudNode *hud = [self node];
    hud.position = position;
    hud.selectedColor = [[Colors instance] getRandomColor];

    CGFloat fontSize = frame.size.height * FontSizePercent;
    
    BlockLabel *scoreBlockLabel = [hud createScoreLabelInFrame:frame position:CGPointZero fontSize:fontSize lineHeight:BlockLabelLineHeight];
    [hud addChild:scoreBlockLabel];
    
    CGPoint bestScoreLabelPosition = CGPointMake(scoreBlockLabel.block.frame.size.width + Margin, 0);
    BlockLabel *bestScoreBlockLabel = [hud createBestScoreLabelInFrame:frame position:bestScoreLabelPosition fontSize:fontSize lineHeight:BlockLabelLineHeight];
    [hud addChild:bestScoreBlockLabel];
    
    CGPoint colorTimerLabelPosition = CGPointMake(bestScoreLabelPosition.x, bestScoreLabelPosition.y - bestScoreBlockLabel.block.frame.size.height - Margin);
    hud.colorTimerBlockLabel = [hud createColorTimerLabelInFrame:frame position:colorTimerLabelPosition fontSize:fontSize];
    [hud addChild:hud.colorTimerBlockLabel];
    
    CGPoint metalBlockCounterFramePosition = CGPointMake(0, scoreBlockLabel.position.y - scoreBlockLabel.block.frame.size.height / 2 - Margin);
    CGFloat metalBlockCounterFrameHeight = hud.colorTimerBlockLabel.block.frame.size.height / 3;
    SKShapeNode *metalBlockCounterFrame = [hud createBlockedTilesCounterBarInFrame:frame position:metalBlockCounterFramePosition height:metalBlockCounterFrameHeight];
    [hud addChild:metalBlockCounterFrame];
    
    hud.bestScore = [PlayerProfile sharedInstance].bestScore;
    
    return hud;
}


- (BlockLabel *) createScoreLabelInFrame:(CGRect)frame position:(CGPoint)position fontSize:(CGFloat)fontSize lineHeight:(CGFloat)lineHeight {
    _scoreLabel = [DoubleLineLabel doubleLineLabelWithFontSize:fontSize firstLine:ScoreText
                                                    secondLine:[NSString stringWithFormat:@"%lu", (unsigned long)_score] lineHeight:lineHeight];
    _scoreLabel.firstLineLabel.fontColor = [SKColor lightTextColor];
    
    CGSize scoreBackgroundSize = CGSizeMake((frame.size.width - (MarginMultiplier * Margin)) / 2, _scoreLabel.size.height);
    
    _scoreBlockLabel = [BlockLabel BlockLabelWithLabel:_scoreLabel color:[Colors hudColor] position:position
                                            lineHeight:lineHeight size:scoreBackgroundSize cornerRadius:BlockCornerRadius
                                     paddingHorizontal:0 paddingVertical:Margin];
    
    return _scoreBlockLabel;
}

- (BlockLabel *) createBestScoreLabelInFrame:(CGRect)frame position:(CGPoint)position fontSize:(CGFloat)fontSize lineHeight:(CGFloat)lineHeight {
    _bestScoreLabel = [DoubleLineLabel doubleLineLabelWithFontSize:fontSize firstLine:BestScoreText
                                                        secondLine:[NSString stringWithFormat:@"%lu", (unsigned long)_bestScore] lineHeight:lineHeight];
    _bestScoreLabel.firstLineLabel.fontColor = [SKColor lightTextColor];
    
    CGSize bestScoreBackgroundSize = CGSizeMake((frame.size.width - (MarginMultiplier * Margin)) / 2, _bestScoreLabel.size.height);
    
    _bestScoreBlockLabel = [BlockLabel BlockLabelWithLabel:_bestScoreLabel color:[Colors hudColor] position:position
                                                lineHeight:lineHeight size:bestScoreBackgroundSize cornerRadius:BlockCornerRadius
                                         paddingHorizontal:0 paddingVertical:Margin];
    
    return _bestScoreBlockLabel;
}
                                         
- (BlockLabel *) createColorTimerLabelInFrame:(CGRect)frame position:(CGPoint)position fontSize:(CGFloat)fontSize {
    _colorTimerLabel = [Util labelWithFont:MainFont text:[NSString stringWithFormat:@"%.2lf", InitialColorChangeTime]
                                       fontColor:[SKColor whiteColor] fontSize:fontSize];
    _colorTimerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    
    CGSize colorTimerBackgroundSize = CGSizeMake((frame.size.width - (MarginMultiplier * Margin)) / 2, _colorTimerLabel.frame.size.height * 3);
    
    BlockLabel *colorTimerBlockLabel = [BlockLabel BlockLabelWithLabel:_colorTimerLabel color:_selectedColor position:position
                                                            lineHeight:0 size:colorTimerBackgroundSize cornerRadius:BlockCornerRadius
                                                     paddingHorizontal:0 paddingVertical:Margin];
    
    _colorTimerLabel.position = CGPointMake(-_colorTimerLabel.frame.size.width / 2, _colorTimerLabel.position.y);
    return colorTimerBlockLabel;
}

- (SKShapeNode *) createBlockedTilesCounterBarInFrame:(CGRect)frame position:(CGPoint)position height:(CGFloat)height {
    SKSpriteNode *barIcon = [SKSpriteNode spriteNodeWithTexture:[[TextureAtlases mainAtlas] textureNamed:[ImageNames metalBlock]]];
    CGFloat extraSize = height * 0.2; // Used to make the block a bit bigger than the bar
    barIcon.size = CGSizeMake(height + extraSize, height + extraSize);
    barIcon.anchorPoint = CGPointMake(0, 1);
    barIcon.position = position;
    [self addChild:barIcon];
    
    CGFloat innerMargin = Margin / 2; // The margin between the icon and the bar
    CGFloat barWidth = (frame.size.width - (MarginMultiplier * Margin)) / 2 - barIcon.frame.size.width - innerMargin;
    CGFloat barFrameLineWidth = 2;
    
    _blockedTilesCounterBar = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(barWidth - barFrameLineWidth / 2, height - barFrameLineWidth / 2) cornerRadius:BarCornerRadius];
    _blockedTilesCounterBar.fillColor = [Colors firstStageBlockedTilesBarColor];
    _blockedTilesCounterBar.lineWidth = 0;
    _blockedTilesCounterBar.position = CGPointMake(position.x + barIcon.frame.size.width + innerMargin + _blockedTilesCounterBar.frame.size.width / 2,
                                                   position.y - extraSize / 2 - barFrameLineWidth / 2 - _blockedTilesCounterBar.frame.size.height / 2);
    _blockedTilesCounterBar.xScale = 1.0 / INT32_MAX; // Fixes a bug where the bar won't scale and stays at 0 width always if initial scale is 0
    [self addChild:_blockedTilesCounterBar];
    
    CGSize barFrameSize = CGSizeMake(barWidth, height);
    SKShapeNode *barFrame = [SKShapeNode shapeNodeWithRectOfSize:barFrameSize cornerRadius:BarCornerRadius];
    barFrame.lineWidth = barFrameLineWidth;
    barFrame.position = _blockedTilesCounterBar.position;
    barFrame.strokeColor = [SKColor darkGrayColor];
    
    // Alpha effect bar is used to create a similar effect to a gradient
    CGFloat alphaEffectBarMargin = height * 0.08;
    CGFloat alphaBarHeight = height / 2 - alphaEffectBarMargin;
    CGFloat barCornerRadius = alphaBarHeight / 2 - 0.1;
    SKShapeNode *alphaEffectBar = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(barWidth - barFrameLineWidth / 2 - alphaEffectBarMargin, alphaBarHeight)
                                                          cornerRadius:barCornerRadius];
    
    alphaEffectBar.lineWidth = 0;
    alphaEffectBar.fillColor = [SKColor whiteColor];
    alphaEffectBar.alpha = 0.5;
    alphaEffectBar.zPosition = 1;
    alphaEffectBar.position = CGPointMake(_blockedTilesCounterBar.position.x,
                                          _blockedTilesCounterBar.position.y + alphaEffectBar.frame.size.height / 2);
    [self addChild:alphaEffectBar];
    
    return barFrame;
}

- (void) updateBlockedTilesCounterBar {
    CGFloat scaleToSet = (CGFloat)_blockedTilesCount / MaxBlockedTiles;
    [_blockedTilesCounterBar runAction:[SKAction scaleXTo:scaleToSet duration:BlockedTilesBarScaleDuration]];
    
    SKColor *nextColor;
    
    if (_blockedTilesCount >= ThirdStageBlockedTilesCount) {
        nextColor = [Colors thirdStageBlockedTilesBarColor];
    } else if (_blockedTilesCount >= SecondStageBlockedTilesCount) {
        nextColor = [Colors secondStageBlockedTilesBarColor];
    }
    
    if (nextColor == nil || nextColor.hash == _blockedTilesCounterBar.fillColor.hash) {
        return;
    }
    
    CGFloat initialRed, initialGreen, initialBlue, initialAlpha;
    [_blockedTilesCounterBar.fillColor getRed:&initialRed green:&initialGreen blue:&initialBlue alpha:&initialAlpha];
    
    CGFloat finalRed, finalGreen, finalBlue, finalAlpha;
    [nextColor getRed:&finalRed green:&finalGreen blue:&finalBlue alpha:&finalAlpha];
    
    SKAction *colorChangeAction = [SKAction customActionWithDuration:BlockedTilesBarScaleDuration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        CGFloat step = elapsedTime / BlockedTilesBarScaleDuration;
        
        CGFloat currentRed = 0.0, currentGreen = 0.0, currentBlue = 0.0, currentAlpha;
        currentRed = initialRed + (finalRed - initialRed) * step;
        currentGreen = initialGreen + (finalGreen - initialGreen) * step;
        currentBlue = initialBlue + (finalBlue - initialBlue) * step;
        currentAlpha = initialAlpha + (finalAlpha - initialAlpha) * step;
        
        SKShapeNode *shapeNode = (SKShapeNode *)node;
        shapeNode.fillColor = [SKColor colorWithRed:currentRed green:currentGreen blue:currentBlue alpha:currentAlpha];
    }];
    
    [_blockedTilesCounterBar runAction:colorChangeAction];
}

- (void) onTileDestroyed:(NSNotification *)notification {
    TileNode *tile = [notification object];
    if (tile.isBlocked) {
        ++self.blockedTilesCount;
        return;
    }
    
    if (tile.tileColor == _selectedColor) {
        self.score += tile.selectedPoints;
    } else {
        self.score += tile.unselectedPoints;
    }
    
    ++_tilesDestroyed;
}

@end
