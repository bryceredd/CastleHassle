//
//  City.mm
//  Rev5
//
//  Created by Bryce Redd on 12/6/09.
//  Copyright 2009 Poplobby. All rights reserved.
//

#import "City.h"
#import "StaticUtils.h"
#import "PlayerArea.h"
#import "Battlefield.h"
#import "GameSettings.h"

@implementation City

@synthesize colorSpriteBack;
@synthesize colorSprite;

- (id) initWithCoords:(CGPoint)p owner:(PlayerArea*)o colorVal:(ccColor3B)color {	
	if((self = [super initWithWorld:[Battlefield instance].world coords:p])) {
		
		acceptsTouches = NO;
		acceptsDamage = NO;
		self.owner = o;
		
		CGRect rect = CGRectMake(0,0,420,60);
		[self setupSpritesWithRect:rect image:CITY_IMAGE atPoint:p];
		
		// setup colored sprites
		colorSprite = spriteWithRect(CITY_COLOR_IMAGE, rect);
        colorSprite.position = ccp(p.x, p.y);
		colorSprite.color = color; 
        [[Battlefield instance] addChild:colorSprite z:PIECE_Z_INDEX+1];
		
		colorSpriteBack = spriteWithRect(CITY_COLOR_IMAGE, rect);
		colorSpriteBack.scale = 1/BACKGROUND_SCALE_FACTOR;
		colorSpriteBack.position = ccp(p.x, p.y+PLAYER_BACKGROUND_HEIGHT);
		colorSpriteBack.flipX = YES;
        colorSpriteBack.color = color; 
		[[Battlefield instance] addChild:colorSpriteBack z:BACKGROUND_Z_INDEX];
		
		
		// Define the dynamic body
		b2BodyDef bodyDef;
		bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
		bodyDef.userData = self;
		body = world->CreateBody(&bodyDef);
		
		[self finalizePiece];
	
		// Define another box shape for our dynamic body.
		b2PolygonShape dynamicBox;
		
		b2Vec2 wedge[4]; 
		wedge[0] = b2Vec2(210.0/PTM_RATIO, -30.0/PTM_RATIO);
		wedge[1] = b2Vec2(150.0/PTM_RATIO, 30.0/PTM_RATIO);
		wedge[2] = b2Vec2(-150.0/PTM_RATIO, 30.0/PTM_RATIO);
		wedge[3] = b2Vec2(-210.0/PTM_RATIO, -30.0/PTM_RATIO);
		dynamicBox.Set(wedge, 4);
		
		// Define the dynamic body fixture.
		b2FixtureDef fixtureDef;
		fixtureDef.shape = &dynamicBox;	
		body->CreateFixture(&fixtureDef);
		body->SetUserData(self);
        body->SetType(b2_staticBody);
	}
	
	return self;
}

- (void) updateSprites {
    self.colorSpriteBack.position = self.backSprite.position;
	self.colorSpriteBack.rotation = self.backSprite.rotation;
	
	self.colorSprite.position = self.currentSprite.position;
	self.colorSprite.rotation = self.currentSprite.rotation;	
}

- (void) setShouldDestroy:(BOOL)flag {
    [super setShouldDestroy:flag];
}

@end
