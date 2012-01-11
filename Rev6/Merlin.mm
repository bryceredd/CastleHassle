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
#import "Balcony.h"


@implementation Merlin

-(id) initWithManager:(AtlasSpriteManager*)spritemgr 
		  backManager:(AtlasSpriteManager*)backmanager
				world:(b2World*)w
			   coords:(CGPoint)p {
	
	if( (self=[super initWithManager:spritemgr backManager:backmanager world:w coords:p])) {
		maxHp = hp = MAX_MERLIN_HP;
		buyPrice = MERLIN_BUY_PRICE;
		repairPrice = MERLIN_REPAIR_PRICE;		
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
