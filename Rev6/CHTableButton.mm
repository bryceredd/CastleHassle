//
//  TableButton.m
//  Rev5
//
//  Created by Bryce Redd on 3/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CHTableButton.h"
#import "CHTable.h"
#import "GameData.h"

@implementation CHTableButton

@synthesize table, item, gameDatum;

+(id) tableButtonWithTextureRect:(CGRect)rect gameData:(GameData*)data table:(CHTable*)t{
	return [[[self alloc] initWithTextureRect:rect gameData:data table:(CHTable*)t] autorelease];
}

-(id) initWithTextureRect:(CGRect)rect gameData:(GameData*)data table:(CHTable*)t{

	gameDatum = data;
	table = t;
	gameName = [CCLabelTTF labelWithString:data.name fontName:@"arial" fontSize:18];
	players = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d/%d", data.currentGamePlayers, data.maxGamePlayers] fontName:@"arial" fontSize:18];
	manager = sprite(@"selected.png");
	
	[gameName setAnchorPoint:ccp(0,0)];
	[players setAnchorPoint:ccp(0,0)];
	
	button = spriteWithRect(@"selected.png", rect);
	selectedButton = spriteWithRect(@"selected.png", rect);
	[selectedButton setOpacity:150];
	
	[self addChild:button z:6];
	[self addChild:selectedButton z:6];
	
	//button.position = ccp(240.0,160.0);
	//selectedButton.position = ccp(240.0,160.0);
	
	item = [CCMenuItemSprite itemFromNormalSprite:button selectedSprite:selectedButton target:self selector:@selector(selectedGame:)];
	menu = [CCMenu menuWithItems:item, nil];
	
	[item setContentSize:rect.size];
	[self setSelected:NO];
	
	[table addChild:menu];
	[table addChild:gameName z:7];
	[table addChild:players z:7];

	return self;
}

-(void) setPosition:(CGPoint)p {
	item.position = p;
	item.selectedImage.position = item.disabledImage.position = item.normalImage.position = ccpAdd(ccp(240.0,160.0), p);
	gameName.position = ccpAdd(ccp(30.0,150.0), p);
	players.position = ccpAdd(ccp(400.0,150.0), p);
}

-(void) selectedGame:(id)sender {
	if(table)
		[table toggled:self];
}


-(void) setSelected:(BOOL)b {
	
	if(b) {
		[item.normalImage setOpacity:255];
	} else {
		[item.normalImage setOpacity:100];
	}
	
}


-(void) dealloc {
	[gameDatum release];
	[manager removeChild:selectedButton cleanup:YES];
	[manager removeChild:button cleanup:YES];
	[table removeChild:menu cleanup:YES];
	[table removeChild:gameName cleanup:YES];
	[table removeChild:players cleanup:YES];
	
	[super dealloc];
}


@end
