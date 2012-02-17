//
//  ButtonItem.h
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ButtonItem.h"

@class Piece;

typedef enum itemType {
	repair = 0,
	upgrade = 1
} ButtonType;

@interface PurchaseItem : ButtonItem {
	Piece* selectedPiece; 
	CCSprite* coin;
	ButtonType type;
    BOOL isObservingSelected;
}

@property(nonatomic, retain) Piece * selectedPiece;
@property(nonatomic, retain) CCLabelTTF* price;

-(id) initWithPiece:(Piece*)p;
-(void) updatePrice;

@end
