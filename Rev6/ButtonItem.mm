//
//  ButtonItem.m
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ButtonItem.h"
#import "Battlefield.h"
#import "HUDActionController.h"

@implementation ButtonItem

@synthesize func, buttonText;


-(void) postInitWithText:(NSString *)text {
	self.buttonText = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:20.0];
	[buttonText setPosition:CGPointMake(img.position.x, img.position.y)];
	[[Battlefield instance] addChild:buttonText z:HUD_Z_INDEX+1];
}

-(BOOL) handleInitialTouch:(CGPoint)p {
	[[HUDActionController instance] performSelector:func];
	return YES;
}

-(BOOL) handleDragExit:(CGPoint)p {
	return YES;
}

-(void) move:(CGPoint)p {
	[super move:p];
	buttonText.position = CGPointMake(buttonText.position.x - p.x, buttonText.position.y);
}

- (void) hideWithAnimation:(BOOL)animation {
    [super hideWithAnimation:animation];
    
    if(animation) {
        [buttonText runAction:[CCFadeOut actionWithDuration:.25]];
    } else {    
        buttonText.visible = NO;
    }
}

-(void) show {
	[super show];

	[buttonText runAction:[CCFadeIn actionWithDuration:.25]];
    
	buttonText.position = img.position;
}

- (void) dealloc {
    [buttonText release];
    
    [super dealloc];
}

@end
