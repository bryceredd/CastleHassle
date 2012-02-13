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
#import "Battlefield.h"
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

- (void) loadPlayer {
     NSString* file = nil;
                
    if([GameSettings instance].type == easy) 
        file = @"playerEasy";
    else if([GameSettings instance].type == medium)
        file = @"playerMedium";
    else if([GameSettings instance].type == hard)
        file = @"playerHard";

    
    for(uint i=0; i<MAX_PLAYERS; i++) {
        BOOL indexIsPlayer = i == [GameSettings instance].playerID;
        if(indexIsPlayer) {
            PlayerArea* pa = [playerAreas objectAtIndex:i];
            [[Battlefield instance] loadForPlayer:pa file:file];
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

    // calculate the possible position of the piece both to the right and left,
    // 
    // keep whichever is closer

    
    float screenWidth = MAX([CCDirector sharedDirector].winSize.width, [CCDirector sharedDirector].winSize.height);
    float midCamera = camPos.x + screenWidth/2.f;
    float halfwayAroundTheWorld = worldWidth/2.f;
    float pieceDistanceFromMiddle = piecePos.x - midCamera;


    float shadowPositionA = midCamera - pieceDistanceFromMiddle/BACKGROUND_SCALE_FACTOR + halfwayAroundTheWorld/BACKGROUND_SCALE_FACTOR;
    float shadowPositionB = midCamera - pieceDistanceFromMiddle/BACKGROUND_SCALE_FACTOR - halfwayAroundTheWorld/BACKGROUND_SCALE_FACTOR;
    
    
    
    float realShadowPosition;
    
    if(fabs(shadowPositionA - midCamera) > fabs(shadowPositionB - midCamera)) {
        realShadowPosition = shadowPositionB;
    } else {
        realShadowPosition = shadowPositionA;
    }

    return ccp(realShadowPosition, piecePos.y/BACKGROUND_SCALE_FACTOR+PLAYER_BACKGROUND_HEIGHT);
    
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
