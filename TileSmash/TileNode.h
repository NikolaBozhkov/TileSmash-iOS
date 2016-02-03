//
//  TileNode.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/5/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern NSString *const TileName;
extern NSString *const TileDestroyedNotification;
extern NSString *const TileChangedColorNotification;

@interface TileNode : SKSpriteNode

+ (instancetype) tileWithSize:(CGSize)size position:(CGPoint)position color:(SKColor *)color view:(SKView *)view;
+ (instancetype) tileWithRandomColorWithSize:(CGSize)size position:(CGPoint)position view:(SKView *)view;

@property (assign, nonatomic, readonly) NSInteger health;
@property (assign, nonatomic, readonly) NSInteger selectedPoints;
@property (assign, nonatomic, readonly) NSInteger unselectedPoints;
@property (strong, nonatomic) SKColor *tileColor;
@property (assign, nonatomic, readonly) BOOL isSelected;
@property (assign, nonatomic, readonly) BOOL isCracked;
@property (assign, nonatomic, readonly) BOOL isBlocked;

- (void) toggleSelected;
- (void) blockTile;

@end
