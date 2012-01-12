//
//  Balcony.mm
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Balcony.h"
#import "Projectile.h"
#import "StaticUtils.h"
#import "Weapon.h"
#import "Tower.h"
#import "Wall.h"
#import "Merlin.h"

@implementation Balcony

-(id) initWithWorld:(b2World*)w
			   coords:(CGPoint)p {
	
	if((self = [super initWithWorld:w coords:p])) {
		
		maxHp = hp = MAX_BALCONY_HP;
		buyPrice = BALCONY_BUY_PRICE;
		repairPrice = BALCONY_REPAIR_PRICE;
		acceptsTouches = YES;
		acceptsDamage = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,0,30,29) image:BALCONY_IMAGE atPoint:p];
		
		// Define the dynamic body.
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
	}
	return self;
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	[StaticUtils snapHorizontallyToClasses:[NSArray arrayWithObjects:[Wall class], [Tower class], [Merlin class], nil] 
								 withPoint:&pos 
								 fromPiece:self
									 world:world];
	return pos;
}

-(void) addSnappingJoints {
	[super addSnappingJoints];
	
	if(!self.snappedTo) { return; }
	
	b2RevoluteJointDef jointDef;
	jointDef.Initialize(body, self.snappedTo.body, body->GetWorldCenter());
	
	if(isFacingLeft) {
		jointDef.localAnchorA = b2Vec2(-15.0/PTM_RATIO, 0.0);
		jointDef.localAnchorB = b2Vec2(15.0/PTM_RATIO, 0.0);
	} else {
		jointDef.localAnchorA = b2Vec2(15.0/PTM_RATIO, 0.0);
		jointDef.localAnchorB = b2Vec2(-15.0/PTM_RATIO, 0.0);
	}
	
	
	jointDef.lowerAngle = -0.05125f * b2_pi; // -11.25 degrees
	jointDef.upperAngle = 0.05125f * b2_pi; // 11.25 degrees
	jointDef.enableLimit = true;
	jointDef.maxMotorTorque = 100.0f;
	jointDef.motorSpeed = 0.0f;
	jointDef.enableMotor = true;
	
	world->CreateJoint(&jointDef);
}

-(NSDictionary*) getPieceData {
	NSMutableDictionary* pd = (NSMutableDictionary*)[super getPieceData];
	
	if(self.snappedTo) {	[pd setObject:[NSString stringWithFormat:@"%d", self.snappedTo.pieceID] forKey:@"snapped"]; }
	
	return pd;
}

-(void) restoreToState:(NSDictionary*)state {
	[super restoreToState:state];
	
	if(self.owner) { self.snappedTo = [self.owner getPiece:[[state objectForKey:@"snapped"] intValue]]; }
	
	[self addSnappingJoints];
}


-(void) finalizePiece {
	
	// attempt to snap 
	if(!self.snappedTo) { [self snapToPosition:body->GetPosition()]; }
		
	if(self.snappedTo) { [self addSnappingJoints]; }
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	
	b2Vec2 triangle[4];
	
	if(isFacingLeft) {
		triangle[0] = b2Vec2(-15.0/PTM_RATIO, -15.0/PTM_RATIO);
		triangle[1] = b2Vec2(15.0/PTM_RATIO, 8.0/PTM_RATIO);
		triangle[2] = b2Vec2(15.0/PTM_RATIO, 15.0/PTM_RATIO);
		triangle[3] = b2Vec2(-15.0/PTM_RATIO, 15.0/PTM_RATIO);
	} else {
		triangle[0] = b2Vec2(15.0/PTM_RATIO, -15.0/PTM_RATIO);
		triangle[1] = b2Vec2(15.0/PTM_RATIO, 15.0/PTM_RATIO);
		triangle[2] = b2Vec2(-15.0/PTM_RATIO, 15.0/PTM_RATIO); 
		triangle[3] = b2Vec2(-15.0/PTM_RATIO, 8.0/PTM_RATIO);
	}
	
	dynamicBox.Set(triangle, 4);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = PIECE_DENSITY;
	fixtureDef.friction = 1.3f;
	body->CreateFixture(&fixtureDef);
		
	[super finalizePiece];
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	[super targetWasHit:contact by:p];
}

-(void) updateView {
			   
	if (hp < (MAX_BALCONY_HP/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,62,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,62,30,29)];
	} else if (hp < (MAX_BALCONY_HP*2/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,31,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,31,30,29)];
	} else {
		[self.currentSprite setTextureRect:CGRectMake(0,0,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,0,30,29)];
	}
	
	[super updateView];
	
}

@end
