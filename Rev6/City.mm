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
	
	if( (self=[super init])) {
		
		self.mgr =[[Battlefield instance].managers objectForKey:@"city"];
		self.backMgr = [[Battlefield instance].managers objectForKey:@"farcity"];
		colorSpriteMgr = [[Battlefield instance].managers objectForKey:@"citycolor"];
		backColorSpriteMgr = [[Battlefield instance].managers objectForKey:@"farcitycolor"];
		
		world = [Battlefield instance].world;
		
		acceptsTouches = NO;
		acceptsDamage = NO;
		self.owner = o;
		
		CGRect rect = CGRectMake(0,0,420,60);
		[self setupSpritesWithRect:rect atPoint:p];
		
		// setup colored sprites
		colorSprite = [AtlasSprite spriteWithRect:rect spriteManager:colorSpriteMgr];
		[colorSpriteMgr addChild:colorSprite];
		colorSprite.position = ccp(p.x, p.y);
			
		colorSpriteBack = [AtlasSprite spriteWithRect:rect spriteManager:backColorSpriteMgr];
		[colorSpriteBack setScale:1/BACKGROUND_SCALE_FACTOR];
		[backColorSpriteMgr addChild:colorSpriteBack];
		colorSpriteBack.position = ccp(p.x, p.y+PLAYER_BACKGROUND_HEIGHT);
		colorSpriteBack.flipX = YES;
		
		colorSprite.color = color; 
		colorSpriteBack.color = color; 
		
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
		
	}
	
	return self;
}
- (void) updateSprites {
    self.colorSpriteBack.position = self.backSprite.position;
	self.colorSpriteBack.rotation = self.backSprite.rotation;
	
	self.colorSprite.position = self.currentSprite.position;
	self.colorSprite.rotation = self.currentSprite.rotation;	
}

@end
