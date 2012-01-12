//
//  CannonBall.h
//  Rev3
//
//  Created by Bryce Redd on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Projectile.h"
#import "cocos2d.h"
#import "Box2D.h"

@interface CannonBall : Projectile {

}

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p level:(int)l shooter:(PlayerArea*)s;
@end
