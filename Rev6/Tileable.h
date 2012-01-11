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
	CCSprite* leftImage;
	CCSprite* rightImage;
	float parallaxFactor;

}

@property (nonatomic) float parallaxFactor;
@property (nonatomic, retain) CCSprite* leftImage;
@property (nonatomic, retain) CCSprite* rightImage;

- (int) cameraOutOfBounds:(CGPoint)pos;
- (void) positionForCameraLoc:(CGPoint)loc;
- (void) repositionSprite:(CGPoint)pos result:(int)res;

@end