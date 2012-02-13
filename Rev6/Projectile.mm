//
//  Projectile.m
//  Rev3
//
//  Created by Bryce Redd on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Projectile.h"
#import "Battlefield.h"
#import "PlayerArea.h"
#import "PlayerAreaManager.h"

@implementation Projectile

@synthesize baseDamage, bounces, trail, shouldLoadVelocity;

-(id) initWithCoords:(CGPoint)p world:(b2World *)w from:(PlayerArea*)s {
	if((self = [super initWithWorld:w coords:p])) {
		acceptsTouches = NO;
		world = w;
		baseDamage = 10;
		bounces = 2;
		trail = nil;
		isBack = NO;
		self.owner = s;
		shouldLoadVelocity = NO;
		
		// Define the base dynamic body
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		
		// Setup the body
		body = w->CreateBody(&bodyDef);
        body->SetType(b2_dynamicBody);
		body->SetBullet(true);
	}
	return self;
}

- (void) updateSpritePosition:(b2Vec2)pos body:(b2Body *)b {
	
	float camX,camY,camZ;
	[[Battlefield instance].camera centerX:&camX centerY:&camY centerZ:&camZ];
	
	// move to the right
	if(self.currentSprite.position.x < [Battlefield instance].playerAreaManager.extremeLeft.left) {
		float delta = MAX_PLAYERS*PLAYER_GROUND_WIDTH;
		b2Vec2 pos = b2Vec2(b->GetPosition().x+delta/PTM_RATIO, b->GetPosition().y);
		b->SetTransform(pos, b->GetAngle());
	}
	
	// move to the left
	if(self.currentSprite.position.x > [Battlefield instance].playerAreaManager.extremeRight.left+PLAYER_GROUND_WIDTH) {
		float delta = MAX_PLAYERS*PLAYER_GROUND_WIDTH;
		b2Vec2 pos = b2Vec2(b->GetPosition().x-delta/PTM_RATIO, b->GetPosition().y);
		b->SetTransform(pos, b->GetAngle());
	}
	
	if(self.trail) {
		
		/*CGPoint backTrailPosition = [playerAreaManager getBackImagePosFromObjPos:ccp(pos.x * PTM_RATIO, pos.y * PTM_RATIO) 
									  cameraPosition:ccp(camX, camY)];
		
		if(backTrailPosition.x > 0 && backTrailPosition.y > 0) {
			
			piece.trail.position = backTrailPosition;
			[((Projectile*)piece) setIsBack:YES];
			
		} else {*/
        
            //NSLog(@"setting trail position to %f %f, should destroy %d",pos.x*PTM_RATIO, pos.y*PTM_RATIO, self.shouldDestroy);
			
            self.trail.position = ccp(pos.x*PTM_RATIO, pos.y*PTM_RATIO);
			[self setIsBack:NO];
			
		//}
		
	}
}

-(void) setIsBack:(BOOL)b {
	
	if (!(isBack ^ b)) { return; }
	
	if((isBack = b)) {
		self.trail.scaleX = 1/BACKGROUND_SCALE_FACTOR;
		self.trail.scaleY = 1/BACKGROUND_SCALE_FACTOR;
	}
	
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	
	shouldDestroy = --bounces <= 0;
	
	if(shouldDestroy && self.trail)
		self.trail.duration=0.0;
}


- (void) dealloc {
    [trail release];
    
    [super dealloc];
}

+(float) getMass {
	return 1.0f;
}

@end
