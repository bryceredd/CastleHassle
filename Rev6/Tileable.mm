//
//  untitled.m
//  Rev3
//
//  Created by Bryce Redd on 1/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tileable.h"

@implementation Tileable

@synthesize imageA, imageB, parallaxFactor;


- (float) getExtremeLeft {
    return MIN(imageA.position.x, imageB.position.x);
}

- (float) getExtremeRight {
    return MAX(imageA.position.x + imageA.textureRect.size.width, imageB.position.x + imageB.textureRect.size.width);
}

- (CCSprite *) getUnseenSprite:(CGPoint)pos result:(int)res{
	
	if(res > 0)
		return imageA.position.x < imageB.position.x ? imageA : imageB;
	else 
		return imageA.position.x > imageB.position.x ? imageA : imageB;
}

- (int) cameraOutOfBounds:(CGPoint)pos {
	
    float screenWidth = MAX([CCDirector sharedDirector].winSize.width, [CCDirector sharedDirector].winSize.height);
    
	// we calculate the left and right most points for the tiling images
	float extremeLeft = [self getExtremeLeft];
	float extremeRight = [self getExtremeRight];
	
    
	if(pos.x < extremeLeft) {
		return -1;
    }
	if(pos.x > extremeRight - screenWidth) {
		return 1;    
    }
	
	return 0;
}

- (void) repositionSprite:(CGPoint)pos result:(int)res {
	
	CCSprite * sprite = [self getUnseenSprite:pos result:res];
	
	// the last part is to scoot the images 2 pixels closer
    sprite.position = ccp(sprite.textureRect.size.width * 2 * res + (-2 * res) + sprite.position.x, sprite.position.y);
	
}

- (void) positionForCameraLoc:(CGPoint)loc {
	int res;
    
	if((res = [self cameraOutOfBounds:loc])) {
		[self repositionSprite:loc result:res];
	}	
}

@end
