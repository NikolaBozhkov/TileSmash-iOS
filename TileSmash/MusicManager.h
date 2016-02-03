//
//  MusicManager.h
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/21/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <SpriteKit/SpriteKit.h>

@interface MusicManager : NSObject {
    AVAudioPlayer *backgroundMusicPlayer;
    AVAudioPlayer *sfxPlayer;
}

@property (assign, nonatomic) CGFloat volume;
@property (assign, nonatomic) BOOL sfxOn;
@property (assign, nonatomic) BOOL musicOn;

+ (instancetype) sharedManager;
- (void) playBackgroundMusic:(NSString *)fileName ofType:(NSString *) type numberOfLoops:(NSInteger)numberOfLoops;
- (void) playSoundSFX:(NSString *)fileName ofType:(NSString *)type;
- (void) playActionSoundSFX:(NSString *)fileName target:(SKNode *)target;
- (void) stopBackgroundMusic;
- (void) restartBackgroundMusic;
- (void) pauseBackgroundMusic;
- (void) resumeBackgroundMusic;

@end
