//
//  TileNode.m
//  TileSmash
//
//  Created by Nikola Bozhkov on 12/5/14.
//  Copyright (c) 2014 Nikola Bozhkov. All rights reserved.
//

#import "TileNode.h"
#import "Util.h"
#import "Colors.h"
#import "MusicManager.h"
#import "TextureAtlases.h"
#import "ImageNames.h"

static const NSInteger DefaultSelectedPoints = 3;
static const NSInteger DefaultUnselectedPoints = 1;

static const CGFloat GlowAlpha = 0.45;
static const CGFloat GlowFadeFrom = 0.4;
static const CGFloat GlowFadeTo = 0.7;
static const NSTimeInterval GlowFadeDuration = 0.5;

static const CGFloat CrackScaleFrom = 0.92;
static const CGFloat CrackScaleTo = 1.0;
static const NSTimeInterval CrackScaleDuration = 0.07;

static const NSTimeInterval BlockedTileMoveDuration = 0.04;

static const CGFloat TileCornerRadius = 5.0;

static NSString *const TileExplosionFileName = @"TileExplosion";

NSString *const TileName = @"Tile";
NSString *const TileDestroyedNotification = @"TileDestroyedNotification";
NSString *const TileChangedColorNotification = @"TileChangedColorNotification";

static NSString *const CrackSFXFileName = @"pop.wav";
static NSString *const BreakSFXFileName = @"bubble_pop.wav";
static NSString *const BlockedHitSFXFileName = @"blocked_hit.wav";

@interface TileNode ()

@property (assign, nonatomic) NSInteger selectedPoints;
@property (assign, nonatomic) NSInteger unselectedPoints;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isCracked;
@property (assign, nonatomic) BOOL isBlocked;

@end

@implementation TileNode {
    SKShapeNode *_glowEffect;
}

static NSMutableDictionary *_colorTextures = nil;

+ (instancetype) tileWithSize:(CGSize)size position:(CGPoint)position color:(SKColor *)color view:(SKView *)view {
    SKTexture *tileTexture = [TileNode getTileTexture:size color:color view:view];
    TileNode *tile = [self spriteNodeWithTexture:tileTexture];
    tile.position = CGPointMake(position.x + tile.frame.size.width / 2, position.y - tile.frame.size.height / 2); // anchor 0;1
    
    tile.tileColor = color;
    tile.selectedPoints = DefaultSelectedPoints;
    tile.unselectedPoints = DefaultUnselectedPoints;
    tile.isSelected = NO;
    tile.isCracked = NO;
    tile.name = TileName;
    [tile setupGlowEffect];
    
    return tile;
}

+ (instancetype) tileWithRandomColorWithSize:(CGSize)size position:(CGPoint)position view:(SKView *)view {
    SKColor *randomColor = [[Colors instance] getRandomColor];
    TileNode *tile = [TileNode tileWithSize:size position:position color:randomColor view:view];
    return tile;
}

+ (SKAction *) crackAnimation {
    static SKAction *_crackAnimation = nil;
    
    if (_crackAnimation == nil) {
        NSArray *sequence = @[[SKAction scaleTo:CrackScaleFrom duration:CrackScaleDuration],
                              [SKAction scaleTo:CrackScaleTo duration:CrackScaleDuration]];
        _crackAnimation = [SKAction sequence:sequence];
    }
    
    return _crackAnimation;
}

+ (SKAction *) blockedTileTapAnimation {
    static SKAction *_blockedTileTapAnimation = nil;
    
    if (_blockedTileTapAnimation == nil) {
        CGFloat moveBy = Margin / 3.5;
        NSArray *sequence = @[[SKAction moveBy:CGVectorMake(-moveBy, 0) duration:BlockedTileMoveDuration],
                              [SKAction moveBy:CGVectorMake(moveBy * 2, 0) duration:BlockedTileMoveDuration * 2],
                              [SKAction moveBy:CGVectorMake(-moveBy, 0) duration:BlockedTileMoveDuration]];
        _blockedTileTapAnimation = [SKAction sequence:sequence];
    }
    
    return _blockedTileTapAnimation;
}

