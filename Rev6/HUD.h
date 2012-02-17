//
//  HUD.h
//  Rev3
//
//  Created by Bryce Redd on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#define BACK_BUTTON_SPACING_FROM_RIGHT 40

@class Battlefield, HUDMenu, Piece, HUDSelectedMenu, GoldItem, SettingsFromGame;

@interface HUD : CCLayer {
	float extremeRight;
	
	GoldItem *gold;
	CCLabelTTF *splashMsg;
	int lastSecond;

	BOOL menuIsHidden;
}

@property(nonatomic, retain) SettingsFromGame *settingsView;
@property(nonatomic, retain) HUDSelectedMenu *selectedMenu;
@property(nonatomic, retain) CCLabelTTF *countDownTimer;
@property(nonatomic, retain) CCLabelTTF *moneyLabel;
@property(nonatomic, retain) HUDMenu *mainMenu;
@property(nonatomic, retain) HUDMenu *buildMenu;
@property(nonatomic, retain) HUDMenu *buildNextMenu;
@property(nonatomic, retain) HUDMenu *inFocus;

@property(nonatomic, retain) CCSprite *tabUpSprite;
@property(nonatomic, retain) CCSprite *tabSprite;
@property(nonatomic, retain) CCSprite *tabDownSprite;


-(void) initMainMenu;
-(void) initBuildMenu;
-(void) initSelectedMenu:(Piece*)p;
-(void) initBuildNextMenu;
-(void) addBackButtonToMenu:(HUDMenu*)menu;
-(void) setCountdownTimer:(float)timeRemaining;

-(void) showBuildNextMenu;
-(void) showBuildMenu;
-(void) showMainMenu;
-(void) showSelectedMenu:(Piece *)piece;
-(void) showMenu:(HUDMenu*)menu;
-(void) showMessage:(NSString *)message;
-(void) showPaycheck:(int)amount;
-(void) removePaycheck;
-(void) showSettings;
-(void) hideSettings;
-(void) hideMenu;

-(void) removeMessage;

-(void) moveAllObjects:(CGPoint)p;
-(BOOL) handleInitialTouch:(CGPoint)p;
-(BOOL) handleTouchDrag:(CGPoint)p;
-(BOOL) handleDragExit:(CGPoint)p;
-(BOOL) handleEndTouch:(CGPoint)p;

-(CGRect) hudRect;
-(CGRect) tabRect;

@end