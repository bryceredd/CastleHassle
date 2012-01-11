//
//  AI.h
//  Rev5
//
//  Created by Bryce Redd on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlayerArea, Weapon;

@interface AI : NSObject {
	PlayerArea* playerArea;
	BOOL anyCannon;
	BOOL anyCatapult;
	BOOL cannonPicked;
	UIImageView * animationArea;
}

+(id)aiWithPlayer:(PlayerArea*)p;
-(id)initWithPlayer:(PlayerArea*)p;
-(void)readyToFire:(Weapon*)w;
-(void)randomizeShot:(float*)f by:(int)variation;

+(float)getCatapultForce;


@end
