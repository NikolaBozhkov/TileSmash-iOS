//
//  GameCenterManager.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/4/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterManager : NSObject

+ (instancetype) sharedManager;

@property (assign, nonatomic, readonly) BOOL gameCenterEnabled;
@property (strong, nonatomic, readonly) NSString *leaderboardIdentifier;
@property (assign, nonatomic) NSInteger score;

- (void) authenticateLocalPlayer;
- (void) reportScore;
- (void) showLeaderboard:(UIViewController<GKGameCenterControllerDelegate> *) viewController;

@end
