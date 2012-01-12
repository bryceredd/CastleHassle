//
//  Arch.mm
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Arch.h"
#import "Projectile.h"
#import "StaticUtils.h"
#import "Weapon.h"
#import "PieceList.h"

@implementation Arch

@synthesize rightSnappedTo;

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {
	
	if((self = [super initWithWorld:w coords:p])) {
		
		maxHp = hp = MAX_ARCH_HP;
		buyPrice = ARCH_BUY_PRICE;
		repairPrice = ARCH_REPAIR_PRICE;
		acceptsTouches = YES;
		acceptsDamage = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,0,60,30) image:ARCH_IMAGE atPoint:p];
				
		// Define the dynamic body.
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
	}
	return self;
}


-(b2Vec2) snapToPosition:(b2Vec2)pos {
	[StaticUtils snapBetweenTwoClasses:[NSArray arrayWithObjects:[Tower class], [Wall class], [Merlin class], [Wedge class], nil] 
							 withPoint:&pos 
							 fromPiece:self
								 world:world];
	return pos;
}

-(void) addSnappingJoints {
	[super addSnappingJoints];
	
	if(!self.snappedTo) { [self snapToPosition:body->GetPosition()]; }
	
	if(self.snappedTo && rightSnappedTo) {
		Piece * pieceLeft = (Piece *)self.snappedTo.body->GetUserData();
		Piece * pieceRight = (Piece *)rightSnappedTo.body->GetUserData();
		
		b2RevoluteJointDef jointDef1, jointDef2;
		
		jointDef1.Initialize(body, self.snappedTo.body, body->GetWorldCenter());
		jointDef1.lowerAngle = -0.25f * b2_pi; // -22.5 degrees
		jointDef1.upperAngle = 0.25f * b2_pi; // 22.5 degrees
		jointDef1.enableLimit = true;
		jointDef1.maxMotorTorque = 1.0f;
		jointDef1.motorSpeed = 0.0f;
		jointDef1.enableMotor = true;
		jointDef1.localAnchorA = b2Vec2((self.currentSprite.textureRect.size.width/-2.0)/PTM_RATIO, (self.currentSprite.textureRect.size.height/3.0)/PTM_RATIO);
		jointDef1.localAnchorB = b2Vec2((pieceLeft.currentSprite.textureRect.size.width/2.0)/PTM_RATIO, (pieceLeft.currentSprite.textureRect.size.height/3.0)/PTM_RATIO);
		
		world->CreateJoint(&jointDef1);
		
		jointDef2.Initialize(body, rightSnappedTo.body, body->GetWorldCenter());
		jointDef2.lowerAngle = -0.25f * b2_pi; // -22.5 degrees
		jointDef2.upperAngle = 0.25f * b2_pi; // 22.5 degrees
		jointDef2.enableLimit = true;
		jointDef2.maxMotorTorque = 1.0f;
		jointDef2.motorSpeed = 0.0f;
		jointDef2.enableMotor = true;
		jointDef2.localAnchorA = b2Vec2((self.currentSprite.textureRect.size.width/2.0)/PTM_RATIO, (self.currentSprite.textureRect.size.height/3.0)/PTM_RATIO);
		jointDef2.localAnchorB = b2Vec2((pieceRight.currentSprite.textureRect.size.width/-2.0)/PTM_RATIO, (pieceRight.currentSprite.textureRect.size.height/3.0)/PTM_RATIO);
		
		world->CreateJoint(&jointDef2);
	}
	
}

-(void) finalizePiece {
	
	[self addSnappingJoints];
	
	// Define the left dynamic body fixture
	b2Vec2 left[4];
	b2FixtureDef leftFixtureDef;
	b2PolygonShape leftDynamicBox;
	left[0] = b2Vec2(0.0/PTM_RATIO, 15.0/PTM_RATIO);
	left[1] = b2Vec2(-30.0/PTM_RATIO, 15.0/PTM_RATIO);
	left[2] = b2Vec2(-30.0/PTM_RATIO, -10.0/PTM_RATIO); 
	left[3] = b2Vec2(0.0/PTM_RATIO, 12.0/PTM_RATIO);
	
	leftDynamicBox.Set(left, 4);
	leftFixtureDef.shape = &leftDynamicBox;
	leftFixtureDef.density = PIECE_DENSITY;
	leftFixtureDef.friction = 1.3f;
	body->CreateFixture(&leftFixtureDef);
	
	// Define the dynamic body fixture
	b2Vec2 right[4];
	right[0] = b2Vec2(0.0/PTM_RATIO, 15.0/PTM_RATIO);
	right[1] = b2Vec2(0.0/PTM_RATIO, 12.0/PTM_RATIO);
	right[2] = b2Vec2(30.0/PTM_RATIO, -10.0/PTM_RATIO);
	right[3] = b2Vec2(30.0/PTM_RATIO, 15.0/PTM_RATIO);
	b2PolygonShape rightDynamicBox;
	rightDynamicBox.Set(right, 4);
	
	// Define the dynamic body fixture
	b2FixtureDef rightFixtureDef;
	rightFixtureDef.shape = &rightDynamicBox;
	rightFixtureDef.density = 0.5f;
	rightFixtureDef.friction = 1.3f;
	body->CreateFixture(&rightFixtureDef);
	
	[super finalizePiece];
	
}

-(NSDictionary*) getPieceData {
	NSMutableDictionary* pd = (NSMutableDictionary*)[super getPieceData];
	
	if(self.snappedTo) {	[pd setObject:[NSString stringWithFormat:@"%d", self.snappedTo.pieceID] forKey:@"snappedLeft"]; }
	if(rightSnappedTo) { [pd setObject:[NSString stringWithFormat:@"%d", rightSnappedTo.pieceID] forKey:@"snappedRight"]; }
	
	return pd;
}

-(void) restoreToState:(NSDictionary*)state {
	[super restoreToState:state];
	
	if(self.owner) { self.snappedTo = [self.owner getPiece:[[state objectForKey:@"snappedLeft"] intValue]]; }
	if(self.owner) { rightSnappedTo = [self.owner getPiece:[[state objectForKey:@"snappedRight"] intValue]]; }
	
	[self addSnappingJoints];
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	[super targetWasHit:contact by:p];
}

-(void) updateView {

	if (hp < (MAX_ARCH_HP/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,62,60,30)];
		[self.backSprite setTextureRect:CGRectMake(0,62,60,30)];
	} else if (hp < (MAX_ARCH_HP*2/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,31,60,30)];
		[self.backSprite setTextureRect:CGRectMake(0,31,60,30)];
	} else {
		[self.currentSprite setTextureRect:CGRectMake(0,0,60,30)];
		[self.backSprite setTextureRect:CGRectMake(0,0,60,30)];
	}
	
	[super updateView];
}



@end
