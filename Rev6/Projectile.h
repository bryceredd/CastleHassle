//
//  Projectile.h
//  Rev3
//
//  Created by Bryce Redd on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "PlayerArea.h"
#import "cocos2d.h"
#import "Box2D.h"

@interface Projectile : Piece {
	int bounces;
	int baseDamage;
	BOOL isBack;
	b2Vec2 savedVelocity;
	BOOL shouldLoadVelocity;
}

@property(nonatomic) BOOL shouldLoadVelocity;
@property(nonatomic) int bounces;
@property(nonatomic) int baseDamage;
@property(nonatomic, retain) CCParticleSystem* trail;

-(id) initWithCoords:(CGPoint)p world:(b2World *)w from:(PlayerArea*)s;
-(void) updateSpritePosition:(b2Vec2)pos body:(b2Body *)b;
-(void) setIsBack:(BOOL)b;
+(float) getMass;

@end
