//
//  HUDItem.m
//  Rev3
//
//  Created by Bryce Redd on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GoldItem.h"
#import "Battlefield.h"
#import "PlayerArea.h"
#import "PlayerAreaManager.h"

@implementation GoldItem

@synthesize amount, observedArea;

-(id) init {
	if( (self=[super init])) {
		self.amount = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%03d", 0] fontName:@"Arial" fontSize:24.0];
		amount.color = ccc3(65, 65, 65);
		[[Battlefield instance] addChild:amount z:PIECE_Z_INDEX];
	}
	
	[self updateGold];
	
	return self;
}

-(void) postInit{
	self.observedArea = [[Battlefield instance].playerAreaManager getCurrentPlayerArea];
	[self.observedArea addObserver:self 
					forKeyPath:@"gold" 
					   options:NSKeyValueObservingOptionNew
					   context:nil];
                       
    isObserving = YES;
}

-(void) move:(CGPoint)p {
	[super move:p];
	amount.position = ccpAdd(img.position, ccp(38.0, -1.0));
}

-(void) hideWithAnimation:(BOOL)animation {
	[super hideWithAnimation:animation];
	
    if(animation) 
        [amount runAction:[CCFadeOut actionWithDuration:.25]];
    else
        [amount setVisible:NO];
}

-(void) show {
	[super show];
	[self move:ccp(0.0,0.0)];
	
	[amount runAction:[CCFadeIn actionWithDuration:.25]];
}

-(void) updateGold {
	PlayerArea *currentPlayer = [[Battlefield instance].playerAreaManager getCurrentPlayerArea];
	[amount setString:[NSString stringWithFormat:@"%03d", currentPlayer.gold]];	
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self updateGold];
}

- (void) dealloc {

    if(isObserving)    
        [self.observedArea removeObserver:self forKeyPath:@"gold"];

    [observedArea release];
    [amount release];
    
    [super dealloc];
}

@end
