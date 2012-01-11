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

NSString* settingsFile = @"settings.plist";

@implementation Settings
@synthesize nameField;
@synthesize settingsPlistDict;
@synthesize theSoundStateValue;

-(id) init {
	
	if((self=[super init])){
		CCSprite* navBack = sprite(@"menuBack.png");
        [navBack setPosition:ccp(240, 160)];
		[self addChild:navBack z:0];	
		
		CCLabelTTF* title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Arial-BoldMT" fontSize:24];
		[title setColor:ccc3(15, 147, 222)];
		title.position = ccp(240,280);
		[self addChild:title];
		
		CCLabelTTF* screenNameLabel = [CCLabelTTF labelWithString:@"Screen Name" fontName:@"Arial-BoldMT" fontSize:18];
		[screenNameLabel setColor:ccc3(15, 147, 222)];
		[screenNameLabel setAnchorPoint:ccp(0,0)];
		screenNameLabel.position = ccp(20,228);
		[self addChild:screenNameLabel];
		
		CCLabelTTF* soundLabel = [CCLabelTTF labelWithString:@"Sound" fontName:@"Arial-BoldMT" fontSize:18];
		[soundLabel setColor:ccc3(15, 147, 222)];
		[screenNameLabel setAnchorPoint:ccp(0,0)];
		soundLabel.position = ccp(50,172);
		[self addChild:soundLabel];
		
		//Sound On/Off Graphics		
		soundState = [[CHToggle alloc] initWithImage:@"comboButtons.png"];
				
		CHToggleItem *on = [[CHToggleItem alloc] initWithParent:soundState
												   selectedRect:CGRectMake(0,122,94,33) 
												 deselectedRect:CGRectMake(0,159,94,33) 
													 buttonText:@"         On        "];
		
		[on setYOffset:5];
		[soundState addItem:on];
		[on release];
		
		CHToggleItem *off = [[CHToggleItem alloc] initWithParent:soundState
													selectedRect:CGRectMake(187,122,94,33) 
												  deselectedRect:CGRectMake(187,159,94,33) 
													  buttonText:@"        Off        "];
		
		[off setYOffset:5];
		[soundState addItem:off];
		[off release];
		
		
		[soundState setPosition:ccp(70,10)];
		[self addChild:soundState z:3];
		
		[soundState selectItemAtIndex:([GameSettings instance].hasSound?0:1)];	

		
		// add the two buttons
		/*[self makeButtonWithString:NSLocalizedString(@"Save",@"Save button from Settings.mm")
						atPosition:ccp(150,-115) 
					  withSelector:@selector(saveSettings:)];*/

		[self makeButtonWithString:NSLocalizedString(@"Return",@"Return button from Settings.mm") 
						atPosition:ccp(-150,-120) 
					  withSelector:@selector(previousScreen:)];
		
		//UITextField stuff
		NSDictionary* props = [PListReader getAppPlist];
		NSString* name = (NSString *)[props objectForKey:@"name"];	


		nameField = [[UITextField alloc] init];
		nameField.backgroundColor = [UIColor whiteColor];
		nameField.borderStyle = UITextBorderStyleRoundedRect;
		nameField.bounds = CGRectMake(0,0,240.0,32.0);
		[nameField setFont:[UIFont systemFontOfSize:22]];

		if([name length] > 0) 
			nameField.text = name;
		else {
			nameField.placeholder = NSLocalizedString( @"Screen Name",@"Screen Name UITextView place hoder from Settings.mm");
		}

		[nameField setTextColor:[UIColor blackColor]];
		[nameField setBackgroundColor:[UIColor colorWithRed:72.2 green:80.8 blue:85.1 alpha:0]];
		[nameField setReturnKeyType:UIReturnKeyDone];
		[nameField setKeyboardType:UIKeyboardTypeNamePhonePad];

		nameField.transform = CGAffineTransformTranslate(nameField.transform, 230, 333);// (x,y)
		nameField.transform = CGAffineTransformRotate(nameField.transform, CC_DEGREES_TO_RADIANS(90));

		[nameField setDelegate:self];
		
		//this puts the UITextField nameField on screen
		[[[CCDirector sharedDirector] openGLView] addSubview:nameField]; 
		
		// use this if you want keyboard to come up when settings screen is loaded
		//[nameField becomeFirstResponder];
		
		self.theSoundStateValue = [NSNumber numberWithInt:0];
	
	}
	return self;
}

+(id) settingsFile {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	NSLog(@"Settings.m: %@", [documentsDirectory stringByAppendingPathComponent:settingsFile]);
	return [documentsDirectory stringByAppendingPathComponent:settingsFile];
}

+(BOOL) settingsFileExists {
	return [[NSFileManager defaultManager] fileExistsAtPath:[self settingsFile] isDirectory:nil];
}

-(NSMutableDictionary*) settingsPlistDict {
	if(settingsPlistDict) { return settingsPlistDict; }
	
	return settingsPlistDict = [Settings settingsPlistDict];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	//dismiss keyboard
    [nameField resignFirstResponder];
    return YES;
}

-(BOOL)saveSettings:(id)sender {
	
	if (nameField.text.length == 0) {
		UIAlertView * screenNameNotValidAlert = [[UIAlertView alloc] initWithTitle:@"No Screen Name Entered"
																		   message:nil
																		  delegate:self
																 cancelButtonTitle:@"Dismiss"
																 otherButtonTitles:nil];
		[screenNameNotValidAlert show];
		[screenNameNotValidAlert release];
		return NO;
	}
	
	[PlayerData instance].name = nameField.text;
	
	//Add screenName and soundState to settginsPlistDict Dictionary
	[self.settingsPlistDict setValue:nameField.text forKey:@"name"];
	[self.settingsPlistDict setObject:theSoundStateValue forKey:@"SoundStateKey"];

	//wite to file
	[Settings saveSettings:self.settingsPlistDict];
	
	return YES;
}

-(void)previousScreen:(id)sender {
	
	if(![self saveSettings:self]) { return; }
	
	[nameField removeFromSuperview];// dismiss the text field when we exit from settings
	MainMenu * main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	[main addChild:[MainMenuLayer node]];

}

-(void)toggled:(id)sender {
	[GameSettings instance].hasSound = soundState.selectedIndex==0;
}

-(void)dealloc {
		self.settingsPlistDict = nil;
		[nameField release];
		[soundState release];
	[super dealloc];
}

@end