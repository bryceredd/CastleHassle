//
//  Wall.m
//  Rev3
//
//  Created by Bryce Redd on 12/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Merlin.h"
#import "Arch.h"
#import "Projectile.h"
#import "StaticUtils.h"
#import "Weapon.h"
#import "PlayerArea.h"
#import "Wall.h"
#import "Balcony.h"


@implementation Merlin

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p {
	
	if((self = [super initWithWorld:w coords:p])) {
		maxHp = hp = MAX_MERLIN_HP;
		buyPrice = MERLIN_BUY_PRICE;
		repairPrice = MERLIN_REPAIR_PRICE;		
        
        [self setupSpritesWithRect:CGRectMake(0,0,30,29) image:MERLIN_IMAGE atPoint:p];
		
		// Define the dynamic body
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
	}
	
	return self;
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	
	[StaticUtils snapVerticallyToClasses:[NSArray arrayWithObjects:[City class], [Wall class], [Arch class], [Balcony class], nil] 
							   withPoint:&pos 
							   fromPiece:self
								   world:world];
	
	return pos;
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {
	[super targetWasHit:contact by:p];
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


-(void) finalizePiece {
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(28.0/PTM_RATIO*.5, 23.0/PTM_RATIO*.5, b2Vec2(0,-4.0/PTM_RATIO), 0);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = PIECE_DENSITY;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);

	[self finalizePieceBase];
}

@end
