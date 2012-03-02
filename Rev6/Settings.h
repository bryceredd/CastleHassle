//
//  Settings.h
//  Rev5
//
//  Created by Dave Durazzani on 3/18/10.
//  Copyright 2010 Connect Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseMenu.h"

@class CHToggle;

@interface Settings : BaseMenu <UITextFieldDelegate> {
	CCSprite *comboSprite;
	NSMutableArray* toggles;
	CHToggle *soundState;
    CHToggle* followShot;
}

+(id) settingsFile;
+(BOOL) settingsFileExists;
+(NSMutableDictionary*) settingsPlistDict;
+(void) saveSettings:(NSDictionary*)settings;

-(BOOL)saveSettings:(id)sender;
-(void)previousScreen:(id)sender;
-(void) setupFollowShot;
-(void) resetCampaign;

@end
