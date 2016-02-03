//
//  SwitchButton.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/9/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "SwitchButton.h"

@interface SwitchButton ()

@property (assign, nonatomic) BOOL on;
@property (strong, nonatomic) SKTexture *onTexture;
@property (strong, nonatomic) SKTexture *offTexture;

@end

@implementation SwitchButton

+ (instancetype) switchButtonWithOnImageNamed:(NSString *)onName offImageNamed:(NSString *)offName
                               highlightScale:(CGFloat)highlightScale on:(BOOL)on {
    NSString *currentImageName = on ? onName : offName;
    SwitchButton *button = [self spriteNodeWithImageNamed:currentImageName highlightScale:highlightScale];
    button.onTexture = [SKTexture textureWithImageNamed:onName];
    button.offTexture = [SKTexture textureWithImageNamed:offName];
    button.on = on;
    
    return button;
}

- (void) toggleState {
    self.texture = _on ? _offTexture : _onTexture;
    _on = !_on;
}

@end
