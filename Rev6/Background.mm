//
//  Ground.mm
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Background.h"

@implementation Background

- (id)initWithLeftImage:(NSString *)lImg 
			 rightImage:(NSString *)rImg
		 imageDimension:(CGPoint)dim
				  layer:(Layer*)parent 
				  index:(int)index 
		 parallaxFactor:(float)pf {
	
	if( (self=[super init])) {
		acceptsTouches = NO;
		acceptsDamage = NO;
		
		parallaxFactor = pf;
		
		CGSize screenSize = [Director sharedDirector].winSize;
		
		// setup right side
		self.mgr = [AtlasSpriteManager spriteManagerWithFile:rImg capacity:1];
		[parent addChild:self.mgr z:index];
		
		// setup the sprite
		leftImage = [AtlasSprite spriteWithRect:CGRectMake(0,0,dim.x,dim.y) spriteManager:self.mgr];
		[self.mgr addChild:leftImage];
		leftImage.position = ccp(-1*dim.x/2+screenSize.width/2, dim.y/2);
		
		
		// setup the left side
		self.mgr = [AtlasSpriteManager spriteManagerWithFile:lImg capacity:1];
		[parent addChild:self.mgr z:index];
		 
		// setup the right sprite
		rightImage = [AtlasSprite spriteWithRect:CGRectMake(0,0,dim.x,dim.y) spriteManager:self.mgr];
		[self.mgr addChild:rightImage];
		rightImage.position = ccp(dim.x/2+screenSize.width/2-1, dim.y/2);
		
	}
	
	return self;
}

@end
