//
//  CannonBallTrail.m
//  Rev5
//
//  Created by Bryce Redd on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CatapultBallTrail.h"

@implementation CatapultBallTrail
-(id) init {
	return [self initWithTotalParticles:50 color:(ccColor3B){255, 255, 255}];
}

-(id) initWithTotalParticles:(int)p color:(ccColor3B)color {
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
    self.startSize = 20.0f;
	self.startSizeVar = 10.0f;
    
	
	// additive
	self.blendAdditive = YES;
	
	return self;
}

@end
