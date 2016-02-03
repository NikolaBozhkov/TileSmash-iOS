//
//  TextureAtlases.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/13/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "TextureAtlases.h"

@implementation TextureAtlases

+ (SKTextureAtlas *) mainAtlas {
    static SKTextureAtlas *mainAtlas = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        mainAtlas = [SKTextureAtlas atlasNamed:[NSString stringWithFormat:@"Images@%dx", (int)screenScale]];
    });
    
    return mainAtlas;
}

+ (void) loadAtlases {
    [TextureAtlases mainAtlas];
}

@end
