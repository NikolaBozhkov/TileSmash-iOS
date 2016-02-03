//
//  ImageNames.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 9/15/15.
//  Copyright (c) 2015 Nikola Bozhkov. All rights reserved.
//

#import "ImageNames.h"
#import "Util.h"

@implementation ImageNames

+ (NSString *) cracks {
    return [NSString stringWithFormat:@"cracks-%ldw", (long)ScreenWidth];
}

+ (NSString *) metalBlock {
    return [NSString stringWithFormat:@"metal_block-%ldw", (long)ScreenWidth];
}

+ (NSString *) backButton {
    return [NSString stringWithFormat:@"back_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) homeButton {
    return [NSString stringWithFormat:@"home_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) homeButtonSmall {
    return [NSString stringWithFormat:@"home_button_small-%ldw", (long)ScreenWidth];
}

+ (NSString *) leaderboardButton {
    return [NSString stringWithFormat:@"leaderboard_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) musicButtonOn {
    return [NSString stringWithFormat:@"music_button_on-%ldw", (long)ScreenWidth];
}

+ (NSString *) musicButtonOnSmall {
    return [NSString stringWithFormat:@"music_button_on_small-%ldw", (long)ScreenWidth];
}

+ (NSString *) musicButtonOff {
    return [NSString stringWithFormat:@"music_button_off-%ldw", (long)ScreenWidth];
}

+ (NSString *) musicButtonOffSmall {
    return [NSString stringWithFormat:@"music_button_off_small-%ldw", (long)ScreenWidth];
}

+ (NSString *) optionsButton {
    return [NSString stringWithFormat:@"options_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) optionsLabel {
    return [NSString stringWithFormat:@"options_label-%ldw", (long)ScreenWidth];
}

+ (NSString *) pauseButton {
    return [NSString stringWithFormat:@"pause_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) playButton {
    return [NSString stringWithFormat:@"play_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) restartButtonSmall {
    return [NSString stringWithFormat:@"restart_button_small-%ldw", (long)ScreenWidth];
}

+ (NSString *) restartButton {
    return [NSString stringWithFormat:@"restart_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) resumeButton {
    return [NSString stringWithFormat:@"resume_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) soundsButtonOn {
    return [NSString stringWithFormat:@"sounds_button_on-%ldw", (long)ScreenWidth];
}

+ (NSString *) soundsButtonOnSmall {
    return [NSString stringWithFormat:@"sounds_button_on_small-%ldw", (long)ScreenWidth];
}

+ (NSString *) soundsButtonOff {
    return [NSString stringWithFormat:@"sounds_button_off-%ldw", (long)ScreenWidth];
}

+ (NSString *) soundsButtonOffSmall {
    return [NSString stringWithFormat:@"sounds_button_off_small-%ldw", (long)ScreenWidth];
}

+ (NSString *) statsButton {
    return [NSString stringWithFormat:@"stats_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) statsLabel {
    return [NSString stringWithFormat:@"stats_label-%ldw", (long)ScreenWidth];
}

+ (NSString *) tutorialButton {
    return [NSString stringWithFormat:@"tutorial_button-%ldw", (long)ScreenWidth];
}

+ (NSString *) tutorialMetalBlockBar {
    return [NSString stringWithFormat:@"tutorial_metal_block_bar_image-%ldw", (long)ScreenWidth];
}

+ (NSString *) tutorialColorTimer {
    return [NSString stringWithFormat:@"tutorial_color_timer_image-%ldw", (long)ScreenWidth];
}


+ (NSString *) homeBackground {
    return [NSString stringWithFormat:@"home_background-%ldh", (long)ScreenHeight];
}

+ (NSString *) stripesBackground {
    return [NSString stringWithFormat:@"stripes_background-%ldh", (long)ScreenHeight];
}

+ (NSString *) devInfo {
    return [NSString stringWithFormat:@"dev_info-%ldh", (long)ScreenHeight];
}

+ (NSString *) gameOverBackground {
    return [NSString stringWithFormat:@"game_over_background-%ldw", (long)ScreenWidth];
}

+ (NSString *) pausedBackground {
    return [NSString stringWithFormat:@"paused_background-%ldw", (long)ScreenWidth];
}

@end
