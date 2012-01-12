//
//  CannonBallTrail.m
//  Rev5
//
//  Created by Bryce Redd on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CatapultBallExplosion.h"

@implementation CatapultBallExplosion

-(id) init {
	return [self initWithTotalParticles:7];
}

-(id) initWithTotalParticles:(NSUInteger)p {

	if(!(self = [super initWithTotalParticles:p]))
		return nil;
	
	// duration
	duration = 0.1f;
	
	// gravity
	self.gravity = ccp(10, 10);
	
	// angle
	self.angle = 90;
	self.angleVar = 360;
	
	// speed of particles
	self.speed = 200;
	self.speedVar = 40;
	
	// radial
	self.radialAccel = 0;
	self.radialAccelVar = 0;
	
	// tagential
	self.tangentialAccel = 0;
	self.tangentialAccelVar = 0;
	
	// emitter position
	posVar.x = 0;
	posVar.y = 0;
	
	// life of particles
	life = 0.2f;
	lifeVar = 0.2f;
	
	// size, in pixels
	startSize = 40.0f;
	startSizeVar = 20.0f;
	
	// emits per second
	emissionRate = totalParticles/duration;
	
	// color of particles
    ccColor4F start = (ccColor4F){1.f, 1.f, 1.f, .5f};
    ccColor4F end = (ccColor4F){1.f, 1.f, 1.f, 0.f};
    self.startColor = start;
    self.endColor = end;


	// must have an image or crash
	self.texture = [[CCTextureCache sharedTextureCache] addImage:@"catapultball.png"];
	
	// additive
	//self.blendAdditive = NO;
	
    

    CCSprite* expletive = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"explative%02d.png", (arc4random()%20)]]];
    expletive.scale = .6;
    expletive.anchorPoint = ccp(.5,.5);
    [expletive setOpacity:160];
    [expletive runAction:[CCScaleTo actionWithDuration:.5f scale:1.f]];
    [expletive runAction:[CCFadeOut actionWithDuration:.5f]];
    [self addChild:expletive];

	return self;
}

@end
