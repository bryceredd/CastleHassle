//
//  SinglePlayer.h
//  Rev5
//
//  Created by Bryce Redd on 3/14/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMenu.h"

@class CHToggle;

@interface SinglePlayer : BaseMenu {
	CCSprite* comboSprite;
	NSMutableArray* toggles;
	
	CHToggle* environment;
	CHToggle* opponents;
	CHToggle* difficulties;
}

+(SinglePlayer *) instance;

-(void)startGame: (id)sender;
-(void)previousScreen:(id)sender;

@end
