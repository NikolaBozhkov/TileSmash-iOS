//
//  GameOverNode.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/10/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class HudNode;
@class HighlightSpriteNode;

@interface GameOverNode : SKNode

+ (instancetype) gameOverNodeWithPosition:(CGPoint)position hud:(HudNode *)hud;

@property (strong, nonatomic) HighlightSpriteNode *restartButton;
@property (strong, nonatomic) HighlightSpriteNode *homeButton;

@end
