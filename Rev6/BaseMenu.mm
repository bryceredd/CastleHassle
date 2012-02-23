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

-(CCMenuItemSprite*)makeButtonWithString:(NSString*)s atPosition:(CGPoint)p withSelector:(SEL)selector {
	[CCMenuItemFont setFontSize:16];
    
    CGRect buttonFrame = CGRectMake(0, 38, 124, 38);
    
    CCSprite* button = spriteWithRect(@"stdButtons.png", buttonFrame);
    CCSprite* selectedButton = spriteWithRect(@"stdButtonsPressed.png", buttonFrame);
    
    CCMenuItemSprite* menuItem = [CCMenuItemSprite itemFromNormalSprite:button 
													selectedSprite:selectedButton 
															target:self 
														  selector:selector];
	
	menuItem.position = p;
    
    
	CCLabelTTF* label = [CCLabelTTF labelWithString:s fontName:@"arial" fontSize:15.f];
    label.position = ccp(buttonFrame.size.width / 2.f, buttonFrame.size.height / 2.f);
    
    [menuItem addChild:label];
	
    CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
	[self addChild:menu z:6];
    
    return menuItem;
}

-(CCMenuItemSprite*)makeButtonFromRect:(CGRect)rect atPosition:(CGPoint)p withSelector:(SEL)selector {
	
    CCSprite* button = spriteWithRect(@"stdButtons.png", rect);
    CCSprite* selectedButton = spriteWithRect(@"stdButtonsPressed.png", rect);
	
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
