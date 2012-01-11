//
//  CHToggleItem.h
//  Rev5
//
//  Created by Bryce Redd on 3/14/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@class AtlasSprite, MenuItem, CHToggle;

@interface CHToggleItem : CCLayer {
	CHToggle* parent;
	CGRect selectedRect;
	CGRect unselectedRect;
	CCSprite* img;
	CCMenuItemFont* item;
	int yOffset;
}

@property(nonatomic)int yOffset;
@property(nonatomic, retain)CCSprite* img;
@property(nonatomic, retain)CCMenuItemFont* item;

-(id) initWithParent:(CHToggle*)p selectedRect:(CGRect)sel deselectedRect:(CGRect)desel buttonText:(NSString*)str;
-(void) setPosition:(CGPoint)p;
-(void) responder:(id)sender;
-(void) setSelected:(BOOL)b;

@end
