//
//  Tower.m
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Top.h"
#import "Tower.h"
#import "Turret.h"
#import "Projectile.h"
#import "Weapon.h"
#import "StaticUtils.h"
#import "GameSettings.h"
#import "Wall.h"
#import "Balcony.h"
#import "Merlin.h"

@implementation Top

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {
	
	if((self = [super init])) {
		world = w;
		maxHp = hp = MAX_TOP_HP;
		buyPrice = TOP_BUY_PRICE;
		repairPrice = TOP_REPAIR_PRICE;
		acceptsTouches = YES;
		acceptsDamage = YES;
		acceptsPlayerColoring = YES;
		
		[self setupSpritesWithRect:CGRectMake(0,0,33,26) image:TOP_IMAGE atPoint:p];
		
		// Define the dynamic body.
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
	}
	return self;
}

-(void) onTouchBegan:(CGPoint)touch {
	if(!hasBeenPlaced) { body->SetAwake(false);}
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	[StaticUtils snapVerticallyToClasses:[NSArray arrayWithObjects:[Tower class], [Turret class], [Merlin class], [Wall class], [Balcony class], nil] 
							   withPoint:&pos 
							   fromPiece:self
								   world:world];
	
	return pos;
}

-(void) finalizePiece {
	
	b2Vec2 wedge[3];
	
	wedge[0] = b2Vec2(17.0/PTM_RATIO, -13.5/PTM_RATIO);
	wedge[1] = b2Vec2(0.0/PTM_RATIO, 13.5/PTM_RATIO);
	wedge[2] = b2Vec2(-17.0/PTM_RATIO, -13.5/PTM_RATIO);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.Set(wedge, 3);
	
	// Define the dynamic body fixture
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = PIECE_DENSITY;
	fixtureDef.friction = 1.0f;
	body->CreateFixture(&fixtureDef);
	
	[super finalizePiece];
	
	[self updateView];	
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	[super targetWasHit:contact by:p];
}

-(void) updateView {
	if (hp < (MAX_TOP_HP/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,54,33,26)];
		[self.backSprite setTextureRect:CGRectMake(0,54,33,26)];
	} else if (hp < (MAX_TOP_HP*2/3)) {
		[self.currentSprite setTextureRect:CGRectMake(0,29,33,26)];
		[self.backSprite setTextureRect:CGRectMake(0,29,33,26)];
	} else {
		[self.currentSprite setTextureRect:CGRectMake(0,0,33,26)];
		[self.backSprite setTextureRect:CGRectMake(0,0,33,26)];
	}
	
	[super updateView];
	
}



@end
