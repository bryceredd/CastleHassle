//
//  StaticUtils.h
//  Rev3
//
//  Created by Bryce Redd on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#define MAX_ROTATION 20
#define SNAPPING_DISTANCE 10.0
#define SNAPPING_Y_ADDITION 3.0
#define ARCHWAY_ERROR_MARGIN 0.225

@class Battlefield, Piece, Arch;

@interface StaticUtils : NSObject {}

+(void) snapVerticallyToClasses:(NSArray*)classes
					  withPoint:(b2Vec2*)p 
					  fromPiece:(Piece *)piece
						  world:(b2World *)w;
	
+(void) snapHorizontallyToClasses:(NSArray*)classes
						withPoint:(b2Vec2*)p 
						fromPiece:(Piece *)originalpiece
							world:(b2World *)w;

+(void) snapBetweenTwoClasses:(NSArray*)classes
				   withPoint:(b2Vec2*)p 
				   fromPiece:(Arch *)originalpiece
					   world:(b2World *)w;

+(void) snapVerticallyAndHorizontallyToClasses:(NSArray*)classes
									 withPoint:(b2Vec2*)p 
									 fromPiece:(Piece *)originalpiece
										 world:(b2World *)w;
@end
