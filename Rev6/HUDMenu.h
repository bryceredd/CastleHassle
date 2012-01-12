//
//  HUDMenu.h
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "Box2D.h"

@class HUDItem, ButtonItem, BuildItem, StatusItem, GoldItem, PurchaseItem, Piece;

@interface HUDMenu : NSObject {
	float extremeRight;
	BOOL hasBack;
}

@property(nonatomic, retain) HUDItem *selected;
@property(nonatomic, retain) NSMutableArray* items;

-(HUDItem *) getHUDItem:(CGPoint)p;
-(void) moveAllObjects:(CGPoint)p;
-(GoldItem *) addGoldStatusWithLeft:(float)l;

-(StatusItem *) addStatusItemWithImageName:(NSString *)image imageBox:(CGRect)box swingImageBox:(CGRect)swingBox piece:(Piece*)p;
-(BuildItem *) addBuildItemWithImageName:(NSString *)imageName imageBox:(CGRect)box swingImageBox:(CGRect)swingBox class:(Class)c price:(int)p;
-(ButtonItem *) addButtonItemWithImageName:(NSString *)imageName imageBox:(CGRect)box swingImageBox:(CGRect)swingBox selector:(SEL)s title:(NSString*)t;
-(PurchaseItem *) addPurchaseItemWithImageName:(NSString *)imageName imageBox:(CGRect)box swingImageBox:(CGRect)swingBox selector:(SEL)s title:(NSString*)t piece:(Piece*)p;
-(void) addItemWithImageName:(NSString *)imageName imageBox:(CGRect)box swingImageBox:(CGRect)swingBox hudItem:(HUDItem*)item expandToStatusSize:(BOOL)expand;
-(void) setSwingItemWithImage:(NSString*)imageName swingBox:(CGRect)swingBox imageBox:(CGRect)box forItem:(HUDItem*)item forClass:(Class)c;

-(void) hideAll;
-(void) showAll;

-(BOOL) handleInitialTouch:(CGPoint)p;
-(BOOL) handleTouchDrag:(CGPoint)p;
-(BOOL) handleDragExit:(CGPoint)p;
-(BOOL) handleEndTouch:(CGPoint)p;
-(CGRect) hudRect;
@end
