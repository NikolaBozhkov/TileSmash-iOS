//
//  AdAdjustableScene.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/24/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class HighlightSpriteNode;

@interface AdAdjustableScene : SKScene

@property (strong, nonatomic, readonly) HighlightSpriteNode *backButton;

@end
