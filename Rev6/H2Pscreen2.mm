//
//  H2Pscreen2.m
//  Rev5
//
//  Created by Dave Durazzani on 4/1/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "H2Pscreen2.h"
#import "MainMenu.h"
#import "MainScene.h"
#import "HowToPlay.h"



@implementation H2Pscreen2

static H2Pscreen2 *instance = nil;

+(H2Pscreen2 *) instance{
	if (instance == nil) {
		instance = [H2Pscreen2 alloc];
		[H2Pscreen2 init];
	}
	return instance;
}


-(id) init {
	
	if ((self = [super init])) {
		NSLog(@"H2Pscreen2 Init called");
		
		CCSprite *wall = [CCSprite spriteWithFile:@"screen2.png"];
		[wall setPosition:ccp(240,160)];
		[self addChild:wall z:0];
		
		
		[self makeButtonWithString:NSLocalizedString(@"Back",@"Back button from HowToPlay.mm") 
						atPosition:ccp(-150,-120) 
					  withSelector:@selector(previousScreen:)];
		
		[self makeButtonWithString:NSLocalizedString(@"Next",@"Back button from HowToPlay.mm")
						atPosition:ccp(150,-120) 
					  withSelector:@selector(mainMenuCall:)];
	}
	
	if (!instance) {
		instance = self;
	}
	
	return self;
	
}

-(void)mainMenuCall:(id)sender {
	NSLog(@"mainMenuCalled");
	MainMenu * main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[MainMenuLayer node]];
}


-(void)previousScreen:(id)sender{
	NSLog(@"Previous Screen Button Pressed");
	MainMenu * main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[HowToPlay node]];
}

-(void)dealloc {
	
	[super dealloc];
}


@end
