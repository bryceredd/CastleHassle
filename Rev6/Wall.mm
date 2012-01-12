//
//  Wall.m
//  Rev3
//
//  Created by Bryce Redd on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Wall.h"
#import "Arch.h"
#import "Projectile.h"
#import "StaticUtils.h"
#import "Weapon.h"
#import "City.h"
#import "PlayerArea.h"


@implementation Wall

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {
	
	if((self = [super init])) {
		world = w;
		maxHp = hp = MAX_WALL_HP;
		buyPrice = WALL_BUY_PRICE;
		repairPrice = WALL_REPAIR_PRICE;
		acceptsTouches = YES;
		acceptsDamage = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,0,30,29) image:WALL_IMAGE atPoint:p];
		
		// Define the dynamic body
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
	}
	
	return self;
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	// snap the position
	[StaticUtils snapVerticallyToClasses:[NSArray arrayWithObjects:[City class], [Wall class], [Arch class], nil] 
							   withPoint:&pos 
							   fromPiece:self
								   world:world];
	
	return pos;
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	[super targetWasHit:contact by:p];
}

-(void) finalizePiece {
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(28.0/PTM_RATIO*.5, 28.0/PTM_RATIO*.5); //These are mid points for our 30px box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = PIECE_DENSITY;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	
	[super finalizePiece];
}

-(void) updateView {
	if (hp < (maxHp/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,62,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,62,30,29)];
	} else if (hp < (maxHp*2/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,31,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,31,30,29)];
	} else {
		[self.currentSprite setTextureRect:CGRectMake(0,0,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,0,30,29)];
	}
	
	
	[super updateView];
	
}


@end
