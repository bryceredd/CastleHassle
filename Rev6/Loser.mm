//
//  Settings.m
//  Rev5
//
//  Created by Dave Durazzani on 3/18/10.
//  Copyright 2010 Connect Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loser.h"
#import "MainScene.h"
#import "MainMenu.h"

@implementation Loser

-(void)setTitle {
	CCLabelTTF* title = [CCLabelTTF labelWithString:@"Defeat!" fontName:@"Arial-BoldMT" fontSize:64];
	[title setColor:ccc3(15, 147, 222)];
	title.position = ccp(240,265);
	[self addChild:title];
}

@end

