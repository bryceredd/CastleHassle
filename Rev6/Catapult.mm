//
//  Tower.m
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Catapult.h"
#import "CatapultBall.h"
#import "Battlefield.h"
#import "PlayerArea.h"
#import "PlayerAreaManager.h"
#import "Settings.h"
#import "AI.h"

@implementation Catapult

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {
	
	if((self = [super init])) {
		
		// these adjust the offset of the arm to the base of the physical box
		offset = 0.0;
		currentShotAngle = M_PI_4;
		
		world = w;
		maxHp = hp = MAX_CATAPULT_HP;
		buyPrice = CATAPULT_BUY_PRICE;
		repairPrice = CATAPULT_REPAIR_PRICE;
		upgradePrice = CATAPULT_UPGRADE_PRICE;
		maxCooldown = CATAPULT_COOLDOWN;
		acceptsPlayerColoring = NO;
		
		
		[self setupSpritesWithRect:CGRectMake(3, 6, 23, 22) image:CATAPULT_IMAGE atPoint:p];
		[self setupSwingSpritesWithRect:CGRectMake(0, 0, 35, 5) image:CATAPULT_IMAGE atPoint:p];
				
		// define the base dynamic body
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
		//Audio Section
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"catapult.caf"];
		
	}
	return self;
}

- (void) onTouchMoved:(CGPoint)touch {
    [super onTouchMoved:touch];
    
    // configure the direction
	self.isFacingLeft = (currentShotAngle < CC_DEGREES_TO_RADIANS(self.currentSprite.rotation + 90.f));
}

-(BOOL) onTouchEndedLocal:(CGPoint)touch {		
	
	if(self.shootIndicatorTail) [[Battlefield instance] removeChild:self.shootIndicatorTail cleanup:YES];
    if(self.shootIndicatorTop) [[Battlefield instance] removeChild:self.shootIndicatorTop cleanup:YES];
	
	self.shootIndicatorTail = nil;
    self.shootIndicatorTop = nil;

	if(shotPower < 20) { return NO; }

	if(![self isUsable]) { return NO; }
	
	//Audio Section
	[[SimpleAudioEngine sharedEngine] playEffect:@"catapult.caf"];
	
    // so we don't spawn the bullet inside the cannon body
	float pixelsInFront = 30.0;
		
	CGPoint projectileLoc = CGPointMake((float)self.swingSprite.position.x, (float)self.swingSprite.position.y);
	
	float h = touch.y - initialTouch.y;
	float w = touch.x - initialTouch.x;
	
	if(WEAPON_MAX_POWER < fabs(h)+fabs(w)) {
		h = WEAPON_MAX_POWER*(h/(fabs(h)+fabs(w)));
		w = WEAPON_MAX_POWER*(w/(fabs(h)+fabs(w)));
	}
	
	float power = b2Vec2(w,h).Length();
	
    // only shoot up
	if(h<0.0)h=0.0;
    
    // this initiates the cannonball just outside the cannon
	projectileLoc.x += (w/power)*pixelsInFront;
	projectileLoc.y += (h/power)*pixelsInFront;
    
	CatapultBall *ball;
	CatapultBall *firstball=nil;
	
	for(int i=0;i<weaponLevel*CATPULT_BALLS_PER_UPGRADE;i++) {
		
        float xRandomness = 1.f;
        float yRandomness = 1.f;
        
		if(i > 0) {
            xRandomness += (float)(-(CATAPULT_SHOT_RANDOMNESS/2) + (int)(arc4random() % CATAPULT_SHOT_RANDOMNESS)) / 100.f;
            yRandomness += (float)(-(CATAPULT_SHOT_RANDOMNESS/2) + (int)(arc4random() % CATAPULT_SHOT_RANDOMNESS)) / 100.f;
		}
		
		// this initiates the catapultball just outside the weapon
		ball = [[[CatapultBall alloc] initWithWorld:world coords:projectileLoc level:weaponLevel shooter:self.owner] autorelease];
				
        [[Battlefield instance] addProjectileToBin:ball];
        
		ball.body->ApplyLinearImpulse(b2Vec2(w*xRandomness*CATAPULT_DEFAULT_POWER,h*yRandomness*CATAPULT_DEFAULT_POWER),
								ball.body->GetPosition());
		
		firstball = firstball == nil ? ball : firstball;
	}
	
	[super fired:firstball];
    
	return YES;
}

