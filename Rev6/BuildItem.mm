//
//  BuildItem.m
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BuildItem.h"
#import "Battlefield.h"
#import "PlayerAreaManager.h"
#import "PlayerArea.h"
#import "Catapult.h"
#import "Cannon.h"
#import "Weapon.h"
#import "Top.h"
#import "HUD.h"
#import "GameSettings.h"

@implementation BuildItem

@synthesize creationClass, price;

-(id) initWithPrice:(int)p {
	if((self = [super init])) {

        coin = spriteWithRect(@"coins.png", CGRectMake(0, 21, 14, 14));		
		goldPrice = p;
		self.price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", p] fontName:@"Arial" fontSize:14.0];
		price.color = ccc3(65, 65, 65);
		
		[[Battlefield instance] addChild:price z:PIECE_Z_INDEX];
		[[Battlefield instance] addChild:coin z:HUD_Z_INDEX];
		
	}
	
	return self;
}

-(void) postInit {
	img.position = ccpAdd(img.position, ccp(0,5));	
    
    if(creationClass == [Weapon class] || creationClass == [Cannon class] || creationClass == [Top class]) {
        img.color = [[GameSettings instance] getColorForCurrentPlayer];
        swingImg.color = [[GameSettings instance] getColorForCurrentPlayer];
    }
}

-(void) setCreationClass:(Class)c {
	creationClass = c;
	
	if(creationClass == [Weapon class] || creationClass == [Cannon class] || creationClass == [Top class]) {
		img.color = [[GameSettings instance] getColorForCurrentPlayer];
        swingImg.color = [[GameSettings instance] getColorForCurrentPlayer];
	}	
}

-(BOOL) handleInitialTouch:(CGPoint)p {
	
	PlayerArea* player = [[Battlefield instance].playerAreaManager getCurrentPlayerArea];
	
	if(![player canAfford:goldPrice]) {
		[[Battlefield instance].hud showMessage:@"Not enough gold"];
	}
	
	return YES;
}

-(BOOL) handleDragExit:(CGPoint)p {
	
	// check moneys
	PlayerArea* player = [[Battlefield instance].playerAreaManager getCurrentPlayerArea];
	
	if(![player canAfford:goldPrice]) {
		return NO;
	}
    
	
	// create the new block set in the selector
	Class c = creationClass;
	NSString* s = [NSString stringWithFormat:@"%@.png", [NSStringFromClass(creationClass) lowercaseString]];
	BOOL f = NO;
	
	NSMethodSignature* sig = [Battlefield instanceMethodSignatureForSelector:@selector(addNewPieceWithCoords:andClass:withImageName:finalize:player:)];
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    
	[invocation setSelector: @selector(addNewPieceWithCoords:andClass:withImageName:finalize:player:)];
	[invocation setTarget:[Battlefield instance]];
	[invocation setArgument:&p atIndex:2];
	[invocation setArgument:&c atIndex:3];
	[invocation setArgument:&s atIndex:4];
	[invocation setArgument:&f atIndex:5];
	[invocation setArgument:&player atIndex:6];
	
	[invocation invoke];
	[[Battlefield instance].lastCreated setOwner:player];
	
	[Battlefield instance].selected = [Battlefield instance].lastCreated;
	
	return YES;
}

-(void) move:(CGPoint)p {
	[super move:p];
	price.position = ccpAdd(img.position, ccp(10.0, -25.0));
	coin.position = ccpAdd(img.position, ccp(-10.0, -25.0));
	
	if(swingImg != nil) {
		if (creationClass == [Catapult class]) {
			swingImg.position = ccpAdd(img.position, ccp(0.0, 2.0));
			coin.position = ccpAdd(coin.position, ccp(0.0, 4.0));
			price.position = ccpAdd(price.position, ccp(0.0, 4.0));
		}
		
		if (creationClass == [Cannon class]) {
			swingImg.position = ccpAdd(img.position, ccp(0.0, 10.0));
			coin.position = ccpAdd(coin.position, ccp(0.0, 10.0));
			price.position = ccpAdd(price.position, ccp(0.0, 10.0));
		}
	}
}

-(void) hideWithAnimation:(BOOL)animation {
	[super hideWithAnimation:animation];
    
    if(animation) {
        [coin runAction:[CCFadeOut actionWithDuration:.25]];
        [price runAction:[CCFadeOut actionWithDuration:.25]];
        [swingImg runAction:[CCFadeOut actionWithDuration:.25]];
    } else {
        coin.visible = NO;
        price.visible = NO;
        swingImg.visible = NO;
    }
}

-(void) show {
	[super show];
	
    [coin runAction:[CCFadeIn actionWithDuration:.25]];
    [price runAction:[CCFadeIn actionWithDuration:.25]];
    [swingImg runAction:[CCFadeIn actionWithDuration:.25]];
	
	[self move:ccp(0,0)];
}

- (void) dealloc {
    [price release];
    
    [super dealloc];
}

@end
