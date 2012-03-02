//
//  Settings.m
//  Rev5
//
//  Created by Dave Durazzani on 3/18/10.
//  Copyright 2010 Connect Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
#import "MainScene.h"
#import "CHToggle.h"
#import "CHToggleItem.h"
#import "MainMenu.h"
#import "PListReader.h"
#import "PlayerData.h"
#import "GameSettings.h"
#import "MapScreen.h"

NSString* settingsFile = @"settings.plist";

@implementation Settings

-(id) init {
	
	if((self = [super init])){
    
        CCSprite* bg = sprite(@"background.jpg");
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
    
		CCSprite* navBack = sprite(@"menuBack.png");
        [navBack setPosition:ccp(240, 160)];
		[self addChild:navBack z:0];	
        
		
		CCLabelTTF* title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Arial-BoldMT" fontSize:24];
		[title setColor:ccc3(15, 147, 222)];
		title.position = ccp(240,280);
		[self addChild:title];
				
		CCLabelTTF* soundLabel = [CCLabelTTF labelWithString:@"Sound" fontName:@"Arial-BoldMT" fontSize:18];
        [soundLabel setAnchorPoint:ccp(0,.5)];
		[soundLabel setColor:ccc3(15, 147, 222)];
		soundLabel.position = ccp(50,202);
		[self addChild:soundLabel];
		
		//Sound On/Off Graphics		
		soundState = [[CHToggle alloc] initWithImageName:@"comboButtons.png"];

		CHToggleItem *on = [[CHToggleItem alloc] initWithParent:soundState
												   selectedRect:CGRectMake(0,122,94,36) 
												 deselectedRect:CGRectMake(0,159,94,36) 
													 buttonText:@"         On        "];

		[on setYOffset:5];
		[soundState addItem:on];
		[on release];
		
		CHToggleItem *off = [[CHToggleItem alloc] initWithParent:soundState
													selectedRect:CGRectMake(187,122,94,36) 
												  deselectedRect:CGRectMake(187,159,94,36) 
													  buttonText:@"        Off        "];
		
		[off setYOffset:5];
		[soundState addItem:off];
		[off release];
		
		
		[soundState setPosition:ccp(70,40)];
		[self addChild:soundState z:3];
		
		[soundState selectItemAtIndex:([GameSettings instance].hasSound?0:1)];	


		[self makeButtonWithString:NSLocalizedString(@"Save",@"Return button from Settings.mm") 
						atPosition:ccp(-150,-120) 
					  withSelector:@selector(previousScreen:)];
		
        [self makeButtonWithString:@"Reset Campaign" atPosition:ccp(150, -120) withSelector:@selector(resetCampaign)];
        
        [self setupFollowShot];
	
	}
	return self;
}

- (void) resetCampaign {
    [MapScreen resetConqueredDictionary];
}

-(void) setupFollowShot {
	followShot = [[CHToggle alloc] initWithImageName:@"comboButtons.png"];
	
	CHToggleItem* on = [[CHToggleItem alloc] initWithParent:followShot 
											   selectedRect:CGRectMake(0, 121, 94, 36) 
											 deselectedRect:CGRectMake(0, 157, 94, 36) 
												 buttonText:@"        On"];
	[followShot addItem:on];
	[on setYOffset:5];
	[on release];
	
	CHToggleItem* off = [[CHToggleItem alloc] initWithParent:followShot 
												selectedRect:CGRectMake(186, 121, 94, 36)
											  deselectedRect:CGRectMake(186, 157, 94, 36) 
												  buttonText:@"        Off"];
	[followShot addItem:off];
	[off setYOffset:5];
	[off release];
	[followShot setAnchorPoint:ccp(0,0)];
	[followShot setPosition:ccp(70,-20)];
	[self addChild:followShot z:3];
	
	
	CCLabelTTF* followShotLabel = [CCLabelTTF labelWithString:@"Follow shot" fontName:@"Arial-BoldMT" fontSize:18];
	[followShotLabel setColor:ccc3(15, 147, 222)];
	[followShotLabel setAnchorPoint:ccp(0,.5)];
	[followShotLabel setPosition:ccp(50,142)];
	[followShot selectItemAtIndex:[GameSettings instance].followShot?0:1];
	
	[self addChild:followShotLabel];
}

-(BOOL)saveSettings:(id)sender {
    [GameSettings instance].followShot = followShot.selectedIndex == 0;
    [GameSettings instance].hasSound = soundState.selectedIndex == 0;
    
    NSMutableDictionary* settings = [Settings settingsPlistDict];
	[settings setObject:[NSNumber numberWithInt:followShot.selectedIndex == 0? 1:0] forKey:@"FollowStateKey"];
    [settings setObject:[NSNumber numberWithInt:soundState.selectedIndex==0? 1:0] forKey:@"SoundStateKey"];
	[Settings saveSettings:settings];
	
	return YES;
}

-(void)previousScreen:(id)sender {
	
	if(![self saveSettings:self]) { return; }
	
	MainMenu * main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[MainMenuLayer node]];
}



+(NSMutableDictionary*) settingsPlistDict {

	if([Settings settingsFileExists]) {
		return [[[NSMutableDictionary alloc] initWithContentsOfFile:[Settings settingsFile]] autorelease];
	} else {
		NSMutableDictionary* settingsPlistDict = [[[NSMutableDictionary alloc] init] autorelease];
		[settingsPlistDict setObject:[NSNumber numberWithInt:0] forKey:@"hasMultiplayer"];
		return settingsPlistDict;
	}
}

+(void) saveSettings:(NSDictionary*)settings {
	[settings writeToFile:[Settings settingsFile] atomically:NO];
}

+(id) settingsFile {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:settingsFile];
}

+(BOOL) settingsFileExists {
	return [[NSFileManager defaultManager] fileExistsAtPath:[self settingsFile] isDirectory:nil];
}



-(void)dealloc {
    [soundState release];
	[super dealloc];
}

@end