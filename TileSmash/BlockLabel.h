//
//  BlockLabel.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/20/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BlockLabel : SKNode

+ (BlockLabel *) BlockLabelWithLabel:(SKLabelNode *)label color:(SKColor *)color
                            position:(CGPoint)position lineHeight:(CGFloat)lineHeight
                                size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
                   paddingHorizontal:(CGFloat)paddingHorizontal paddingVertical:(CGFloat)paddingVertical;

@property (strong, nonatomic, readonly) SKLabelNode *label;
@property (strong, nonatomic) SKShapeNode *block;

@end
