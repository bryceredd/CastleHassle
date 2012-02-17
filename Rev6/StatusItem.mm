//
//  BuildItem.m
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StatusItem.h"
#import "Battlefield.h"
#import "Piece.h"
#import "Weapon.h"
#import "GameSettings.h"

@implementation StatusItem

@synthesize selectedPiece;

-(void) postInitWithPiece:(Piece*)p {
	self.selectedPiece = p;
	
	[selectedPiece addObserver:self 
					forKeyPath:@"isChanged" 
					   options:NSKeyValueObservingOptionNew
					   context:nil];
	

	
	healthBarContainer = spriteWithRect(@"healthBars.png", CGRectMake(14, 30, 65, 9));
	healthBar = spriteWithRect(@"healthBars.png", CGRectMake(15, 23, 62, 6)); 
	
	[[Battlefield instance] addChild:healthBarContainer z:HUD_Z_INDEX];
	[[Battlefield instance] addChild:healthBar z:HUD_Z_INDEX];
	
	if(p.acceptsPlayerColoring) {
		img.color = [[GameSettings instance] getColorForPlayer:p.owner];
		swingImg.color = [[GameSettings instance] getColorForPlayer:p.owner];
	}
	
	fullHealthSize = healthBar.textureRect.size.width;
	
	[self setBarPositions];
}

-(BOOL) handleInitialTouch:(CGPoint)p {
	return YES;
}

-(BOOL) handleDragExit:(CGPoint)p {
	return YES;
}

-(void) move:(CGPoint)p {
	[super move:p];
	
    swingImg.position = CGPointMake(swingImg.position.x - p.x, swingImg.position.y);
	
	fullHealthCenter = img.position.x;
	zeroHPPosition = img.position.x - fullHealthSize/2.0;
	
	
	
	[self setBarPositions];
	
}

-(void) hideWithAnimation:(BOOL)animation {
	[super hideWithAnimation:animation];
    
    if(animation) {
        [healthBar runAction:[CCFadeOut actionWithDuration:.25]];
        [healthBarContainer runAction:[CCFadeOut actionWithDuration:.25]];
        [swingImg runAction:[CCFadeOut actionWithDuration:.25]];
    } else {
        healthBar.visible = NO;
        healthBarContainer.visible = NO;
        swingImg.visible = NO;
    }
}

-(void) show {
	[super show];
	
	img.position = ccpAdd(img.position, ccp(0.0, 5.0));
	
    [healthBar runAction:[CCFadeIn actionWithDuration:.25]];
    [healthBarContainer runAction:[CCFadeIn actionWithDuration:.25]];
    
	[self setBarPositions];
	[self updateHPBar];
	
    [swingImg runAction:[CCFadeIn actionWithDuration:.25]];
    swingImg.position = ccp(img.position.x, 320-(HUD_HEIGHT/2)+7);
}

-(void) setBarPositions {
	healthBarContainer.position = ccp(img.position.x, 320-(HUD_HEIGHT/2)-20);
	healthBar.position = ccp(img.position.x, 320-(HUD_HEIGHT/2)-20);
	fullHealthCenter = img.position.x;
	zeroHPPosition = img.position.x - fullHealthSize/2.0;
	
	[self updateHPBar];
	
}

-(void) updateHPBar {
	float health = (float)selectedPiece.hp / (float)selectedPiece.maxHp;

	// move health bar
	healthBar.textureRect = CGRectMake(healthBar.textureRect.origin.x, 
									   healthBar.textureRect.origin.y, 
									   fullHealthSize*health,
									   healthBar.textureRect.size.height);


	healthBar.position = ccp(zeroHPPosition+(health*fullHealthSize/2), healthBar.position.y);
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	img.textureRect = selectedPiece.currentSprite.textureRect;

	if([selectedPiece isKindOfClass:[Weapon class]]) {
		Weapon* w = (Weapon*)selectedPiece;
		swingImg.textureRect = w.swingSprite.textureRect;
	}
	
	[self updateHPBar];
}

-(void) dealloc {
	[selectedPiece removeObserver:self forKeyPath:@"isChanged"];
    self.selectedPiece = nil;
	[super dealloc];
}
	

@end