+ (SKAction *) glowAnimation {
    static SKAction *_glowAnimation = nil;
    
    if (_glowAnimation == nil) {
        NSArray *sequence = @[[SKAction fadeAlphaTo:GlowFadeFrom duration:GlowFadeDuration],
                              [SKAction fadeAlphaTo:GlowFadeTo duration:GlowFadeDuration]];
        _glowAnimation = [SKAction repeatActionForever:[SKAction sequence:sequence]];
    }
    
    return _glowAnimation;
}

+ (SKTexture *) getTileTexture:(CGSize)size color:(SKColor *)color view:(SKView *)view {
    if (_colorTextures == nil) {
        _colorTextures = [NSMutableDictionary new];
    }
    
    if (_colorTextures[color] == nil) {
        SKShapeNode *tileShape = [SKShapeNode shapeNodeWithRectOfSize:size cornerRadius:TileCornerRadius];
        tileShape.lineWidth = 0;
        tileShape.fillColor = color;
        SKTexture *texture = [view textureFromNode:tileShape];
        
        [_colorTextures setObject:texture forKey:color];
    }
    
    return (SKTexture *)_colorTextures[color];
}

- (void) setupGlowEffect {
    _glowEffect = [SKShapeNode shapeNodeWithRectOfSize:self.size cornerRadius:TileCornerRadius];
    
    _glowEffect.strokeColor = [SKColor blackColor];
    _glowEffect.glowWidth = Margin / 2.;
    _glowEffect.alpha = GlowAlpha;
    _glowEffect.zPosition = -1;
}

- (void) toggleSelected {
    if (_isSelected) {
        [_glowEffect removeAllActions];
        [_glowEffect removeFromParent];
    } else {
        [self addChild:_glowEffect];
        [_glowEffect runAction:[TileNode glowAnimation]];
    }
    
    _isSelected = !_isSelected;
}

- (void) reset {
    [self removeAllChildren];
    _isSelected = NO;
    _isCracked = NO;
    self.alpha = 1.0;
}

- (void) changeColor {
    SKColor *prevColor = _tileColor;
    do {
        _tileColor = [[Colors instance] getRandomColor];
    } while (prevColor.hash == _tileColor.hash);
    
    self.texture = [TileNode getTileTexture:self.size color:_tileColor view:self.scene.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:TileChangedColorNotification object:self];
}

- (void) blockTile {
    [self reset];
    _isBlocked = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:TileDestroyedNotification object:self];
    self.texture = [[TextureAtlases mainAtlas] textureNamed:[ImageNames metalBlock]];
}

- (void) crack {
    SKSpriteNode *cracks = [SKSpriteNode spriteNodeWithTexture:[[TextureAtlases mainAtlas] textureNamed:[ImageNames cracks]]];
    cracks.name = TileName;
    if (ScreenHeight == 480) {
        cracks.size = self.size;
    }
    
    cracks.color = [SKColor blackColor];
    cracks.colorBlendFactor = 0.9;
    cracks.zPosition = self.zPosition + 0.01; // Sometimes the cracks are not on top, this is a fix
    [self addChild:cracks];
    [self runAction:[TileNode crackAnimation]];
    [[MusicManager sharedManager] playActionSoundSFX:CrackSFXFileName target:self];
    _isCracked = YES;
}

- (void) createExplosion {
    NSString *path = [[NSBundle mainBundle] pathForResource:TileExplosionFileName ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    explosion.position = self.position;
    explosion.zPosition = 1;
    explosion.particleColor = _tileColor;
    SKAction *sequence = [SKAction sequence:@[[SKAction waitForDuration:explosion.particleLifetime + 1],
                                              [SKAction removeFromParent]]];
    [[self parent] addChild:explosion];
    [explosion runAction:sequence];
    [[MusicManager sharedManager] playActionSoundSFX:BreakSFXFileName target:self];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_isBlocked) {
        [self runAction:[TileNode blockedTileTapAnimation]];
        [[MusicManager sharedManager] playActionSoundSFX:BlockedHitSFXFileName target:self];
        return;
    }
    
    if (_isCracked) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TileDestroyedNotification object:self];
        [self createExplosion];
        [self reset];
        [self changeColor];
    } else {
        [self crack];
    }
}

@end
