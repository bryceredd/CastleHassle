//
//  CannonBall.m
//  Rev3
//
//  Created by Bryce Redd on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CatapultBall.h"
#import "CatapultBallExplosion.h"
#import "CatapultBallTrail.h"
#import "Battlefield.h"
#import "GameSettings.h"

@implementation CatapultBall

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p level:(int)l shooter:(PlayerArea*)s {
	if((self = [super initWithCoords:p world:w from:s])) {
		
		bounces = 1;
		baseDamage = CATAPULTBALL_BASE_DAMAGE;
		
		[self setupSpritesWithRect:CGRectMake(0,0,11,10) image:CATAPULTBALL_IMAGE atPoint:p];
		
		// Define another box shape for our dynamic body.
		b2PolygonShape dynamicBox;
		
		// we need to make this a slightly weighted object as we have an offset
		dynamicBox.SetAsBox(11.0/PTM_RATIO*.5, 11.0/PTM_RATIO*.5); //These are mid points for our 30px box
		
		// Define the dynamic body fixture.
		b2FixtureDef fixtureDef;
		fixtureDef.shape = &dynamicBox;	
		fixtureDef.density = CATAPULTBALL_DENSITY;
		fixtureDef.friction = 0.1f;
        fixtureDef.filter.groupIndex = -1;
		body->CreateFixture(&fixtureDef);
		
		// create a trail
		self.trail = [[[CatapultBallTrail alloc] initWithTotalParticles:200 color:[[GameSettings instance] getColorForPlayer:s]] autorelease];
		self.trail.position = ccp(body->GetPosition().x*PTM_RATIO, body->GetPosition().y*PTM_RATIO);
		[[Battlefield instance] addChild:self.trail z:ANIMATION_Z_INDEX];
		
	}
	return self;
}

- (void) dealloc {
    [super dealloc];
}

+(float) getMass {
	return 11.0*11.0/(PTM_RATIO*PTM_RATIO)*CATAPULTBALL_DENSITY;
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	if ([p isKindOfClass:[CatapultBall class]]) {
		return;
	}
	
	[super targetWasHit:contact by:p];
	
	CCParticleSystem *emitter = [[[CatapultBallExplosion alloc] init] autorelease];
	emitter.position = ccp(body->GetPosition().x*PTM_RATIO, body->GetPosition().y*PTM_RATIO);
	[[Battlefield instance] addChild:emitter z:ANIMATION_Z_INDEX];
}

@end
