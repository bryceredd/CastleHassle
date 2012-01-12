//
//  HUDItem.h
//  Rev3
//
//  Created by Bryce Redd on 11/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "HUDItem.h"
#import "PlayerArea.h"

@class AtlasSprite;

@interface GoldItem : HUDItem {
	CCLabelTTF* amount;
    BOOL isObserving;
}

@property(nonatomic, retain) PlayerArea* observedArea;

-(void) updateGold;

@property(nonatomic, retain) CCLabelTTF* amount;

@end