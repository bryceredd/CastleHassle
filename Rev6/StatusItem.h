//
//  BuildItem.h
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUDItem.h"

@class Piece;

@interface StatusItem : HUDItem {
	Piece* selectedPiece; 
	CCSprite* healthBarContainer;
	CCSprite* healthBar;
	float fullHealthSize, fullHealthCenter, zeroHPPosition;
}

@property(nonatomic, retain) Piece * selectedPiece;

-(void) updateHPBar;
-(void) postInitWithPiece:(Piece*)p;
-(void) setBarPositions;
@end
