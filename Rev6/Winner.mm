//
//  Settings.m
//  Rev5
//
//  Created by Dave Durazzani on 3/18/10.
//  Copyright 2010 Connect Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Winner.h"
#import "MainScene.h"
#import "MainMenu.h"
#import "PlayerData.h"
#import "MapScreen.h"
#import "BackButtonLayer.h"
#import "GameSettings.h"

@interface Winner()
-(void)setTitle;
@end

@implementation Winner

-(id) init {
	
	if((self=[super init])){
        
        CCSprite* bg = sprite(@"background.jpg");
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
    
		CCSprite* navBack = sprite(@"menuBack.png");
        [navBack setPosition:ccp(240, 160)];
		[self addChild:navBack z:0];	
		
		[self setTitle];
		
		CCLabelTTF* gt = [CCLabelTTF labelWithString:@"Game Time:" fontName:@"Arial-BoldMT" fontSize:24];
		[gt setAnchorPoint:ccp(0,.5)];
		[gt setColor:ccc3(15, 147, 222)];
		gt.position = ccp(40,150);
		[self addChild:gt];
		
		CCLabelTTF* mode = [CCLabelTTF labelWithString:@"Mode:" fontName:@"Arial-BoldMT" fontSize:24];
		[mode setAnchorPoint:ccp(0,.5)];
		[mode setColor:ccc3(15, 147, 222)];
		mode.position = ccp(40,110);
		[self addChild:mode];
		
		[self setGameMode];
		
		[self makeButtonWithString:@"Return" atPosition:ccp(-150,-120) withSelector:@selector(homeScreen:)];
        
        [[MainMenu instance] removeChildByTag:MAIN_MENU_LAYER cleanup:YES];
			
	}

	return self;
	
}

-(void)setTitle {
	CCLabelTTF* title = [CCLabelTTF labelWithString:@"Winner!" fontName:@"Arial-BoldMT" fontSize:64];
	[title setColor:ccc3(15, 147, 222)];
	title.position = ccp(240,265);
	[self addChild:title];
}

-(void)setGameTime:(float)gt {
    int gameTime = (int)gt;
    
	int min = gameTime/60;
	int sec = gameTime%60;
    
	CCLabelTTF* l = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%02i:%02i", min, sec] fontName:@"Arial-BoldMT" fontSize:24];
	[l setAnchorPoint:ccp(0,.5)];
	[l setColor:ccc3(15, 147, 222)];
	l.position = ccp(250,150);
	[self addChild:l];
}

-(void)setGameMode {
	
	gametype g = [GameSettings instance].type;

	NSString* gtype = @"Campaign";
	
	if(g == easy)
		gtype = @"AI - Easy";
	if(g == medium)
		gtype = @"AI - Medium";
	if(g == hard)
		gtype = @"AI - Hard";
        
    if([[GameSettings instance] isCampaign]) {
        gtype = @"Royal Campaign";
    }
	
	CCLabelTTF* gt = [CCLabelTTF labelWithString:gtype fontName:@"Arial-BoldMT" fontSize:24];
	[gt setColor:ccc3(15, 147, 222)];
	[gt setAnchorPoint:ccp(0,.5)];
	gt.position = ccp(250,110);
	[self addChild:gt];
}

-(void)homeScreen:(id)sender {
	
	MainMenu * main = [MainMenu instance];
	[main removeChild:self cleanup:YES];
	
    if([[GameSettings instance] isCampaign]) {
        CCSprite* blackBg = sprite(@"blackWall.png");
        [blackBg setPosition:ccp(240, 160)];
        [main addChild:blackBg z:1];
        [main addChild:[MapScreen node] z:2];
        [main addChild:[BackButtonLayer node] z:3];
    } else {
        [main addChild:[MainMenuLayer node]];
    }
}


-(void) dealloc {
	[super dealloc];
}

@end

