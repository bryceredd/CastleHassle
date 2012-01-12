//
//  Wedge.h
//  Rev5
//
//  Created by Bryce Redd on 1/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"

@interface Top : Piece {

}

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p;

@end
