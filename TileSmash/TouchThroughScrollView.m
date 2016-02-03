//
//  TouchThroughScrollView.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/16/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "TouchThroughScrollView.h"
#import "AdManager.h"

#import <SpriteKit/SpriteKit.h>

@implementation TouchThroughScrollView {
    NSSet *_nodes;
}

- (instancetype)initWithFrame:(CGRect)frame nodes:(NSSet *)nodes {
    if (self = [super initWithFrame:frame]) {
        _nodes = nodes;
    }
    
    return self;
}

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self checkIfPointIsTouchThrough:point]) {
        return NO;
    }
    
    return YES;
}

- (BOOL) checkIfPointIsTouchThrough:(CGPoint)point {
    point = CGPointMake((int)point.x % (int)[UIScreen mainScreen].bounds.size.width,
                        [UIScreen mainScreen].bounds.size.height - point.y);
    for (id node in _nodes) {
        if ([node isKindOfClass:[SKNode class]]) {
            if ([node containsPoint:point]) {
                return YES;
            }
        }
    }
    
    if ([AdManager sharedManager].isActive) {
        if (point.y <= 50) {
            return YES;
        }
    }
    
    return NO;
}

@end
