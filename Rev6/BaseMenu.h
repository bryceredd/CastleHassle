//
//  BaseMenuy.h
//  Rev5
//
//  Created by Bryce Redd on 3/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h" 

@interface BaseMenu : CCLayer {
}

-(CCMenuItemSprite*)makeButtonWithString:(NSString*)s atPosition:(CGPoint)p withSelector:(SEL)selector;
-(CCMenuItemSprite*)makeButtonFromRect:(CGRect)rect atPosition:(CGPoint)p withSelector:(SEL)selector;
-(void)toggled:(id)sender;

@end