-(BOOL) shootFromAICatapult:(float)F isLeft:(BOOL)left {
	
	if(![[Battlefield instance] canFire]) { return NO;}
	
	[self setIsFacingLeft:left];
	
	CGPoint swingLoc = ccp((float)self.swingSprite.position.x, (float)self.swingSprite.position.y);
	swingLoc.y += 20;
	
	CatapultBall * ball = [[[CatapultBall alloc] initWithWorld:world 
										  coords:swingLoc 
										   level:weaponLevel 
										 shooter:self.owner] autorelease];

    [[Battlefield instance] addProjectileToBin:ball];

	float forceX = [AI getCatapultForce]*cos(CC_DEGREES_TO_RADIANS(45));
	float forceY = [AI getCatapultForce]*sin(CC_DEGREES_TO_RADIANS(45));
	
	ball.body->ApplyLinearImpulse(b2Vec2(forceX*(left?-1:1),forceY),ball.body->GetPosition());
	
	currentShotAngle = M_PI_2+(left?-M_PI_4:M_PI_4);
	
	[super fired:ball];

	return YES;
}

-(void) finalizePiece {
	// define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	// we need to make this a slightly weighted object as we have an offset
	dynamicBox.SetAsBox(23.0/PTM_RATIO*.5, 22.0/PTM_RATIO*.5, b2Vec2(0,offset/(1.5*PTM_RATIO)), 0);
	
	// define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = PIECE_DENSITY;
	fixtureDef.friction = 1.0f;
	body->CreateFixture(&fixtureDef);
	
	[super finalizePiece];
	
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile*)p {
	[super targetWasHit:contact by:p];
}

-(void) updateView {
	
	if (hp < (MAX_CATAPULT_HP/2)) {
		
		[self.currentSprite setTextureRect:CGRectMake(3, 36, 23, 22)];
		[self.backSprite setTextureRect:CGRectMake(3, 36, 23, 22)];
		
		[self.swingSprite setTextureRect:CGRectMake(0, 30, 35, 5)];
		[self.backSwingSprite setTextureRect:CGRectMake(0, 30, 35, 5)];
		
	} else {
		
		[self.currentSprite setTextureRect:CGRectMake(3, 6, 23, 22)];
		[self.backSprite setTextureRect:CGRectMake(3, 6, 23, 22)];
		
		[self.swingSprite setTextureRect:CGRectMake(0, 0, 35, 5)];
		[self.backSwingSprite setTextureRect:CGRectMake(0, 0, 35, 5)];
	}
	
	[super updateView];

}

-(void) moveObject:(CGPoint)touch {
	[super moveObject:touch];
}

-(void) updateSpritesAngle:(float)ang position:(b2Vec2)pos time:(float)t {
    
    if(([Battlefield instance].selected != self || ![Battlefield instance]->touchDown)) {

		if(shotPower > 30) {
            self.shotPower -= 20;
		}
	}
    
    float percentPower = self.shotPower / WEAPON_MAX_POWER;

    
    [super updateSpritesAngle:ang position:pos time:t];
    
    
	// swing position is normal, but the rotation adds the current angle
	self.swingSprite.position = ccp(pos.x * PTM_RATIO, pos.y * PTM_RATIO);
	self.swingSprite.rotation = CC_RADIANS_TO_DEGREES(-(M_PI+M_PI_2) + (self.isFacingLeft? 1 : -1) * percentPower*M_PI_2);
    
    
    
    
    // figure out if the backsprite must be moved
	if(self.backSwingSprite) {
        float camX,camY,camZ;
        [[Battlefield instance].camera centerX:&camX centerY:&camY centerZ:&camZ];

		self.backSwingSprite.position = [[Battlefield instance].playerAreaManager getBackImagePosFromObjPos:ccp(pos.x * PTM_RATIO, pos.y * PTM_RATIO) cameraPosition:ccp(camX, camY)];
		self.backSwingSprite.position = ccp(self.backSwingSprite.position.x,
                                            self.backSwingSprite.position.y);
		self.backSwingSprite.rotation = CC_RADIANS_TO_DEGREES(ang-self.currentShotAngle);
	}
                            
}

@end
