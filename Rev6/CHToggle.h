//
//  CHToggle.h
//  Rev5
//
//  Created by Bryce Redd on 3/14/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CHToggleItem;

@interface CHToggle : CCLayer {
	NSMutableArray* items;
	CGPoint position;
	int selectedIndex;
}

@property(nonatomic, assign) CGPoint position;
@property(nonatomic, assign) int selectedIndex;
@property(nonatomic, retain) NSString* image;

-(id)initWithImageName:(NSString*)s;
-(void)addItem:(CHToggleItem*)item;
-(void)selectItem:(id)sender;
-(void)selectItemAtIndex:(int)index;
-(int)getSelected;
-(void)toggled:(id)sender;
-(void)clearSelection;
@end
