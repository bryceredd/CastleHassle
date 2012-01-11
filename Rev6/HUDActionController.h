//
//  HUDActionController.h
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HUD;

@interface HUDActionController : NSObject {
	HUD *hud;
}

@property(nonatomic, retain)HUD *hud;

+(HUDActionController *) instance;

-(void) showBuildMenu;
-(void) showMainMenu;
-(void) previousConstructionItems;
-(void) nextConstructionItems;
-(void) upgradePiece;
-(void) repairPiece;
-(void) showSettings;
-(void) hideSettings;
-(void) clear;

@end
