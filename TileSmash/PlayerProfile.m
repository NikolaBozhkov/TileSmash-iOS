//
//  PlayerProfile.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/5/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "PlayerProfile.h"
#import "GameCenterManager.h"

NSString *const BestScoreKey = @"BestScore";
NSString *const MostTilesDestroyedKey = @"MostTilesSmashed";
NSString *const TopStreakKey = @"TopStreak";
NSString *const LongestGameTimeKey = @"LongestGameTime";
NSString *const TotalGameTimeKey = @"TotalGameTime";

@implementation PlayerProfile

+ (instancetype) sharedInstance {
    static PlayerProfile *playerProfile = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerProfile = [[PlayerProfile alloc] init];
    });
    
    return playerProfile;
}

- (instancetype) init {
    if (self = [super init]) {
        [self assignDefaultValuesIfNotExisting];
        _bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:BestScoreKey];
        _mostTilesDestroyed = [[NSUserDefaults standardUserDefaults] integerForKey:MostTilesDestroyedKey];
        _topStreak = [[NSUserDefaults standardUserDefaults] integerForKey:TopStreakKey];
        _longestGameTime = [[NSUserDefaults standardUserDefaults] doubleForKey:LongestGameTimeKey];
        _totalGameTime = [[NSUserDefaults standardUserDefaults] doubleForKey:TotalGameTimeKey];
    }
    
    return self;
}

- (void) setBestScore:(NSInteger)bestScore {
    if (bestScore > _bestScore) {
        _bestScore = bestScore;
        [[NSUserDefaults standardUserDefaults] setInteger:_bestScore forKey:BestScoreKey];
    }
}

- (void) setMostTilesDestroyed:(NSInteger)mostTilesSmashed {
    if (mostTilesSmashed > _mostTilesDestroyed) {
        _mostTilesDestroyed = mostTilesSmashed;
        [[NSUserDefaults standardUserDefaults] setInteger:_mostTilesDestroyed forKey:MostTilesDestroyedKey];
    }
}

- (void) setTopStreak:(NSInteger)topStreak {
    if (topStreak > _topStreak) {
        _topStreak = topStreak;
        [[NSUserDefaults standardUserDefaults] setInteger:_topStreak forKey:TopStreakKey];
    }
}

- (void) setLongestGameTime:(NSTimeInterval)longestGameTime {
    if (longestGameTime > _longestGameTime) {
        _longestGameTime = longestGameTime;
        [[NSUserDefaults standardUserDefaults] setDouble:_longestGameTime forKey:LongestGameTimeKey];
    }
}

- (void) setTotalGameTime:(NSTimeInterval)totalGameTime {
    if (totalGameTime > _totalGameTime) {
        _totalGameTime = totalGameTime;
        [[NSUserDefaults standardUserDefaults] setDouble:_totalGameTime forKey:TotalGameTimeKey];
    }
}

- (void) assignDefaultValuesIfNotExisting {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:BestScoreKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:BestScoreKey];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MostTilesDestroyedKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:MostTilesDestroyedKey];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TopStreakKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:TopStreakKey];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LongestGameTimeKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:LongestGameTimeKey];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TotalGameTimeKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:TotalGameTimeKey];
    }
}

@end
