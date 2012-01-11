//
//  HUDMenu.m
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HUDMenu.h"
#import "PieceList.h"
#import "BuildItem.h"
#import "StatusItem.h"
#import "ButtonItem.h"
#import "GoldItem.h"
#import "PurchaseItem.h"
#import "Battlefield.h"

@implementation HUDMenu

@synthesize items, selected;

-(id) initWithManagers:(NSDictionary*)mans {
	
	if( (self=[super init]) ) {
		extremeRight = ICON_SPACING;
		managers = mans;

		self.items = [NSMutableArray array];
	}

	return self;
}

-(StatusItem *) addStatusItemWithManagerName:(NSString *)mgrName imageBox:(CGRect)box swingImageBox:(CGRect)swingBox piece:(Piece*)p {
	StatusItem *item = [[[StatusItem alloc] init] autorelease];
	
	// modify box to be more wide	
	[self addItemWithManagerName:mgrName imageBox:box swingImageBox:swingBox hudItem:item expandToStatusSize:YES];
	
	AtlasSpriteManager* mgr = [managers objectForKey:mgrName];
	
	[self setSwingItemWithManager:mgr swingBox:swingBox imageBox:box forItem:item forClass:[p class]];
	
	[item postInitWithPiece:p];
	[items addObject:item];
    
	return item;
}

-(BuildItem *) addBuildItemWithManagerName:(NSString *)mgrName imageBox:(CGRect)box swingImageBox:(CGRect)swingBox class:(Class)c price:(int)p {
	BuildItem *item = [[[BuildItem alloc] initWithPrice:p] autorelease];
	
	[self addItemWithManagerName:mgrName imageBox:box swingImageBox:swingBox hudItem:item expandToStatusSize:NO];
	
	AtlasSpriteManager* mgr = [managers objectForKey:mgrName];
	
	[self setSwingItemWithManager:mgr swingBox:swingBox imageBox:box forItem:item forClass:c];
	
	[item setCreationClass:c];
	
	[items addObject:item];

	return item;
}

-(ButtonItem *) addButtonItemWithManagerName:(NSString *)mgrName 
									imageBox:(CGRect)box 
							   swingImageBox:(CGRect)swingBox 
									selector:(SEL)s 
									   title:(NSString*)t {
	ButtonItem *item = [[[ButtonItem alloc] init] autorelease];
	
	[self addItemWithManagerName:mgrName imageBox:box swingImageBox:swingBox hudItem:item expandToStatusSize:NO];
	
	[item postInitWithText:t];
	item.func = s;
	
	[items addObject:item];
    
	return item;
}

-(PurchaseItem *) addPurchaseItemWithManagerName:(NSString *)mgrName 
									imageBox:(CGRect)box 
							   swingImageBox:(CGRect)swingBox 
									selector:(SEL)s 
										   title:(NSString*)t piece:(Piece*)p {
	PurchaseItem *item = [[[PurchaseItem alloc] initWithPiece:p] autorelease];
	
	[self addItemWithManagerName:mgrName imageBox:box swingImageBox:swingBox hudItem:item expandToStatusSize:NO];
	
	[item postInitWithText:t];
	item.func = s;
	
	[items addObject:item];

	return item;
}

-(GoldItem *) addGoldStatusWithLeft:(float)l {
	GoldItem *item = [[[GoldItem alloc] init] autorelease];
	
	[self addItemWithManagerName:@"coins"
						imageBox:CGRectMake(0, 0, 20, 20) 
				   swingImageBox:CGRectMake(0,0,0,0) 
						 hudItem:item 
			  expandToStatusSize:NO];
	
	item.leftBound = l;
	item.rightBound = l+100;
	
	[item postInit];
	[items addObject:item];
	return item;
}

-(void) addItemWithManagerName:(NSString *)mgrName 
					  imageBox:(CGRect)box 
				 swingImageBox:(CGRect)swingBox 
					   hudItem:(HUDItem*)item 
			expandToStatusSize:(BOOL)expand {
	AtlasSpriteManager* mgr = [managers objectForKey:mgrName];
	
	// set left/right limits
	item.leftBound = extremeRight;
	extremeRight += expand ? HUD_STATUS_ITEM_SIZE + ICON_SPACING : box.size.width + ICON_SPACING;
	item.rightBound = extremeRight;
	
	// create sprites along top border
	item.img = [AtlasSprite spriteWithRect:box 
							 spriteManager:mgr];
	
	// put the sprite in the right position
	item.img.position = ccp(item.leftBound+(item.rightBound-item.leftBound)/2, 320-(HUD_HEIGHT/2));
	
	item.managerName = mgrName;
	
	[item postInit];
	
	// draw the sprite on the screen
	[mgr addChild:item.img];
}


-(void) setSwingItemWithManager:(AtlasSpriteManager*)mgr swingBox:(CGRect)swingBox imageBox:(CGRect)box forItem:(HUDItem*)item forClass:(Class)c {
	// if there was a swing box, draw it and add it
	if(swingBox.size.width > 0 && swingBox.size.height > 0) {
		
		item.swingImg = [AtlasSprite spriteWithRect:swingBox 
									  spriteManager:mgr];
		
		// put the sprite in the right position
		item.swingImg.rotation = 45;
		
		// draw the sprite on the screen
		[mgr addChild:item.swingImg];
	}
	
	// reposition the base
	if (c == [Catapult class])
		item.img.position = ccpAdd(item.img.position, ccp(0, -2.0));
	
	if (c == [Cannon class])
		item.img.position = ccpAdd(item.img.position, ccp(0, -8.0));
	
		
}

-(void) moveAllObjects:(CGPoint)p {
	for (HUDItem *item in items) {
		[item move:p];
	}
}

-(void) hideAll {
	for (HUDItem *item in items) {
		[item hide];
	}
}

-(void) showAll {
	for (HUDItem *item in items) {
		[item show];
	}
}

-(BOOL) handleInitialTouch:(CGPoint)p {
	if(CGRectContainsPoint([self hudRect], p)) {
		self.selected = [self getHUDItem:p];
		
		if(!selected) return NO;
		
		[selected handleInitialTouch:p];
				
		return YES;
	}
	
	return NO;
}

-(BOOL) handleTouchDrag:(CGPoint)p {
	if(selected) {
		if(CGRectContainsPoint([self hudRect], p)) {
			return YES;
		} else {
			[self handleDragExit:p];
		}
		
	}
	
	return NO;
}

-(BOOL) handleEndTouch:(CGPoint)p {
	if(selected) {
		self.selected = nil;
		return YES;
	}
	
	return NO;
}

-(BOOL) handleDragExit:(CGPoint)p {
	
	if(selected) {
		[selected handleDragExit:p];
	}
	
	self.selected = nil;
	
	return NO;
}

-(CGRect) hudRect {
	return CGRectMake(0,320-HUD_HEIGHT,480,HUD_HEIGHT);
}

-(HUDItem *) getHUDItem:(CGPoint)p {
	for (HUDItem *item in items) {
		if(item.leftBound < p.x && item.rightBound > p.x) {
			return item;
		}
	}
	
	return nil;
}

- (void) dealloc {
    [selected release];
    [items release];

    [super dealloc];    
}


@end
