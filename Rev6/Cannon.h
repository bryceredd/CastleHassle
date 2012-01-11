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

-(void) moveObject:(CGPoint)touch;

-(BOOL)shootFromAICannon:(CGPoint)touch;

-(id) initWithManager:(AtlasSpriteManager*)spritemgr  
			backManager:(AtlasSpriteManager*)backmanager
	 projectileManager:(AtlasSpriteManager*)projmgr
backProjectileManager:(AtlasSpriteManager *)backprojmgr
				world:(b2World*)w
			   coords:(CGPoint)p;

@end
