//
//  Body.h
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "SimpleAudioEngine.h"

@class Projectile, PlayerArea;


@interface Piece : NSObject {
	int hp;
	int maxHp;
	b2Body *body;
	b2World *world;
	BOOL acceptsTouches;
	BOOL acceptsDamage;
	BOOL shouldDestroy;
	BOOL hasBeenPlaced;
	BOOL isChanged;
	BOOL acceptsPlayerColoring;
	int repairPrice;
	int buyPrice;
	int pieceID;
	BOOL isFacingLeft;
}

-(id) initWithWorld:(b2World*)w coords:(CGPoint)p;
-(void) setupSpritesWithRect:(CGRect)rect image:(NSString*)image atPoint:(CGPoint)p;
-(void) updateView;
-(int) zIndex;
-(int) zFarIndex;
-(bool) containsPoint:(b2Vec2)p;
-(void) targetWasHit:(b2Contact*)contact by:(Projectile*)p;
-(void) onTouchBegan:(CGPoint)touch;
-(void) onTouchMoved:(CGPoint)touch;
-(BOOL) onTouchEnded:(CGPoint)touch;
-(int) getCurrentRepairPrice;
-(void) repairPiece;
-(void) repairPieceLocal;
-(void) finalizePiece;
-(void) actionDone;
-(void) finalizePieceBase;
-(b2Vec2) snapToPosition:(b2Vec2)pos;
-(void) addSnappingJoints;
-(NSDictionary*) getPieceData;
-(void) restoreToState:(NSDictionary*)state;
-(void) destroyJoints;
-(void) unselect;
-(BOOL) touchIsInsideOtherBody:(CGPoint)point;

@property(nonatomic) b2Body *body;
@property(nonatomic) b2World *world;

@property(nonatomic) int hp;
@property(nonatomic) int maxHp;
@property(nonatomic) int repairPrice;
@property(nonatomic) int buyPrice;
@property(nonatomic) int pieceID;
@property(nonatomic) BOOL acceptsTouches;
@property(nonatomic) BOOL acceptsDamage;
@property(nonatomic) BOOL shouldDestroy;
@property(nonatomic) BOOL shouldDestroyReally; 
@property(nonatomic) BOOL hasBeenPlaced;
@property(nonatomic) BOOL isChanged;
@property(nonatomic) BOOL acceptsPlayerColoring;
@property(nonatomic) BOOL isFacingLeft;

@property(nonatomic, retain) CCSprite *currentSprite;
@property(nonatomic, retain) CCSprite *backSprite;
@property(nonatomic, retain) CCLabelTTF* animationLabel;

@property(nonatomic, assign) NSString *spriteName;
@property(nonatomic, assign) Piece *snappedTo;
@property(nonatomic, assign) PlayerArea *owner;


@end
