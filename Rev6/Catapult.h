//
//  Tower.h
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weapon.h"
#import "SimpleAudioEngine.h"

#define CATAPULT_SHOT_RANDOMNESS 15

@interface Catapult : Weapon {
		//Sprite *shootIndicator;
}

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p;
-(void)moveObject:(CGPoint)touch;
-(BOOL)shootFromAICatapult:(float)F isLeft:(BOOL)left;

@end
