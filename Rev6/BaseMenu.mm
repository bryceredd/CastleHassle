//
//  BaseMenuy.m
//  Rev5
//
//  Created by Bryce Redd on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseMenu.h"

@implementation BaseMenu

-(id) init {

	if( (self = [super init])) {
	}
	
	return self;
	
}

-(CCMenuItemFont*)makeButtonWithString:(NSString*)s atPosition:(CGPoint)p withSelector:(SEL)selector {
	[CCMenuItemFont setFontSize:16];
    
    CCSprite* button = spriteWithRect(@"stdButtons.png", CGRectMake(0, 38, 124, 38));
    [self addChild:button z:2];
	
	button.position = ccpAdd(ccp(240.0,160.0), p);
	
	CCMenuItemFont *menuItem = [CCMenuItemFont itemFromString:s target:self selector:selector];
	menuItem.position = p;
	
	CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
	[self addChild:menu z:6];
	
	return menuItem;
}

-(CCMenuItemSprite*)makeButtonFromRect:(CGRect)rect atPosition:(CGPoint)p withSelector:(SEL)selector {
	
    CCSprite* button = spriteWithRect(@"stdButtons", rect);
    CCSprite* selectedButton = spriteWithRect(@"stdButtons", rect);
	
	CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:button 
													selectedSprite:selectedButton 
															target:self 
														  selector:selector];
	menuItem.position = p;
	button.position = ccpAdd(ccp(240.0,160.0), p);
	selectedButton.position = ccpAdd(ccp(240.0,160.0), p);
	
    [self addChild:button z:2];
	[self addChild:selectedButton z:2];
	
	CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
	[self addChild:menu z:6];
	
	return menuItem;
}

-(void)toggled:(id)sender {}

@end
