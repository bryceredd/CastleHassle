//
//  GameData.h
//  Rev5
//
//  Created by Bryce Redd on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameData : NSObject {
	NSString* name;
	int gameID;
	int maxGamePlayers;
	int currentGamePlayers;
	BOOL isMultiPlayer;
}

@property(nonatomic, retain)NSString* name;
@property(nonatomic)int gameID;
@property(nonatomic)int maxGamePlayers;
@property(nonatomic)int currentGamePlayers;

-(id) initWithDefinition:(NSDictionary*)definition;
+(id) dataFromDefinition:(NSDictionary*)dict;
-(BOOL) isFull;

@end
