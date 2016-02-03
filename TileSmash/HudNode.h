//
//  HudNode.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/2/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

+ (instancetype)hudWithPosition:(CGPoint)position frame:(CGRect)frame;

@property (assign, nonatomic) NSUInteger score;
@property (assign, nonatomic, readonly) NSUInteger bestScore;
@property (assign, nonatomic, readonly) BOOL newBest;
@property (assign, nonatomic) NSUInteger tilesDestroyed;
@property (assign, nonatomic) NSUInteger topStreak;

@property (strong, nonatomic, readonly) SKLabelNode *colorTimerLabel;

@property (strong, nonatomic) SKColor *selectedColor;
@property (assign, nonatomic) NSUInteger blockedTilesCount;

- (void) onTileDestroyed:(NSNotification *)notification;

@end
