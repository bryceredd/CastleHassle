//
//  CannonBallTrail.h
//  Rev5
//
//  Created by Bryce Redd on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CatapultBallTrail : CCParticleSmoke {

}

-(id) initWithTotalParticles:(int)p color:(ccColor3B)color;

@end
