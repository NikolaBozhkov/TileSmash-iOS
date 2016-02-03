//
//  SwitchButton.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/9/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "HighlightSpriteNode.h"

@interface SwitchButton : HighlightSpriteNode

+ (instancetype) switchButtonWithOnImageNamed:(NSString *)onName offImageNamed:(NSString *)offName
                               highlightScale:(CGFloat)highlightScale on:(BOOL)on;

@property (assign, nonatomic, readonly) BOOL on;

- (void) toggleState;

@end
