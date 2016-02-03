//
//  HighlightSpriteNode.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/28/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HighlightSpriteNode : SKSpriteNode

+ (instancetype) spriteNodeWithImageNamed:(NSString *)name highlightScale:(CGFloat)highlightScale;

@property (assign, nonatomic, readonly) CGFloat highlightScale;

- (void) highlight;
- (void) unhighlight;

@end
