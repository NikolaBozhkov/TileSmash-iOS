//
//  BlockLabel.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/20/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "BlockLabel.h"
#import "Util.h"

@interface BlockLabel ()

@property (strong, nonatomic) SKLabelNode *label;

@end

@implementation BlockLabel

+ (BlockLabel *) BlockLabelWithLabel:(SKLabelNode *)label color:(SKColor *)color
                            position:(CGPoint)position lineHeight:(CGFloat)lineHeight
                                size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
                   paddingHorizontal:(CGFloat)paddingHorizontal paddingVertical:(CGFloat)paddingVertical {
    SKShapeNode *labelBackground = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(size.width + paddingHorizontal,
                                                                                   size.height + paddingVertical)
                                                           cornerRadius:cornerRadius];
    labelBackground.lineWidth = 0;
    labelBackground.fillColor = color;
    label.position = CGPointMake(0, -label.frame.size.height / 2 + lineHeight / 2);
    [labelBackground addChild:label];
    
    BlockLabel *blockLabel = [self node];
    blockLabel.label = label;
    blockLabel.block = labelBackground;
    blockLabel.position = CGPointMake(position.x + labelBackground.frame.size.width / 2,
                                      position.y - labelBackground.frame.size.height / 2);
    
    [blockLabel addChild:labelBackground];
    
    return blockLabel;
}

@end
