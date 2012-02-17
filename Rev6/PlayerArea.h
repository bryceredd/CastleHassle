//
//  PlayerArea.h
//  Rev3
//
//  Created by Bryce Redd on 1/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "SimpleAudioEngine.h"
#import "City.h"

@class AI;

@interface PlayerArea : Piece {
	int uniquePieceID;
	int gold;
	float left;
	float overallHealth;
	float timeTillLoss;
	BOOL hasWeapon;
	BOOL destroyed;
}

@property(nonatomic) float left;
@property(nonatomic) int gold;
@property(nonatomic) float overallHealth;

@property(nonatomic) BOOL hasWeapon;
@property(nonatomic) float timeTillLoss;
@property(nonatomic) BOOL destroyed;
@property(nonatomic, retain) NSMutableArray* pieces;
@property(nonatomic, retain) AI* ai;
@property(nonatomic, retain) City* city;

-(id) initWithLeft:(float)left dimentions:(CGPoint)dim world:(b2World *)w;
-(void) makeCityWithColor:(ccColor3B)color;
-(void) addPiece:(Piece *)piece;
-(void) removePiece:(Piece *)piece;
-(void) moveToLeft:(float)l;
-(void) updateOverallHealth;
-(int) giveMoney;
-(void) addMoney:(int)g;
-(void) removeMoney:(int)g;
-(BOOL) canAfford:(int)g;
-(int) getUniquePieceID;
-(Piece*) getPiece:(int)pieceid;
-(BOOL) hasWeapon;
-(void)destroyPlayer;
-(NSArray*) getPieceDescriptions;


@end
