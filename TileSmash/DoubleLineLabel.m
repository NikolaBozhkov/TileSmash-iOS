//
//  DoubleLineLabel.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/13/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "DoubleLineLabel.h"
#import "Util.h"

@interface DoubleLineLabel ()

@property (strong, nonatomic) SKLabelNode *firstLineLabel;
@property (strong, nonatomic) SKLabelNode *secondLineLabel;

@end

@implementation DoubleLineLabel

+ (instancetype)doubleLineLabelWithFontSize:(CGFloat)fontSize firstLine:(NSString *)firstLine
                                 secondLine:(NSString *)secondLine lineHeight:(CGFloat)lineHeight {
    SKLabelNode *firstLineLabel = [Util labelWithFont:MainFont text:firstLine fontColor:[SKColor whiteColor] fontSize:fontSize];
    SKLabelNode *secondLineLabel = [Util labelWithFont:MainFont text:secondLine fontColor:[SKColor whiteColor] fontSize:fontSize];
    firstLineLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    secondLineLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    secondLineLabel.position = CGPointMake(0, -(firstLineLabel.frame.size.height + lineHeight));
    
    DoubleLineLabel *doubleLineLabel = [self node];
    [doubleLineLabel addChild:firstLineLabel];
    [doubleLineLabel addChild:secondLineLabel];
    
    CGFloat greaterWidth = firstLineLabel.frame.size.width > secondLineLabel.frame.size.width ? firstLineLabel.frame.size.width : secondLineLabel.frame.size.width;
    doubleLineLabel.size = CGSizeMake(greaterWidth, firstLineLabel.frame.size.height + secondLineLabel.frame.size.height + lineHeight);
    
    doubleLineLabel.firstLineLabel = firstLineLabel;
    doubleLineLabel.secondLineLabel = secondLineLabel;
    
    return doubleLineLabel;
}

@end
