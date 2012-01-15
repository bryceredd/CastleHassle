//
//  PlayerAreaManager.m
//  Rev3
//
//  Created by Bryce Redd on 1/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerAreaManager.h"
#import "PlayerArea.h"
#import "PlayerData.h"
#import "GameSettings.h"
#import "AI.h"

@implementation PlayerAreaManager

@synthesize playerAreas, extremeLeft, extremeRight;

-(id)initWithPlayerAreaWorld:(b2World*)world {
	
	if( (self=[super init])) {
		
		worldWidth = PLAYER_GROUND_WIDTH * MAX_PLAYERS;
		backgroundWidth = PLAYER_GROUND_WIDTH * BACKGROUND_SCALE_FACTOR;
		
		playerAreas = [[NSMutableArray alloc] initWithCapacity:MAX_PLAYERS];
		
		extremeLeft = extremeRight = nil;
		
		int numAI = [GameSettings instance].numPlayers-1;
		BOOL makeCity = NO;
		
		for(uint i=0; i<MAX_PLAYERS; i++) {
        
            BOOL indexIsPlayer = i == [GameSettings instance].playerID;
            
            if(indexIsPlayer) {
                makeCity = YES;
            } else {
                makeCity = numAI-- > 0;
            }

			
			PlayerArea* playerArea = [[[PlayerArea alloc] initWithLeft:PLAYER_GROUND_WIDTH*i 
												   dimentions:CGPointMake(PLAYER_GROUND_WIDTH, PLAYER_GROUND_HEIGHT)
														world:world] autorelease];
			
			if(makeCity) { 
                [playerArea makeCityWithColor:[[GameSettings instance] getColorForPlayerByID:i]]; 
            }
							
                            
			[playerAreas addObject:playerArea];
		}
        
		
		self.extremeLeft = [playerAreas objectAtIndex:0];
		self.extremeRight = [playerAreas objectAtIndex:MAX_PLAYERS-1];
		
	}
		
	return self;
	
}

-(void) loadAI {
	int numAI = [GameSettings instance].numPlayers-1;
	
	for(uint i=0; i<MAX_PLAYERS; i++) {
        BOOL indexIsPlayer = i == [GameSettings instance].playerID;
        
		if(!indexIsPlayer && numAI > 0) {
			numAI--;
			PlayerArea* pa = [playerAreas objectAtIndex:i];
			pa.ai = [AI aiWithPlayer:pa];
		}
	}
}

-(PlayerArea *) getLastPlayerArea {
	PlayerArea * retval = nil;
	
	for (uint i=0; i<MAX_PLAYERS; i++) {
		PlayerArea * pa = [playerAreas objectAtIndex:i];
		retval = retval == nil || retval.left < pa.left ? pa : retval;
	}
	
	return retval;
}

-(PlayerArea *) getFirstPlayerArea {
	PlayerArea * retval = nil;
	
	for (uint i=0; i<MAX_PLAYERS; i++) {
		PlayerArea * pa = [playerAreas objectAtIndex:i];
		retval = retval == nil || pa.left < retval.left ? pa : retval;
	}
	
	return retval;
}

-(BOOL) touchPos:(CGPoint)pos inPlayerArea:(int)player {
	PlayerArea * pa = [playerAreas objectAtIndex:player];
	
	return pos.x > pa.left && pos.x < pa.left + PLAYER_GROUND_WIDTH;
	
}

-(void) setExtremePlayerAreas {
	self.extremeLeft = [self getFirstPlayerArea];
	self.extremeRight = [self getLastPlayerArea];
}

-(void) checkAndMovePlayerAreas:(CGPoint)cameraLoc {
	
	if(cameraLoc.x < extremeLeft.left) {
	
		// fetch the last item and move it to the left
		NSLog(@"moving %@ to the left", extremeRight);

		[extremeRight moveToLeft:extremeLeft.left - PLAYER_GROUND_WIDTH];

		[self setExtremePlayerAreas];

	}
	
	if(cameraLoc.x > extremeRight.left) {
		
		// fetch the first item and move it to the right
		NSLog(@"moving %@ to the right", extremeLeft);
		
		[extremeLeft moveToLeft:extremeRight.left + PLAYER_GROUND_WIDTH];
		
		[self setExtremePlayerAreas];
	}
}

-(void) addPiece:(Piece *)p forPlayer:(PlayerArea*)pa {
	[pa addPiece:p];
}

-(void) removePiece:(Piece *)p forPlayer:(PlayerArea*)pa {	
	[pa removePiece:p];
}

-(PlayerArea*) getPlayerArea:(int)index {
	return [playerAreas objectAtIndex:index];
}

-(CGPoint) getBackImagePosFromObjPos:(CGPoint)piecePos cameraPosition:(CGPoint)camPos {

	float midScreen = camPos.x + 80;
	float span = midScreen - piecePos.x;
	
	if(fabs(span) > (.5 * worldWidth) - (.4 * backgroundWidth) &&
	   fabs(span) < (.5 * worldWidth) + (.6 * backgroundWidth)) {

		if(span > 0) {
			float distanceFromBorder = ((.5 * worldWidth) + (.5 * backgroundWidth) - span)/BACKGROUND_SCALE_FACTOR;
			return ccp(camPos.x+320.0-distanceFromBorder, piecePos.y/BACKGROUND_SCALE_FACTOR+PLAYER_BACKGROUND_HEIGHT);
		} else {
			float distanceFromBorder = ((.5 * worldWidth) + (.5 * backgroundWidth) + span)/BACKGROUND_SCALE_FACTOR;
			return ccp(camPos.x-160.0+distanceFromBorder, piecePos.y/BACKGROUND_SCALE_FACTOR+PLAYER_BACKGROUND_HEIGHT);
		}

	}
	
	return ccp(-100.0, -100.0);
}

-(int) getPlayerID:(PlayerArea*)pa {
	if([playerAreas indexOfObject:pa] ==  NSNotFound) return 0;
	else return [playerAreas indexOfObject:pa];
}

-(PlayerArea*) getCurrentPlayerArea {
	return [playerAreas objectAtIndex:[GameSettings instance].playerID];
}

-(int) getCurrentPlayerAreaID {
	return [playerAreas indexOfObject:[self getCurrentPlayerArea]];
}

- (void) dealloc {
    [super dealloc];
        
    [extremeLeft release];
    [extremeRight release];
    [playerAreas release];
    
}

@end
