//
//  BlueSlider.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 3/2/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *minimumTrackImage = [[UIImage imageNamed:@"barRed_horizontalLeft"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [self setMinimumTrackImage:minimumTrackImage forState:UIControlStateNormal];
        [self setMaximumTrackTintColor:[UIColor grayColor]];
    }
    
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    [super trackRectForBounds:bounds];
    return CGRectMake(bounds.origin.x, bounds.origin.y - self.currentMinimumTrackImage.size.height / 2,
                      bounds.size.width, self.currentMinimumTrackImage.size.height);
}

@end
