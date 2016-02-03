//
//  PlayerProfile.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/5/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BestScoreKey;
extern NSString *const MostTilesDestroyedKey;
extern NSString *const TopStreakKey;
extern NSString *const LongestGameTimeKey;
extern NSString *const TotalGameTimeKey;

@interface PlayerProfile : NSObject

+ (instancetype) sharedInstance;

@property (assign, nonatomic) NSInteger bestScore;
@property (assign, nonatomic) NSInteger mostTilesDestroyed;
@property (assign, nonatomic) NSInteger topStreak;
@property (assign, nonatomic) NSTimeInterval longestGameTime;
@property (assign, nonatomic) NSTimeInterval totalGameTime;

@end
