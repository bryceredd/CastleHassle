//
//  HUDActionController.m
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HUDActionController.h"
#import "HUD.h"
#import "HUDSelectedMenu.h"
#import "StatusItem.h"
#import "Piece.h"
#import "Weapon.h"
#import "Battlefield.h"
#import "PlayerArea.h"
#import "PlayerAreaManager.h"
#import "PoofRepairAnimation.h"
#import "SimpleAudioEngine.h"
#import "SettingsFromGame.h"


@implementation HUDActionController

@synthesize hud;

static HUDActionController* instance = nil;

+(HUDActionController *) instance {
	if(instance == nil) {
		instance = [HUDActionController alloc];
		[instance init];
	}
	
	return instance;
}

-(id) init {
	if( (self=[super init]) ) {
		
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"repair.caf"];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"upgrade.caf"];
		
	}
	return self;
}

-(void) showBuildMenu {
	if(hud != nil)
		[hud showBuildMenu];
}

-(void) showMainMenu {
	if(hud != nil)
		[hud showMainMenu];
}

-(void) save {
    [[Battlefield instance] save];
}

-(void) showSettings {
	[hud showSettings];
}

-(void) hideSettings {
	[hud hideSettings];
}

-(void) previousConstructionItems {
	[hud showBuildMenu];
}

-(void) nextConstructionItems {
	[hud showBuildNextMenu];
}

-(void) upgradePiece {
	Piece* p = [hud.selectedMenu getSelectedItem].selectedPiece;
	
	if(!p || ![p isKindOfClass:[Weapon class]] || !p.owner) {
		
		NSLog(@"HUDActionController.mm : piece not weapon, or has no owner!");
		return;
	}
	
	Weapon* w = (Weapon*)p;
	
	[w upgradeLevel];	
}

-(void) repairPiece {
	
	Piece* p = [hud.selectedMenu getSelectedItem].selectedPiece;
		
	if(!p || !p.owner) {
		NSLog(@"HUDActionController.mm : piece not found!");
		return;
	}
		
	[p repairPiece];
	
}

-(void) clear {
    PlayerArea* myArea = [[Battlefield instance].playerAreaManager getCurrentPlayerArea];
    [myArea destroyPlayer];
    [myArea setDestroyed:NO];
}

-(void) infoClicked {
	NSLog(@"Info requested");
}


@end
