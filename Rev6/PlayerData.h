//
//  PlayerData.h
//  Rev5
//
//  Created by Bryce Redd on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerData : NSObject {
	uint playerID;
	NSString* name;
}

@property(nonatomic, retain) NSString* name;
@property(nonatomic) uint playerID;

+(PlayerData *) instance;

@end