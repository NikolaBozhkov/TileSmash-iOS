//
//  MusicManager.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 2/21/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "MusicManager.h"
#import "Util.h"

@interface MusicManager ()

@property (strong, nonatomic) NSMutableDictionary *sfxDictionary;

@end

@implementation MusicManager {
    NSString *_lastPlayedMusicName;
    NSString *_lastPlayedMusicExtension;
}

+ (instancetype) sharedManager {
    static MusicManager *sharedMusicManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMusicManager = [[self alloc] init];
        sharedMusicManager.sfxDictionary = [NSMutableDictionary new];
        sharedMusicManager.sfxOn = [[NSUserDefaults standardUserDefaults] boolForKey:SfxOnKey];
        sharedMusicManager.volume = [[NSUserDefaults standardUserDefaults] floatForKey:MusicVolumeKey];
    });
    
    return sharedMusicManager;
}

- (void) setVolume:(CGFloat)volume {
    _volume = volume;
    backgroundMusicPlayer.volume = volume;
    [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:MusicVolumeKey];
    
    if (volume == 0) {
        _musicOn = NO;
    } else {
        _musicOn = YES;
    }
}

- (void) setSfxOn:(BOOL)sfxOn {
    _sfxOn = sfxOn;
    [[NSUserDefaults standardUserDefaults] setBool:sfxOn forKey:SfxOnKey];
}

- (void) stopBackgroundMusic {
    [backgroundMusicPlayer stop];
}

- (void) restartBackgroundMusic {
    [self stopBackgroundMusic];
    [self playBackgroundMusic:_lastPlayedMusicName ofType:_lastPlayedMusicExtension numberOfLoops:-1];
}

- (void) pauseBackgroundMusic {
    [backgroundMusicPlayer pause];
}

- (void) resumeBackgroundMusic {
    [backgroundMusicPlayer play];
}

- (void) playBackgroundMusic:(NSString *)fileName ofType:(NSString *)type numberOfLoops:(NSInteger)numberOfLoops {
    if ([backgroundMusicPlayer isPlaying]) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:type]];
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    backgroundMusicPlayer.volume = _volume;
    backgroundMusicPlayer.numberOfLoops = numberOfLoops;
    [backgroundMusicPlayer play];
    
    _lastPlayedMusicName = fileName;
    _lastPlayedMusicExtension = type;
}

- (void) playSoundSFX:(NSString *)fileName ofType:(NSString *)type {
    if (!_sfxOn) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:type]];
    sfxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    sfxPlayer.numberOfLoops = 0;
    [sfxPlayer play];
}

- (void) playActionSoundSFX:(NSString *)fileName target:(SKNode *)target {
    if (!_sfxOn) {
        return;
    }
    
    if (_sfxDictionary[fileName] == nil) {
        SKAction *sfxAction = [SKAction playSoundFileNamed:fileName waitForCompletion:NO];
        [_sfxDictionary setObject:sfxAction forKey:fileName];
    }
    
    [target runAction:_sfxDictionary[fileName]];
}

@end
