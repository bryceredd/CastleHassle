//
//  PoofAnimation.m
//  Rev5
//
//  Created by Dave Durazzani on 3/25/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import "PoofRepairAnimation.h"

@implementation PoofRepairAnimation

-(id) init {
	return [self initWithTotalParticles:7];
}

-(id) initWithTotalParticles:(NSUInteger)p {
	if(!(self=[super initWithTotalParticles:p]))
		return nil;
	
	// duration
	self.duration = 0.8f;
	
	// gravity
	self.gravity = ccp(-40.0, -40.0);
	
	// angle
	self.angle = 90;
	self.angleVar = 45;
	
	//speed of particles
	self.speed = 80;
	self.speedVar = 7;

	// start angle of the particles
	self.startSpin = 360.0f;
    
	// start angle variance
	self.startSpinVar = 5.0f;
	
	self.endSpin = 0.0f;
	
	// radial
	self.radialAccel = -1.0;
	self.radialAccelVar = 0;
	
	// tagential
	self.tangentialAccel = 400;
	self.tangentialAccelVar = 100;
	
	// emitter position
	self.posVar = ccp(10, 10);
	
	// life of particles
	self.life = 0.3f;
	self.lifeVar = 0.0f;
	
	// size, in pixels
	self.startSize = 2.0f;
	self.startSizeVar = 5.0f;
	self.endSize = 12;
	
	// emits per second
	self.emissionRate = totalParticles/duration;
	
	
	// color of particles
    self.startColor = (ccColor4F){0.164f, 0.796f, 0.039f, 1.f};
    self.startColor = (ccColor4F){0.164f, 0.796f, 0.039f, .5f};
	
	
	// must have an image or crash
	self.texture = [[CCTextureCache sharedTextureCache] addImage:@"heal.png"];
	

	return self;
}

@end
