//
//  Tower.m
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Turret.h"
#import "Tower.h"
#import "Wall.h"
#import "Projectile.h"
#import "StaticUtils.h"
#import "Weapon.h"
#import "Ground.h"
#import "Merlin.h"

@implementation Turret

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {
	
	if( (self=[super init])) {
		world = w;
		maxHp = hp = MAX_TURRET_HP;
		buyPrice = TURRET_BUY_PRICE;
		repairPrice = TURRET_REPAIR_PRICE;
		acceptsTouches = YES;
		acceptsDamage = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,0,36,29) image:TURRET_IMAGE atPoint:p];
		
		// Set up a 1m squared box in the physics world
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
	}
	return self;
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	// snap the position
	[StaticUtils snapVerticallyToClasses:[NSArray arrayWithObjects:[Merlin class], [Tower class], [Wall class], nil] 
							   withPoint:&pos 
							   fromPiece:self
								   world:world];
	
	return pos;
}

-(int) zIndex {
    return PIECE_Z_INDEX+1;
}

-(int) zFarIndex {
    return FAR_PIECE_Z_INDEX+1;
}


-(void) finalizePiece {
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(36.0/PTM_RATIO*.5, 24.0/PTM_RATIO*.5, b2Vec2(0,-2.5/PTM_RATIO), 0);
	
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
	if (hp < (MAX_TURRET_HP/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,62,36,29)];
		[self.backSprite setTextureRect:CGRectMake(0,62,36,29)];
	} else if (hp < (MAX_TURRET_HP*2/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,31,36,29)];
		[self.backSprite setTextureRect:CGRectMake(0,31,36,29)];
	} else {
		[self.currentSprite setTextureRect:CGRectMake(0,0,36,29)];
		[self.backSprite setTextureRect:CGRectMake(0,0,36,29)];
	}
	
	[super updateView];
}

@end
