//
//  Tower.m
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Wedge.h"
#import "Tower.h"
#import "Projectile.h"
#import "StaticUtils.h"
#import "Weapon.h"
#import "Wall.h"
#import "PlayerArea.h"
#import "Merlin.h"

@implementation Wedge

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {
	if((self = [super initWithWorld:w coords:p])) {
		world = w;
		maxHp = hp = MAX_WEDGE_HP;
		buyPrice = WEDGE_BUY_PRICE;
		repairPrice = WEDGE_REPAIR_PRICE;
		acceptsTouches = YES;
		acceptsDamage = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,0,30,30) image:WEDGE_IMAGE atPoint:p];
		
		// Define the dynamic body.
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
	}
	return self;
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	[StaticUtils snapVerticallyAndHorizontallyToClasses:[NSArray arrayWithObjects:[Tower class], [City class], [Wall class], [Merlin class], nil] 
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

-(void) setIsFacingLeft:(BOOL)f {

	[super setIsFacingLeft:f];
	
	if(hasBeenPlaced) { 
		
		for(b2Fixture* fix = body->GetFixtureList(); fix; fix=fix->GetNext()) { body->DestroyFixture(fix); }
	
		[self finalizePiece];
	}
	
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
	
	// only add a joint if the object is snapped vertically
	if(!self.snappedTo) { [self snapToPosition:body->GetPosition()]; }
	
	
	if(self.snappedTo && body->GetPosition().y < self.snappedTo.body->GetPosition().y+0.25) {
		[self addSnappingJoints];
	}
	
	b2Vec2 wedge[4];
	
	if(isFacingLeft) {
		wedge[0] = b2Vec2(15.0/PTM_RATIO, -15.0/PTM_RATIO);
		wedge[1] = b2Vec2(15.0/PTM_RATIO, -8.0/PTM_RATIO);
		wedge[2] = b2Vec2(-15.0/PTM_RATIO, 15.0/PTM_RATIO);
		wedge[3] = b2Vec2(-15.0/PTM_RATIO, -15.0/PTM_RATIO);
	} else {
		wedge[0] = b2Vec2(15.0/PTM_RATIO, -15.0/PTM_RATIO);
		wedge[1] = b2Vec2(15.0/PTM_RATIO, 15.0/PTM_RATIO);
		wedge[2] = b2Vec2(-15.0/PTM_RATIO, -8.0/PTM_RATIO); 
		wedge[3] = b2Vec2(-15.0/PTM_RATIO, -15.0/PTM_RATIO);
	}
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.Set(wedge, 4);
	
	// Define the dynamic body fixture
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
	
	if (hp < (MAX_WEDGE_HP/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,62,30,30)];
		[self.backSprite setTextureRect:CGRectMake(0,62,30,30)];
	} else if (hp < (MAX_WEDGE_HP*2/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,31,30,30)];
		[self.backSprite setTextureRect:CGRectMake(0,31,30,30)];
	} else {
		[self.currentSprite setTextureRect:CGRectMake(0,0,30,30)];
		[self.backSprite setTextureRect:CGRectMake(0,0,30,30)];
	}
	
	[super updateView];
}



@end
