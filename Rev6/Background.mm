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
		self.imageA = spriteWithRect(lImg, CGRectMake(0,0,dim.x,dim.y));
        self.imageA.position = ccp(-1*dim.x/2+screenSize.width/2, dim.y/2);
        self.imageA.anchorPoint = ccp(0,.5);
		[parent addChild:self.imageA z:index];
    
		 
		// setup the right sprite
		self.imageB = spriteWithRect(rImg, CGRectMake(0,0,dim.x,dim.y));
		self.imageB.position = ccp(dim.x/2+screenSize.width/2-1, dim.y/2);
        self.imageB.anchorPoint = ccp(0,.5);
        [parent addChild:self.imageB z:index];
	}
	
	return self;
}

@end
