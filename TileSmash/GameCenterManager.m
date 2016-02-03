//
//  GameCenterManager.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 4/4/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "GameCenterManager.h"
#import "PlayerProfile.h"

static NSString *const GameCenterUnavailableTitle = @"Game Center Unavailable";
static NSString *const GameCenterUnavailableMessage = @"Player is not signed in";

@interface GameCenterManager ()

@property (assign, nonatomic) BOOL gameCenterEnabled;
@property (strong, nonatomic) NSString *leaderboardIdentifier;

@end

@implementation GameCenterManager

+ (instancetype) sharedManager {
    static GameCenterManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[GameCenterManager alloc] init];
    });
    
    return sharedManager;
}

- (void) authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if ([GKLocalPlayer localPlayer].authenticated) {
            _gameCenterEnabled = YES;
            
            // Get the default leaderboard identifier.
            [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                
                if (error != nil) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                else{
                    _leaderboardIdentifier = leaderboardIdentifier;
                    _score = [PlayerProfile sharedInstance].bestScore;
                    [self reportScore];
                }
            }];
        } else {
            _gameCenterEnabled = NO;
        }
    };
}

- (void) reportScore {
    if (!_gameCenterEnabled || !_leaderboardIdentifier) {
        return;
    }
    
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = _score;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void) showLeaderboard:(UIViewController<GKGameCenterControllerDelegate> *) viewController {
    [self authenticateLocalPlayer];
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (!localPlayer.authenticated) {
        UIAlertView *notSignedAlert = [[UIAlertView alloc] initWithTitle:GameCenterUnavailableTitle message:GameCenterUnavailableMessage
                                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notSignedAlert show];
        return;
    }
    
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = viewController;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    
    [viewController presentViewController:gcViewController animated:YES completion:nil];
}

@end
