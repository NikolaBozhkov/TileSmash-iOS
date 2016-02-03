//
//  Util.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/2/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "Util.h"
#import "MusicManager.h"

@implementation Util

+ (SKLabelNode *) labelWithFont:(NSString *)font text:(NSString *)text fontColor:(SKColor *)color fontSize:(NSInteger)fontSize {
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:font];
    label.text = text;
    label.fontColor = color;
    label.fontSize = fontSize;
    return label;
}

+ (void) adjustFontSizeOfLabel:(SKLabelNode *)label byWidth:(CGFloat)width {
    while (width != 0 && label.frame.size.width > width) {
        label.fontSize = label.fontSize > 1 ? label.fontSize - 1 : 1;
    }
}

@end
