//
//  HighlightSpriteNode.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/28/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "HighlightSpriteNode.h"
#import "TextureAtlases.h"

@interface HighlightSpriteNode ()

@property (assign, nonatomic) CGFloat highlightScale;

@end

@implementation HighlightSpriteNode {
    CGFloat _normalScaleX;
    CGFloat _normalScaleY;
    CGFloat _highlightedScaleX;
    CGFloat _highlightedScaleY;
}

+ (instancetype) spriteNodeWithImageNamed:(NSString *)name highlightScale:(CGFloat)highlightScale {
    HighlightSpriteNode *sprite = [self spriteNodeWithTexture:[[TextureAtlases mainAtlas] textureNamed:name]];
    sprite.highlightScale = highlightScale;
    [sprite setupScaling];
    return sprite;
}

- (void) setupScaling {
    _normalScaleX = self.xScale;
    _normalScaleY = self.yScale;
    _highlightedScaleX = _normalScaleX * _highlightScale;
    _highlightedScaleY = _normalScaleY * _highlightScale;
}

- (void) highlight {
    self.xScale = _highlightedScaleX;
    self.yScale = _highlightedScaleY;
}

- (void) unhighlight {
    self.xScale = _normalScaleX;
    self.yScale = _normalScaleY;
}

@end
