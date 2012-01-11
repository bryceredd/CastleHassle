//
//  untitled.m
//  Rev3
//
//  Created by Bryce Redd on 1/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tileable.h"

@implementation Tileable

@synthesize leftImage, rightImage, parallaxFactor;

-(id) init {
	
	// ensure this doesn't go uninitialized
	parallaxFactor = 0.0;
	
	if( (self=[super init])) {
		
	}
	
	return self;
}

- (float) getExtremeLeft {
	return leftImage.position.x < rightImage.position.x ? leftImage.position.x - (leftImage.textureRect.size.width/2) : rightImage.position.x - (rightImage.textureRect.size.width/2);
}

- (float) getExtremeRight {
	// sexy line... please change
	return leftImage.position.x < rightImage.position.x ? rightImage.position.x + (rightImage.textureRect.size.width/2) - [Director sharedDirector].winSize.height : leftImage.position.x + (leftImage.textureRect.size.width/2) - [Director sharedDirector].winSize.height;
}

- (CCSprite *) getUnseenSprite:(CGPoint)pos result:(int)res{
	
	if(res > 0)
		return leftImage.position.x < rightImage.position.x ? leftImage : rightImage;
	else 
		return leftImage.position.x > rightImage.position.x ? leftImage : rightImage;
	
}

- (int) cameraOutOfBounds:(CGPoint)pos {
	
	// we calculate the left and right most points for the tiling images
	float extremeLeft = [self getExtremeLeft];
	float extremeRight = [self getExtremeRight];
	
	if(pos.x-[Director sharedDirector].winSize.height/2 < extremeLeft)
		return -1;
	if(pos.x > extremeRight)
		return 1;
	
	return 0;
	
}

- (void) repositionSprite:(CGPoint)pos result:(int)res {
	
	CCSprite * sprite = [self getUnseenSprite:pos result:res];
	
	// the last part is to scoot the images 2 pixels closer
    CGPoint position = ccp( sprite.textureRect.size.width*2*(float)res+(-2*(float)res) + sprite.position.x, sprite.position.y);
	
    sprite.position = position;

	
}

- (void) positionForCameraLoc:(CGPoint)loc {
	int res;
    
	if((res = [self cameraOutOfBounds:loc])) {
		[self repositionSprite:loc result:res];
	}	
}

@end
