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
	UITextField* nameField;
	NSMutableDictionary* settingsPlistDict;
	NSNumber* theSoundStateValue;
	CHToggle *soundState;

}

@property(nonatomic, retain) NSNumber * theSoundStateValue;
@property(nonatomic, retain) UITextField *nameField;
@property(nonatomic, retain) NSMutableDictionary *settingsPlistDict;

+(id) settingsFile;
+(BOOL) settingsFileExists;
+(NSMutableDictionary*) settingsPlistDict;
+(void) saveSettings:(NSDictionary*)settings;

-(BOOL)saveSettings:(id)sender;
-(void)previousScreen:(id)sender;

@end
