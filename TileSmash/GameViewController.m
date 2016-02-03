//
//  GameViewController.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/1/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "HomeScene.h"
#import "Util.h"
#import "TextureAtlases.h"
#import "GameCenterManager.h"
#import "AdManager.h"

@implementation SKScene (Unarchive)

+ (instancetype) unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeaderboard) name:ShowLeaderboardNotification object:nil];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    Margin = self.view.frame.size.height * MarginPercent;
    
    [[AdManager sharedManager] addAdBannerToView:skView];
    
    [self setDefaultValues];
    [SKTextureAtlas preloadTextureAtlases:[NSArray arrayWithObject:[TextureAtlases mainAtlas]] withCompletionHandler:^{
        // Create and configure the scene.
        HomeScene *scene = [HomeScene sceneWithSize:self.view.frame.size];
        scene.scaleMode = SKSceneScaleModeResizeFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }];
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void) setDefaultValues {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MusicVolumeKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setFloat:DefaultMusicVolume forKey:MusicVolumeKey];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SfxOnKey] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:DefaultSfxOn forKey:SfxOnKey];
    }
}

- (void) showLeaderboard {
    [[GameCenterManager sharedManager] showLeaderboard:self];
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
