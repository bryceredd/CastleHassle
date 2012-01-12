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
				  layer:(CCLayer*)parent 
				  index:(int)index 
		 parallaxFactor:(float)pf {
	
	if( (self=[super init])) {
		acceptsTouches = NO;
		acceptsDamage = NO;
		
		parallaxFactor = pf;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
        
		// setup the left sprite
		leftImage = spriteWithRect(lImg, CGRectMake(0,0,dim.x,dim.y));
        leftImage.position = ccp(-1*dim.x/2+screenSize.width/2, dim.y/2);
		[parent addChild:leftImage z:index];
    
		 
		// setup the right sprite
		rightImage = spriteWithRect(rImg, CGRectMake(0,0,dim.x,dim.y));
		rightImage.position = ccp(dim.x/2+screenSize.width/2-1, dim.y/2);
        [parent addChild:rightImage z:index];
	}
	
	return self;
}

@end
