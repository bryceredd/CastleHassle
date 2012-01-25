//
//  Tower.m
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Cannon.h"
#import "CannonBall.h"
#import "Battlefield.h"
#import "PlayerArea.h"
#import "PlayerAreaManager.h"
#import "Settings.h"
#import "GameSettings.h"

@implementation Cannon


-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {

	isFacingLeft = NO;
	
	if( (self=[super init])) {
		
		// these adjust the offset of the arm to the base of the physical box
		offset = 10.0;
		currentShotAngle = M_PI_4;

		world = w;
		buyPrice = CANNON_BUY_PRICE;
		repairPrice = CANNON_REPAIR_PRICE;
		upgradePrice = CANNON_UPGRADE_PRICE;
		maxCooldown = CANNON_COOLDOWN;
		maxHp = hp = MAX_CANNON_HP;
		acceptsPlayerColoring = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,26,30,14) image:CANNON_IMAGE atPoint:p];
		
		[self setupSwingSpritesWithRect:CGRectMake(0,0,50,11) image:CANNON_IMAGE atPoint:p];
				
		// define the base dynamic body
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
		//Audio Section
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"cannon.caf"];
		
		 
	}
	return self;
}

- (void) onTouchMoved:(CGPoint)touch {
    [super onTouchMoved:touch];
    
    // configure the direction
	self.isFacingLeft = !(currentShotAngle < CC_DEGREES_TO_RADIANS(self.currentSprite.rotation + 90.f));
}

- (void) updateSpritesAngle:(float)ang position:(b2Vec2)pos time:(float)t {
    [super updateSpritesAngle:ang position:pos time:t];
    
	// calculate the base offset position in case of tumbling
	float xoffset = 0; float yoffset = 0;
    
	
	// calculate the swing offset position
	if(self.isFacingLeft) {
		xoffset = sin(ang+.5)*self.offset;
		yoffset = cos(ang+.5)*-self.offset;
	} else {
		xoffset = sin(ang-.5)*self.offset;
		yoffset = cos(ang-.5)*-self.offset;
	}
	
    
	// swing position is normal, but the rotation adds the current angle
	self.swingSprite.position = ccp(pos.x * PTM_RATIO - xoffset, pos.y * PTM_RATIO - yoffset);
	self.swingSprite.rotation = CC_RADIANS_TO_DEGREES(self.currentShotAngle);
	
    
    
    // figure out if the backsprite must be moved
	if(self.backSwingSprite) {
        float camX,camY,camZ;
        [[Battlefield instance].camera centerX:&camX centerY:&camY centerZ:&camZ];

		self.backSwingSprite.position = [[Battlefield instance].playerAreaManager getBackImagePosFromObjPos:ccp(pos.x * PTM_RATIO, pos.y * PTM_RATIO) cameraPosition:ccp(camX, camY)];
		self.backSwingSprite.position = ccp(self.backSwingSprite.position.x +xoffset/BACKGROUND_SCALE_FACTOR,
											  self.backSwingSprite.position.y -yoffset/BACKGROUND_SCALE_FACTOR);
		
		self.backSwingSprite.rotation = CC_RADIANS_TO_DEGREES(ang-self.currentShotAngle);
	}

}

- (BOOL) onTouchEndedLocal:(CGPoint)touch {
    
	if(self.shootIndicatorTail) { 
        [[Battlefield instance] removeChild:self.shootIndicatorTail cleanup:YES]; 
    }
    if(self.shootIndicatorTop) { 
        [[Battlefield instance] removeChild:self.shootIndicatorTop cleanup:YES]; 
    }
	
	self.shootIndicatorTail = nil;
    self.shootIndicatorTop = nil;

	if(shotPower < 20) { return NO; }
	
	if(![self isUsable]) { return NO; }
	
    
    //Audio for Cannon shot
	[[SimpleAudioEngine sharedEngine] playEffect:@"cannon.caf"];
	
    
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
	if(h<0.0) h=0.0;
	
	// this initiates the cannonball just outside the cannon
	projectileLoc.x += (w/power)*pixelsInFront;
	projectileLoc.y += (h/power)*pixelsInFront;
	
	CannonBall *ball = [[[CannonBall alloc] initWithWorld:world 
													coords:projectileLoc 
													 level:weaponLevel 
												   shooter:self.owner] autorelease];
	
    [[Battlefield instance] addProjectileToBin:ball];
    
    ball.body->ApplyLinearImpulse(b2Vec2(w*CANNON_DEFAULT_POWER,h*CANNON_DEFAULT_POWER), ball.body->GetPosition());
    
	[super fired:ball];
	
	
	return YES;
}

-(BOOL) shootFromAICannon:(CGPoint)touch {
	
	if(![[Battlefield instance] canFire]) { return NO; }
	
	[self onTouchBegan:ccp(0,0)];
	[self onTouchMoved:touch];
	[self onTouchEnded:touch];
	
	return YES;
}

-(void) finalizePiece {
	// define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	// we need to make this a slightly weighted object as we have an offset
	dynamicBox.SetAsBox(30.0/PTM_RATIO*.5, 25.0/PTM_RATIO*.5, b2Vec2(0,offset/(1.5*PTM_RATIO)), 0);
	
	// define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = PIECE_DENSITY;
	fixtureDef.friction = 1.0f;
	body->CreateFixture(&fixtureDef);
	
	currentShotAngle = M_PI_4 + M_PI_2;
	[super finalizePiece];
	
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile*)p {
	[super targetWasHit:contact by:p];
}

-(void) updateView {
	
	if (hp < (MAX_CANNON_HP/2)) {
		
		[self.currentSprite setTextureRect:CGRectMake(0,40,30,14)];
		[self.backSprite setTextureRect:CGRectMake(0,40,30,14)];
		
		[self.swingSprite setTextureRect:CGRectMake(0,12,50,11)];
		[self.backSwingSprite setTextureRect:CGRectMake(0,12,50,11)];
		
	} else {
		
		[self.currentSprite setTextureRect:CGRectMake(0,26,30,14)];
		[self.backSprite setTextureRect:CGRectMake(0,26,30,14)];
		
		[self.swingSprite setTextureRect:CGRectMake(0,0,50,11)];
		[self.backSwingSprite setTextureRect:CGRectMake(0,0,50,11)];
	}
	
	[super updateView];
	
}

-(void) moveObject:(CGPoint)touch {
	[super moveObject:touch];
}

@end
