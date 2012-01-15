//
//  Tileable.h
//  Rev3
//
//  Created by Bryce Redd on 1/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"

@interface Tileable : Piece {
	float parallaxFactor;

}

@property (nonatomic) float parallaxFactor;
@property (nonatomic, retain) CCSprite* imageA;
@property (nonatomic, retain) CCSprite* imageB;

- (int) cameraOutOfBounds:(CGPoint)pos;
- (void) positionForCameraLoc:(CGPoint)loc;
- (void) repositionSprite:(CGPoint)pos result:(int)res;

@end