//
//  GameGridNode.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/5/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern const CGFloat GameGridYPercent;

@interface GameGridNode : SKNode

+ (instancetype) gameGridWithPosition:(CGPoint)position inFrame:(CGRect)frame view:(SKView *)view;

@property (strong, nonatomic) NSMutableDictionary* colorsCount;

- (void) onTileDestroyed:(NSNotification *)notification;
- (void) onTileChangedColor:(NSNotification *)notification;

@end
