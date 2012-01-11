//
//  SettingsFromGame.h
//  Rev5
//
//  Created by xCode on 3/31/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseMenu.h"

@class CHToggle;

@interface SettingsFromGame : BaseMenu {
	CCSprite* navBack;
	CCMenuItemFont* leaveGame;
	CHToggle* followShot;
	CHToggle* soundState;
}

-(void) closeWindow:(id)sender;
-(void) leaveGame:(id)sender;
-(void) setupFollowShot;
-(void) setupSound;

@end
