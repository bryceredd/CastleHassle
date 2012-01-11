//
//  Tower.h
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"


@interface City : Piece {
	CCSprite* colorSprite;
	CCSprite* colorSpriteBack;
}

@property(nonatomic, retain) CCSprite* colorSpriteBack;
@property(nonatomic, retain) CCSprite* colorSprite;

- (id) initWithCoords:(CGPoint)p owner:(PlayerArea*)o colorVal:(ccColor3B)color;
- (void) updateSprites;

@end
