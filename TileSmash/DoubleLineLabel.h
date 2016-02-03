//
//  DoubleLineLabel.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/13/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface DoubleLineLabel : SKLabelNode

+ (instancetype) doubleLineLabelWithFontSize:(CGFloat)fontSize firstLine:(NSString *)firstLine
                                  secondLine:(NSString *)secondLine lineHeight:(CGFloat)lineHeight;

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic, readonly) SKLabelNode *firstLineLabel;
@property (strong, nonatomic, readonly) SKLabelNode *secondLineLabel;

@end
