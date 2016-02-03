//
//  TutorialScene.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/10/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "AdAdjustableScene+Protected.h"
#import "TutorialScene.h"
#import "Util.h"
#import "Colors.h"
#import "HighlightSpriteNode.h"
#import "MusicManager.h"
#import "HomeScene.h"
#import "TouchThroughScrollView.h"
#import "AdManager.h"
#import "ImageNames.h"

static NSString *const FirstPageText = @"Smash all tiles of the selected color, before the time runs out. You have 6 seconds before the color changes.\nWhen the time ends or all selected tiles are smashed, the color changes and the timer resets.";
static NSString *const SecondPageText = @"If a selected tile is not smashed within the time interval, it turns to metal and can no longer be destroyed. You can have only 10 metal blocks before the game ends, so be careful.\nEach block reduces time by 0.3 seconds. A metal block bar is tracking the danger level.";
static NSString *const ThirdPageText = @"Tiles give 3 point, when their color is selected and 1, when it is not.\n\nWhen you do not have a new metal block 3 color changes in a row, you get a streak bonus. The streak bonus is 5 points and is increased by 5 every consecutive round. When a tile turns to metal the streak stops and the bonus is reset.";
static NSString *const FourthPageText = @"Tips:\n\nWhen you have time, leave one tile, crack all of the other colors and smash the tile you left right before the time runs out.\n\nWhen there are too many tiles of one color, use another color's time to smash them or just catch up.";
static NSString *const HappySmashingText = @"Happy smashing! : )";

static const CGFloat ViewCount = 4;
static const CGFloat ViewMarginPercent = 0.06;
static const CGFloat FontSizePercent = 0.052;
static const CGFloat PageControlYPercent = 0.88;
static const CGFloat SmallScreenMarginMultiplier = 0.125;

@implementation TutorialScene {
    TouchThroughScrollView *_scrollView;
    UIPageControl *_pageControl;
    CGFloat _viewMargin;
    CGFloat _fontSize;
}

@synthesize backButton = _backButton;

- (void) adjustForAd {
    CGFloat buttonY = ScreenHeight == 480 ? _viewMargin * SmallScreenMarginMultiplier : _viewMargin; // style fix for 3.5"
    _backButton.position = CGPointMake(_backButton.position.x, buttonY + 50);
}

- (void) didMoveToView:(SKView *)view {
    _viewMargin = ScreenWidth * ViewMarginPercent;
    _fontSize = ScreenWidth * FontSizePercent;
    
    [self placeBackgroundImage];
    [self placeBackButton];
    
    _scrollView = [[TouchThroughScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)
                                                                                 nodes:[NSSet setWithObject:_backButton]];
    _scrollView.contentSize = CGSizeMake(ScreenWidth * ViewCount, ScreenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;

    for (int i = 0; i < ViewCount; i++) {
        CGFloat x = i * ScreenWidth;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x + _viewMargin, _viewMargin, ScreenWidth - _viewMargin * 2, ScreenHeight - _viewMargin * 2)];
        [self setupView:view byNumber:i];
        [_scrollView addSubview:view];
    }
    
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(ScreenWidth / 2, ScreenHeight * PageControlYPercent, 0, 0)];
    _pageControl.numberOfPages = ViewCount;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
}

- (void) placeBackgroundImage {
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:[ImageNames stripesBackground]];
    background.anchorPoint = CGPointZero;
    background.zPosition = -1;
    [self addChild:background];
}

- (void) placeBackButton {
    _backButton = [HighlightSpriteNode spriteNodeWithImageNamed:[ImageNames backButton] highlightScale:ButtonHighlightScale];
    _backButton.anchorPoint = CGPointZero;
    _backButton.position = CGPointMake(_viewMargin, _viewMargin);
    _backButton.zPosition = 10;
    if ([AdManager sharedManager].isActive) {
        [self adjustForAd];
    }
    
    [self addChild:_backButton];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    _pageControl.currentPage = page;
}

- (void) setupView:(UIView *)view byNumber:(NSInteger)number {
    UILabel *label;
    NSString *imageName;
    
    if (number == 0) {
        label = [self addLabelWithPosition:CGPointZero text:FirstPageText toView:view];
        imageName = [ImageNames tutorialColorTimer];
    } else if (number == 1) {
        label = [self addLabelWithPosition:CGPointZero text:SecondPageText toView:view];
        imageName = [ImageNames tutorialMetalBlockBar];
    } else if (number == 2) {
        label = [self addLabelWithPosition:CGPointZero text:ThirdPageText toView:view];
    } else if (number == 3) {
        label = [self addLabelWithPosition:CGPointZero text:FourthPageText toView:view];
        CGPoint endTextPosition = CGPointMake(view.frame.size.width / 2, label.frame.size.height + Margin);
        UILabel *endText = [self addLabelWithPosition:endTextPosition text:HappySmashingText toView:view];
        endText.frame = CGRectMake(endText.frame.origin.x - endText.frame.size.width / 2, endText.frame.origin.y,
                                   endText.frame.size.width, endText.frame.size.height);
    }
    
    if (imageName != nil) {
        UIImage *image = [UIImage imageNamed:imageName];
        CGFloat imageMargin = ScreenWidth * 0.025;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, label.frame.size.height + imageMargin,
                                                                               image.size.width, image.size.height)];
        imageView.image = image;
        [view addSubview:imageView];
    }
}

- (UILabel *) addLabelWithPosition:(CGPoint)position text:(NSString *)text toView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(position.x, position.y, view.frame.size.width, 0)];
    label.font = [UIFont fontWithName:MainFont size:_fontSize];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = text;
    
    [label sizeToFit];
    [view addSubview:label];
    
    return label;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    if ([_backButton containsPoint:location]) {
        [_backButton highlight];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    if ([_backButton containsPoint:location]) {
        [_backButton highlight];
    } else {
        [_backButton unhighlight];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInNode:self];
    
    if ([_backButton containsPoint:location]) {
        [[MusicManager sharedManager] playSoundSFX:ButtonTapSFXName ofType:@"wav"];
        HomeScene *scene = [HomeScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

- (void) clearSubviews {
    [_scrollView removeFromSuperview];
    [_pageControl removeFromSuperview];
}

- (void) willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
    [self clearSubviews];
}

@end
