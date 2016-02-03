//
//  GameGridNode.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/5/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "GameGridNode.h"
#import "TileNode.h"
#import "Util.h"
#import "Colors.h"

static const NSInteger GameGridSize = 5;
const CGFloat GameGridYPercent = 0.705;

@implementation GameGridNode

+ (instancetype) gameGridWithPosition:(CGPoint)position inFrame:(CGRect)frame view:(SKView *)view {
    GameGridNode *gameGrid = [self node];
    gameGrid.colorsCount = [[NSMutableDictionary alloc] initWithCapacity:[Colors instance].values.count];
    
    CGFloat width = frame.size.width - 2 * position.x;
    
    // Check if there is space for the ad banner
    if (position.y - width < 50 + Margin) {
        width = position.y - 50 - Margin;
    }
    
    // Adjust X coordinate to center
    gameGrid.position = CGPointMake((ScreenWidth - width) / 2, position.y);
    CGFloat blocksMargin = Margin / 1.5;
    [gameGrid fillWithRandomTilesByWidth:width view:view blocksMargin:blocksMargin frame:frame];
    
    return gameGrid;
}

- (void) fillWithRandomTilesByWidth:(CGFloat)width view:(SKView *)view blocksMargin:(CGFloat)blocksMargin frame:(CGRect)frame {
    NSInteger blocksCount = GameGridSize * GameGridSize;
    NSInteger maxBlocksOfColor = blocksCount / [Colors instance].values.count;
    
    NSUInteger tileSize = (width - ((GameGridSize - 1) * blocksMargin)) / GameGridSize;
    for (int i = 0; i < GameGridSize; i++) {
        for (int j = 0; j < GameGridSize; j++) {
            
            TileNode *tile = [TileNode tileWithRandomColorWithSize:CGSizeMake(tileSize, tileSize)
                                                          position:CGPointMake(j * (tileSize + blocksMargin), -i * (tileSize + blocksMargin))
                                                              view:view];
            
            if ([_colorsCount objectForKey:tile.tileColor] == nil) {
                self.colorsCount[tile.tileColor] = @0;
            }
            
            while ([_colorsCount[tile.tileColor] integerValue] >= maxBlocksOfColor) {
                tile = [TileNode tileWithRandomColorWithSize:CGSizeMake(tileSize, tileSize)
                                                    position:CGPointMake(j * (tileSize + blocksMargin), -i * (tileSize + blocksMargin))
                                                        view:view];
            }
            
            NSInteger newColorCount = [_colorsCount[tile.tileColor] integerValue] + 1;
            _colorsCount[tile.tileColor] = [NSNumber numberWithInteger:newColorCount];
            
            [self addChild:tile];
        }
    }
}

- (void) onTileDestroyed:(NSNotification *)notification {
    TileNode *tile = [notification object];
    NSInteger newColorCount = [_colorsCount[tile.tileColor] integerValue] - 1;
    _colorsCount[tile.tileColor] = [NSNumber numberWithInteger:newColorCount];
}

- (void) onTileChangedColor:(NSNotification *)notification {
    TileNode *tile = [notification object];
    NSInteger newColorCount = [_colorsCount[tile.tileColor] integerValue] + 1;
    _colorsCount[tile.tileColor] = [NSNumber numberWithInteger:newColorCount];
}

@end
