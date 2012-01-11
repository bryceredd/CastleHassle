//
//  GameData.m
//  Rev5
//
//  Created by Bryce Redd on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameData.h"

NSString * Title = @"title";
NSString * Players = @"players";
NSString * GameID = @"gameid";

@implementation GameData

@synthesize name, gameID, maxGamePlayers, currentGamePlayers;

+(id) dataFromDefinition:(NSDictionary*)dict {
	return [[[self alloc] initWithDefinition:dict] autorelease];
}

-(id) initWithDefinition:(NSDictionary*)definition {
	if( (self = [super init]) ) {
		[self init];
		
		if(![definition isKindOfClass:[NSDictionary class]]) { return self; }
		
		name = [[definition objectForKey:Title] retain];
		gameID = [[definition objectForKey:GameID] intValue];
		
		NSArray* players = [definition objectForKey:Players];
		currentGamePlayers = [players count];
		isMultiPlayer = YES;
		
	} return self;
}

-(id) init {
	if( (self = [super init]) ) {
		name = @"";
		gameID = 0;
		currentGamePlayers = 0;
		maxGamePlayers = 4;
	} return self;	
}

-(BOOL) isFull {
	return  currentGamePlayers == maxGamePlayers;	
}

-(void) dealloc {
	[name release], name = nil;
	[super dealloc];
}

@end
