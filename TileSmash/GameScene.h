//
//  GameScene.h
//  TileSmash
//

//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static NSString *const PauseGameNotificatonName = @"PauseGame";

@interface GameScene : SKScene

- (void) unpause;

@end
