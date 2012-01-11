//
//  CannonBallTrail.m
//  Rev5
//
//  Created by Bryce Redd on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CatapultBallTrail.h"

@implementation CatapultBallTrail
-(id) init {
	return [self initWithTotalParticles:50 color:(ccColor3B){255, 255, 255}];
}

-(id) initWithTotalParticles:(int)p color:(ccColor3B)color {
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration - this will be cut off on impact
	duration = 14.0f;
	
	// gravity
	self.gravity = ccp(0,0);
	
	// angle
	self.angle = 90;
	self.angleVar = 360;
	
	// speed of particles
	self.speed = 0;
	self.speedVar = 0;
	
	// radial
	self.radialAccel = 0;
	self.radialAccelVar = 0;
	
	// tagential
	self.tangentialAccel = 0;
	self.tangentialAccelVar = 0;
	
	// emitter position
	self.posVar = ccp(0,0);
	
	// life of particles
	self.life = 14.0;
	self.lifeVar = 0.0;
	
	// size, in pixels
	self.startSize = 14.0f;
	self.startSizeVar = 0;
    
    self.endSize = 14.f;
    self.endSizeVar = 0;
    
    // emits per second
	self.emissionRate = 30;
	
	// color of particles
    ccColor4F start = (ccColor4F){(float)color.r/255.f, (float)color.g/255.f, (float)color.b/255.f, .5f};
    ccColor4F end = (ccColor4F){(float)color.r/255.f, (float)color.g/255.f, (float)color.b/255.f, 0.f};
	
    self.startColor = start;
    self.endColor = end;
	
	self.texture = [[CCTextureCache sharedTextureCache] addImage:@"ball tracer.png"];
	
	// additive
	//blendAdditive = YES;
	
	return self;
}

@end
