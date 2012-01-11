//
//  MainMenu.h
//  Rev5
//
//  Created by Bryce Redd on 3/13/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseMenu.h"
#import "SimpleAudioEngine.h"
#define MAIN_MENU_LAYER 101

@interface MainMenu : CCScene {

	
}

@property(nonatomic,retain) CCSprite* bg;

+(MainMenu *) instance;
+(void) resetInstance;

@end


@interface MainMenuLayer : BaseMenu { 
		CCSprite* bg;
}

-(void)singlePlayer: (id)sender;
-(void)settings: (id)sender;
-(void)howToPlay: (id)sender;	
-(void)campaign: (id)sender;

@end