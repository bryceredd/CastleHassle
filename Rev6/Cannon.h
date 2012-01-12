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



@interface Cannon : Weapon 

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p;
-(void) moveObject:(CGPoint)touch;
-(BOOL) shootFromAICannon:(CGPoint)touch;


@end
