//
//  CHTable.m
//  Rev5
//
//  Created by Bryce Redd on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CHTable.h"
#import "CHTableButton.h"
#import "PlayerData.h"
#import "GameData.h"

@implementation CHTable

+ (id) tableWithParent:(id)p {
	return [[[self alloc] initWithParent:(id)p] autorelease];
}

-(id) initWithParent:(id)p {
	if( (self = [super init]) ) {
		responder = p;
		items = nil;
		rowdata = nil;
		selectedGameData = nil;
		offset = 0;
		
		next = [self makeButtonFromRect:CGRectMake(146, 78, 38, 37) atPosition:ccp(190,122) withSelector:@selector(getNextPage:)];
		prev = [self makeButtonFromRect:CGRectMake(105, 78, 38, 37) atPosition:ccp(148,122) withSelector:@selector(getPreviousPage:)];		
		
		[next setIsEnabled:NO];
		[prev setIsEnabled:NO];
	}
	return self;
}

-(void) setData:(NSArray*)data{
	if(!rowdata)
		[rowdata release];
	rowdata = [data retain];
	
	[self updateView];
}

-(void) updateView {
	if(items) 
		[items release];
	
	items = [[NSMutableArray alloc] init];
	
	for(int count=0;count<MAX_ROWS;++count) {
		if((uint)(count+offset*MAX_ROWS) < [rowdata count]) { 
			GameData* datum = [[rowdata objectAtIndex:count+offset*MAX_ROWS] retain];
			CHTableButton* btn = [CHTableButton tableButtonWithTextureRect:[self rowRect] gameData:datum table:self];
            [self addChild:btn z:6];
			[items addObject:btn];
			[btn setPosition:ccp(0,80.0-(41.0*((float)[items count]-1.0)))];
		} 
	}
	
	[next setOpacity:[self hasNextPage]?255.0:50.0];
	[prev setOpacity:[self hasPreviousPage]?255.0:50.0];
	
	[next setIsEnabled:[self hasNextPage]];
	[prev setIsEnabled:[self hasPreviousPage]];
}

-(void) toggled:(id)sender {
	int index = [items indexOfObject:sender];
	[self selectItemAtIndex:index];
}

-(void) selectItemAtIndex:(int)index {
	[self clearSelection];
	CHTableButton* item = [items objectAtIndex:index];
	selectedGameData = item.gameDatum;
	[item setSelected:YES];
}

-(GameData*) selectedGame {
	return selectedGameData;
}

-(void) clearSelection {
	for(CHTableButton* item in items)
		[item setSelected:NO];
}

-(CGRect) rowRect {
	return CGRectMake(0, 0, 458, 41);
}

-(void) setTable:(NSArray*)data {
	
}

-(void) getNextPage:(id)sender {
	selectedGameData = nil;
	offset++;
	[self updateView];
}

-(void) getPreviousPage:(id)sender {
	selectedGameData = nil;
	offset--;
	[self updateView];
}

-(BOOL) hasNextPage {
	return [rowdata count]>(uint)((offset+1)*MAX_ROWS);
}

-(BOOL) hasPreviousPage {
	return offset>0;
}

-(void) dealloc {
	[items release];
    [rowdata release];
	
	[super dealloc];
}

@end
