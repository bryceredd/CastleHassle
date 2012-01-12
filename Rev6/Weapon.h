//
//  Weapon.h
//  Rev3
//
//  Created by Bryce Redd on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "cocos2d.h"
#import "Box2D.h"


@interface Weapon : Piece {
	float offset;
	CGPoint initialTouch;
	float currentShotAngle;
	float shotPower;
	float cooldown;
	float maxCooldown;
	int weaponLevel;
	int upgradePrice;
}


@property(nonatomic) CGPoint initialTouch;
@property(nonatomic) int upgradePrice;
@property(nonatomic) int weaponLevel;
@property(nonatomic) float offset;
@property(nonatomic) float shotPower;
@property(nonatomic) float currentShotAngle;
@property(nonatomic) float cooldown;
@property(nonatomic, readonly) float maxCooldown;

@property(nonatomic, retain) CCSprite *swingSprite;
@property(nonatomic, retain) CCSprite *backSwingSprite;
@property(nonatomic, retain) CCSprite *shootIndicatorTail;
@property(nonatomic, retain) CCSprite *shootIndicatorTop;
@property(nonatomic, retain) CCSprite *cdSprite;

-(void) setupSwingSpritesWithRect:(CGRect)rect image:(NSString*)image atPoint:(CGPoint)p;
-(void) updateSpritesAngle:(float)ang position:(b2Vec2)pos time:(float)t;
-(void) onTouchMoved:(CGPoint)touch;
-(BOOL) onTouchEndedLocal:(CGPoint)touch;
-(void) moveObject:(CGPoint)touch;
-(void) upgradeLevel;
-(void) upgradeLevelLocal;
-(int) getUpgradePrice;
-(void) fired:(Projectile*)p;
-(BOOL) isUsable;
-(void) fired:(Projectile*)p follow:(BOOL)follow;

@end
