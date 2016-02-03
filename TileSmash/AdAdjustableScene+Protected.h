//
//  AdAdjustableScene+Protected.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/24/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#ifndef TileSmash_AdAdjustableScene_Protected_h
#define TileSmash_AdAdjustableScene_Protected_h

#import "HighlightSpriteNode.h"
#import "AdAdjustableScene.h"

@interface AdAdjustableScene ()

@property (strong, nonatomic) HighlightSpriteNode *backButton;

- (void) adjustForAd;
- (void) adjustToOriginal;

@end


#endif
