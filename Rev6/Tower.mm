//
//  Tower.m
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tower.h"
#import "Projectile.h"
#import "StaticUtils.h"
#import "Weapon.h"
#import "PlayerArea.h"
#import "Turret.h"
#import "City.h"

@implementation Tower

-(id) initWithWorld:(b2World*)w
			   coords:(CGPoint)p {
	
	if((self = [super init])) {
		
		world = w;
		maxHp = hp = MAX_TOWER_HP;
		buyPrice = TOWER_BUY_PRICE;
		repairPrice = TOWER_REPAIR_PRICE;
		acceptsTouches = YES;
		acceptsDamage = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,0,30,29) image:TOWER_IMAGE atPoint:p];
		
		// Define the dynamic body.
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
        body->SetType(b2_dynamicBody);
		
	}
	return self;
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	[StaticUtils snapVerticallyToClasses:[NSArray arrayWithObjects:[Tower class], [Turret class], [City class], nil] 
							   withPoint:&pos 
							   fromPiece:self
								   world:world];
	
	return pos;
}

-(void) finalizePiece {
	NSLog(@"Tower.mm: finalize piece called");
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(28.0/PTM_RATIO*.5, 28.0/PTM_RATIO*.5); //These are mid points for our 30px box
	
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

	if (hp < (MAX_TOWER_HP/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,62,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,62,30,29)];
	} else if (hp < (MAX_TOWER_HP*2/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,31,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,31,30,29)];
	} else {
		[self.currentSprite setTextureRect:CGRectMake(0,0,30,29)];
		[self.backSprite setTextureRect:CGRectMake(0,0,30,29)];
	}
	
	[super updateView];
}

@end
