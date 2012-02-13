//
//  PlayerAreaManager.h
//  Rev3
//
//  Created by Bryce Redd on 1/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ground.h"
#import "SimpleAudioEngine.h"


@interface PlayerAreaManager : NSObject {

	NSMutableArray *playerAreas;
	PlayerArea * extremeLeft;
	PlayerArea * extremeRight;
	
	float worldWidth;
	float backgroundWidth;
}


@property(nonatomic, retain) PlayerArea *extremeLeft;
@property(nonatomic, retain) PlayerArea *extremeRight;
@property(nonatomic, retain) NSMutableArray *playerAreas;


-(id)initWithPlayerAreaWorld:(b2World*)world;

-(void) checkAndMovePlayerAreas:(CGPoint)cameraLoc;
-(void) addPiece:(Piece *)p forPlayer:(PlayerArea*)pa;
-(void) removePiece:(Piece *)p forPlayer:(PlayerArea*)pa;
-(CGPoint) getBackImagePosFromObjPos:(CGPoint)piecePos cameraPosition:(CGPoint)camPos;
-(BOOL) touchPos:(CGPoint)pos inPlayerArea:(int)player;	
-(int) getCurrentPlayerAreaID;
-(PlayerArea*) getCurrentPlayerArea;
-(PlayerArea*) getPlayerArea:(int)index;
-(int) getPlayerID:(PlayerArea*)pa;
-(void) loadAI;
-(void) loadPlayer;

@end
