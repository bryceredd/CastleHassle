//
//  CannonBallTrail.m
//  Rev5
//
//  Created by Bryce Redd on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CannonBallTrail.h"

@implementation CannonBallTrail
-(id) init {
	return [self initWithTotalParticles:50 color:(ccColor3B){255, 255, 255}];
}

-(id) initWithTotalParticles:(int)p color:(ccColor3B)color {
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
    duration = kCCParticleDurationInfinity;
    
    // Emitter mode: Gravity Mode
    self.emitterMode = kCCParticleModeGravity;
    
    // Gravity Mode: gravity
    self.gravity = ccp(0,0);
    
    // Gravity Mode: radial acceleration
    self.radialAccel = 0;
    self.radialAccelVar = 0;
    
    // Gravity Mode: speed of particles
    self.speed = 0;
    self.speedVar = 0;
    
    // angle
    angle = 0;
    angleVar = 0;
    
    // emitter position
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    self.position = ccp(winSize.width/2, 0);
    posVar = ccp(0, 0);
    
    // life of particles
    life = 4;
    lifeVar = 0;
    
    // size, in pixels
    startSize = 14.0f;
    startSizeVar = 0.0f;
    endSize = kCCParticleStartSizeEqualToEndSize;
    
    // emits per frame
    emissionRate = totalParticles/life;
    
    // color of particles
    ccColor4F start = (ccColor4F){(float)color.r/255.f, (float)color.g/255.f, (float)color.b/255.f, .5f};
    ccColor4F end = (ccColor4F){(float)color.r/255.f, (float)color.g/255.f, (float)color.b/255.f, 0.f};
    
    self.startColor = start;
    self.endColor = end;
    
    self.texture = [[CCTextureCache sharedTextureCache] addImage:@"balltracer.png"];
    
    self.blendAdditive = NO;
	
	
	return self;
}

@end
