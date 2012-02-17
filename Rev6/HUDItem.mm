//
//  HUDItem.m
//  Rev3
//
//  Created by Bryce Redd on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HUDItem.h"
#import "Battlefield.h"

@implementation HUDItem

@synthesize leftBound, rightBound, img, swingImg, imageName;

-(id) init {
	if( (self=[super init])) {
		swingImg = nil;
	}
	
	return self;
}

-(void) postInit{}
-(BOOL) handleDragExit:(CGPoint)p{return NO;}
-(BOOL) handleInitialTouch:(CGPoint)p{return NO;}
-(void) move:(CGPoint)p {
	img.position = CGPointMake(img.position.x - p.x, img.position.y);
}

- (void) hideWithAnimation:(BOOL)animation {
    if(animation) {
        [img runAction:[CCFadeOut actionWithDuration:.25]];
    } else {
        img.visible = NO;
    }
}

-(void) show {
    [img runAction:[CCFadeIn actionWithDuration:.25]];
	float camX,camY,camZ;
	[[Battlefield instance].camera centerX:&camX centerY:&camY centerZ:&camZ];
	img.position = ccp(leftBound+(rightBound-leftBound)/2+camX, img.position.y);
}

- (void) dealloc {
    [img release];
    [swingImg release];
    [managerName release];
    
    [super dealloc];
}

@end
