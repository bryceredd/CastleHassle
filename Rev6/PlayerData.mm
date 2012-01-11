//
//  PlayerData.m
//  Rev5
//
//  Created by Bryce Redd on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerData.h"
#import "PListReader.h"

@implementation PlayerData

@synthesize name, playerID;

static PlayerData * instance = nil;

+(PlayerData *) instance {
	if(instance == nil) {
		instance = [[PlayerData alloc] init];
	} return instance;
}

-(id) init {

	if((self = [super init])) {		
		NSDictionary* props = [PListReader getAppPlist];
		name = (NSString *)[props objectForKey:@"name"];	
		
		if([name length] <= 0)
			name = @"Unnamed Soldier";
		
	}
	return self;
}

@end
