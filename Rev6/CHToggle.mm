//
//  CHToggle.m
//  Rev5
//
//  Created by Bryce Redd on 3/14/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import "CHToggle.h"
#import "CHToggleItem.h"
#import "MainScene.h"


@implementation CHToggle

@synthesize position, image, selectedIndex;

-(id)initWithImageName:(NSString*)s {
	
	if( (self = [super init]) ) {
        self.image = s;
		items = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)setPosition:(CGPoint)p {
	position = p;
	
	for (uint i=0; i<[items count]; ++i) {
		int offset = 0;
		
		if(i) {
			offset += ((CHToggleItem*)[items objectAtIndex:i-1]).img.textureRect.size.width/2;
			offset += ((CHToggleItem*)[items objectAtIndex:i-1]).img.position.x;
			offset += ((CHToggleItem*)[items objectAtIndex:i]).img.textureRect.size.width/2;
			offset -= 240;
			[[items objectAtIndex:i] setPosition:ccp(offset, p.y)];
		} else {
			[[items objectAtIndex:i] setPosition:p];
		}
	}
}

-(void)addItem:(CHToggleItem*)item {
	[items addObject:item];
	[self clearSelection];
	[self selectItemAtIndex:0];
}

-(void)selectItem:(id)sender {}

-(void)selectItemAtIndex:(int)index {
	[self clearSelection];
	CHToggleItem* item = [items objectAtIndex:index];
	[item setSelected:YES];
	selectedIndex = index;
}

-(void)clearSelection {
	for(CHToggleItem* item in items)
		[item setSelected:NO];
}

-(int)getSelected {
	return selectedIndex;
}

-(void)toggled:(id)sender {
	int index = [items indexOfObject:sender];
	selectedIndex = index;
	[self selectItemAtIndex:index];
	//[[Director sharedDirector] replaceScene: [MainScene scene]];
	
	// !!!!! [parent toggled:nil];
}

-(void) dealloc {
	[super dealloc];
	
	[items release];
    [image release];
}

@end
