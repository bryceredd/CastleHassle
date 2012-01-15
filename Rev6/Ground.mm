//
//  Ground.mm
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Ground.h"
#import "Battlefield.h"

@implementation Ground

@synthesize layer;

- (id)initWithGroundHeight:(int)height 
					 width:(int)width
					 world:(b2World*)w 
					 layer:(CCLayer*)parent {
	
	if((self = [super init])) {
		world = w;
		acceptsTouches = NO;
		acceptsDamage = NO;
		
		// set position in the  world
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		b2BodyDef bodydef;
		bodydef.position.Set(0,height);
		body = w->CreateBody(&bodydef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		

		// bottom wall
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		body->CreateFixture(&groundBox, 0);
		
		body->SetUserData(self);
		
	}
	
	return self;
}


- (id)initWithGroundHeight:(int)height 
					 world:(b2World*)w 
				 leftImage:(NSString *)lImg 
				rightImage:(NSString *)rImg 
			imageDimension:(CGPoint)dim
					 layer:(CCLayer*)parent {

	if((self = [super init])) {
		world = w;
		acceptsTouches = NO;
		acceptsDamage = NO;
		
		// set position in the  world
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		b2BodyDef bodydef;
		bodydef.position.Set(0,height);
		body = w->CreateBody(&bodydef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom wall
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		body->CreateFixture(&groundBox, 0);
		
		body->SetUserData(self);
		
        
        // setup the left side
        self.imageA = spriteWithRect(lImg, CGRectMake(0,0,dim.x,dim.y));
		[[Battlefield instance] addChild:self.imageA z:FOREGROUND_Z_INDEX];
        self.imageA.position = ccp(-1*dim.x/2+screenSize.width/2, dim.y/2);
		
		// setup the right sprite
		self.imageB = spriteWithRect(rImg, CGRectMake(0,0,dim.x,dim.y));
		[[Battlefield instance] addChild:self.imageB];
		self.imageB.position = ccp(dim.x/2+screenSize.width/2, dim.y/2);
		
	}
	
	return self;
}

@end
