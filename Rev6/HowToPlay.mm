//
//  HowToPlay.m
//  Rev5
//
//  Created by xCode on 4/2/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HowToPlay.h"
#import "MainMenu.h"
#import "MainScene.h"
#import "H2Pscreen2.h"

@implementation HowToPlay

static HowToPlay *instance = nil;

+(HowToPlay *) instance{
	if (instance == nil) {
		instance = [HowToPlay alloc];
		[HowToPlay init];
	}
	return instance;
}


-(id) init {
	
	if ((self = [super init])) {
		NSLog(@"HowToPlay Init called");
		
		CCSprite *wall = [CCSprite spriteWithFile:@"screen1.png"];
		[wall setPosition:ccp(240,160)];
		[self addChild:wall z:0];
		
		
		[self makeButtonWithString:NSLocalizedString(@"Back",@"Back button from HowToPlay.mm")
						atPosition:ccp(-150,-120) 
					  withSelector:@selector(previousScreen:)];
		
		[self makeButtonWithString:NSLocalizedString(@"Next",@"next button from HowToPlay.mm")
						atPosition:ccp(150,-120) 
					  withSelector:@selector(screen2Call:)];
	}
	
	if (!instance) {
		instance = self;
	}
	
	return self;
	
}

-(void)screen2Call:(id)sender
{
	NSLog(@"Screen 2");
	MainMenu* main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[H2Pscreen2 node]];	
}

-(void)previousScreen:(id)sender 
{
	NSLog(@"Previous Screen Button Pressed");
	MainMenu * main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[MainMenuLayer node]];
}

-(void)dealloc {
	
	[super dealloc];
}


@end
