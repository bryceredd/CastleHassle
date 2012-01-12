//
//  CHToggleItem.m
//  Rev5
//
//  Created by Bryce Redd on 3/14/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import "CHToggleItem.h"
#import "CHToggle.h"
#import "SinglePlayer.h"
#import "TVMacros.h"

@implementation CHToggleItem

@synthesize img, item, yOffset;

-(id) initWithParent:(CHToggle*)p selectedRect:(CGRect)sel deselectedRect:(CGRect)desel buttonText:(NSString*)str {
	
	if( (self =[super init]) ) {
		parent = p;
		
		selectedRect = sel;
		unselectedRect = desel;
        img = spriteWithRect(p.image, sel);
		[parent addChild:img];
		
		item = [CCMenuItemFont itemFromString:str target:self selector:@selector(responder:)];
		
		[item setAnchorPoint:ccp(.5,.5)];
		[item setContentSize:sel.size];
		
		CCMenu* menu = [CCMenu menuWithItems:item, nil];
		
		[parent addChild:menu];
	}
	
	return self;
	
}

-(void) setSelected:(BOOL)b {

	if(b) {
		img.textureRect = selectedRect;
		item.color = ccc3(240, 240, 240);
	} else {
		img.textureRect = unselectedRect;
		item.color = ccc3(30, 30, 30);
	}
	
}

-(void) setPosition:(CGPoint)p {
	img.position = ccpAdd(ccp(240.0,160.0), p);
	item.position = ccpAdd(p, ccp(0, yOffset));	
}

-(void) responder:(id)sender {
	[parent toggled:self];
}

@end
