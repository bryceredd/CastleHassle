//
//  CannonBall.m
//  Rev3
//
//  Created by Bryce Redd on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CannonBall.h"
#import "CannonBallExplosion.h"
#import "CannonBallTrail.h"
#import "Battlefield.h"
#import "PlayerArea.h"
#import "GameSettings.h"

@implementation CannonBall

-(id) initWithManager:(AtlasSpriteManager*)spritemgr  
		  backManager:(AtlasSpriteManager*)backmanager
				world:(b2World*)w
			   coords:(CGPoint)p 
				level:(int)l 
			  shooter:(PlayerArea*)s {
	if( (self=[super initWithCoords:p world:w manager:spritemgr from:s])) {
	
		bounces = l;
		self.backMgr = backmanager;
		baseDamage = CANNONBALL_BASE_DAMAGE;

		[self setupSpritesWithRect:CGRectMake(0,0,7,7) atPoint:p];
		
		// Define another box shape for our dynamic body.
		b2PolygonShape dynamicBox;
		
		// we need to make this a slightly weighted object as we have an offset
		dynamicBox.SetAsBox(7.0/PTM_RATIO*.5, 7.0/PTM_RATIO*.5); //These are mid points for our 30px box
		
		// Define the dynamic body fixture.
		b2FixtureDef fixtureDef;
		fixtureDef.shape = &dynamicBox;	
		fixtureDef.density = CANNONBALL_DENSITY;
		fixtureDef.friction = 0.1f;
        fixtureDef.filter.groupIndex = -1;
		body->CreateFixture(&fixtureDef);
		
		// create a trail 
		self.trail = [[[CannonBallTrail alloc] initWithTotalParticles:200 color:[[GameSettings instance] getColorForPlayer:s]] autorelease];
		self.trail.position = ccp(body->GetPosition().x*PTM_RATIO, body->GetPosition().y*PTM_RATIO);
		[[Battlefield instance] addChild:self.trail z:ANIMATION_Z_INDEX];
		
	}
	return self;
	
}

+(float) getMass {
	return 7.0*7.0/(PTM_RATIO*PTM_RATIO)*CANNONBALL_DENSITY;
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	[super targetWasHit:contact by:p];
	
	ParticleSystem *emitter = [[[CannonBallExplosion alloc] init] autorelease];
	emitter.position = ccp(body->GetPosition().x*PTM_RATIO, body->GetPosition().y*PTM_RATIO);
	[[Battlefield instance] addChild:emitter z:ANIMATION_Z_INDEX];
}

@end
