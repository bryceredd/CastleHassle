//
//  MainScene.m
//  Rev3
//
//  Created by Bryce Redd on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainScene.h"
#import "Battlefield.h"
#import "HUD.h"

@implementation MainScene

+(id) scene {
	CCScene *scene = [CCScene node];
	
	[scene addChild:[MainScene node]];
	
	return scene;
}

-(id) init {
	
	if( (self=[super init])) {
		
		Battlefield *bf = [Battlefield instance];
		
		[self addChild:bf];		
	}
	
	return self;
}

@end
