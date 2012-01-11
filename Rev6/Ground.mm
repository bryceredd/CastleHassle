//
//  Ground.mm
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Ground.h"

@implementation Ground

@synthesize layer;

- (id)initWithGroundHeight:(int)height 
					 width:(int)width
					 world:(b2World*)w 
					 layer:(Layer*)parent {
	
	if( (self=[super init])) {
		world = w;
		acceptsTouches = NO;
		acceptsDamage = NO;
		
		// set position in the  world
		CGSize screenSize = [Director sharedDirector].winSize;
		b2BodyDef bodydef;
		bodydef.position.Set(0,height);
		body = w->CreateBody(&bodydef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom wall
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		body->CreateFixture(&groundBox);
		
		body->SetUserData(self);
		
	}
	
	return self;
}


- (id)initWithGroundHeight:(int)height 
					 world:(b2World*)w 
				 leftImage:(NSString *)lImg 
				rightImage:(NSString *)rImg 
			imageDimension:(CGPoint)dim
					 layer:(Layer*)parent {

	if( (self=[super init])) {
		world = w;
		acceptsTouches = NO;
		acceptsDamage = NO;
		
		// set position in the  world
		CGSize screenSize = [Director sharedDirector].winSize;
		b2BodyDef bodydef;
		bodydef.position.Set(0,height);
		body = w->CreateBody(&bodydef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom wall
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		body->CreateFixture(&groundBox);
		
		body->SetUserData(self);
		

		// setup right side
		self.mgr = [AtlasSpriteManager spriteManagerWithFile:rImg capacity:1];
		[parent addChild:self.mgr z:FOREGROUND_Z_INDEX];

		// setup the sprite
		leftImage = [AtlasSprite spriteWithRect:CGRectMake(0,0,dim.x,dim.y) spriteManager:self.mgr];
		[self.mgr addChild:leftImage];
		leftImage.position = ccp(-1*dim.x/2+screenSize.width/2, dim.y/2);
		
		
		// setup the left side
		self.mgr = [AtlasSpriteManager spriteManagerWithFile:lImg capacity:1];
		[parent addChild:self.mgr z:FOREGROUND_Z_INDEX];
		
		// setup the right sprite
		rightImage = [AtlasSprite spriteWithRect:CGRectMake(0,0,dim.x,dim.y) spriteManager:self.mgr];
		[self.mgr addChild:rightImage];
		rightImage.position = ccp(dim.x/2+screenSize.width/2, dim.y/2);
		
	}
	
	return self;
}

@end
