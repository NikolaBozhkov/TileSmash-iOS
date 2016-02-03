//
//  TextureAtlases.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/13/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface TextureAtlases : NSObject

+ (SKTextureAtlas *) mainAtlas;

+ (void) loadAtlases;

@end
