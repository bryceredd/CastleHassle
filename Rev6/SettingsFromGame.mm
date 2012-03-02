//
//  SettingsFromGame.m
//  Rev5
//
//  Created by xCode on 3/31/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import "SettingsFromGame.h"
#import "MainMenu.h"
#import "MainScene.h"
#import "HUDActionController.h"
#import "Battlefield.h"
#import "CHToggle.h"
#import "CHToggleItem.h"
#import "GameSettings.h"

@implementation SettingsFromGame


- (id) init {
	if((self = [super init])) {
		if (self != nil) {
						
			navBack = [CCSprite spriteWithFile:@"menuBack.png"];
			navBack.position = ccp(480.0/2.0, 320.0/2.0);
			[self addChild:navBack z:0];
			
			CCLabelTTF* title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Arial-BoldMT" fontSize:24];
			[title setColor:ccc3(15, 147, 222)];
			title.position = ccp(240,280);
			[self addChild:title];
			
			[self makeButtonWithString:@"Return"
										atPosition:ccp(-150,-120)
									  withSelector:@selector(closeWindow:)];
			
			[self makeButtonWithString:@"Abandon Game"
										atPosition:ccp(150,-120)
									  withSelector:@selector(leaveGame:)];
			
			[self setupFollowShot];
			[self setupSound];
			
		}
	}
	
	return self;
}

-(void) setupFollowShot {
	followShot = [[CHToggle alloc] initWithImageName:@"comboButtons.png"];
	
	CHToggleItem* on = [[CHToggleItem alloc] initWithParent:followShot 
											   selectedRect:CGRectMake(0, 121, 94, 36) 
											 deselectedRect:CGRectMake(0, 157, 94, 36) 
												 buttonText:@"        On"];
	[followShot addItem:on];
	[on setYOffset:5];
	[on release];
	
	CHToggleItem* off = [[CHToggleItem alloc] initWithParent:followShot 
												selectedRect:CGRectMake(186, 121, 94, 36)
											  deselectedRect:CGRectMake(186, 157, 94, 36) 
												  buttonText:@"        Off"];
	[followShot addItem:off];
	[off setYOffset:5];
	[off release];
	[followShot setAnchorPoint:ccp(0,0)];
	[followShot setPosition:ccp(70,10)];
	[self addChild:followShot z:3];
	
	
	CCLabelTTF* followShotLabel = [CCLabelTTF labelWithString:@"Follow shot" fontName:@"Arial-BoldMT" fontSize:18];
	[followShotLabel setColor:ccc3(15, 147, 222)];
	[followShotLabel setAnchorPoint:ccp(0,.5)];
	[followShotLabel setPosition:ccp(50,172)];
	[followShot selectItemAtIndex:([GameSettings instance].followShot?0:1)];
	
	[self addChild:followShotLabel];
}

-(void) setupSound {
	CCLabelTTF* soundLabel = [CCLabelTTF labelWithString:@"Sound" fontName:@"Arial-BoldMT" fontSize:18];
	
	[soundLabel setColor:ccc3(15, 147, 222)];
	[soundLabel setAnchorPoint:ccp(0,.5)];
	soundLabel.position = ccp(50,222);
	[self addChild:soundLabel];
	
	soundState = [[CHToggle alloc] initWithImageName:@"comboButtons.png"];
	
	CHToggleItem *son = [[CHToggleItem alloc] initWithParent:soundState
												selectedRect:CGRectMake(0,122,94,33) 
											  deselectedRect:CGRectMake(0,159,94,33) 
												  buttonText:@"         On        "];
	
	[son setYOffset:5];
	[soundState addItem:son];
	[son release];
	
	CHToggleItem *soff = [[CHToggleItem alloc] initWithParent:soundState
												 selectedRect:CGRectMake(187,122,94,33)
											   deselectedRect:CGRectMake(187,159,94,33)
												   buttonText:@"        Off        "];
	
	[soff setYOffset:5];
	[soundState addItem:soff];
	[soff release];
	
	[soundState selectItemAtIndex:([GameSettings instance].hasSound?0:1)];
	[soundState setPosition:ccp(70,60)];
	[self addChild:soundState z:3];
}

-(void) toggled:(id)sender {
	[GameSettings instance].hasSound = soundState.selectedIndex==0;
}

-(void) leaveGame:(id)send {
	[[Battlefield instance] loseGame];
}

-(void) closeWindow:(id)sender {
	[GameSettings instance].followShot = followShot.selectedIndex==0;
	[GameSettings instance].hasSound = soundState.selectedIndex==0;
	
	[[HUDActionController instance] hideSettings];
}


@end
