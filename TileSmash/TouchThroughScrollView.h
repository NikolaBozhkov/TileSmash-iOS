//
//  TouchThroughScrollView.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/16/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchThroughScrollView : UIScrollView

- (instancetype) initWithFrame:(CGRect)frame nodes:(NSSet *)nodes;

@end
