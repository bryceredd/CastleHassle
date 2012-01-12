//
//  Wedge.h
//  Rev5
//
//  Created by Bryce Redd on 1/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"




@interface Wedge : Piece {

}

-(b2Vec2) snapToPosition:(b2Vec2)pos;

@end
