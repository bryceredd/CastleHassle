//
//  Arch.h
//  Rev5
//
//  Created by Bryce Redd on 1/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Piece.h"



@interface Arch : Piece {
	Piece * rightSnappedTo;
}

@property(nonatomic, retain) Piece * rightSnappedTo;

-(b2Vec2) snapToPosition:(b2Vec2)pos;

@end