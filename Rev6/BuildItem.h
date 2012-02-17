//
//  BuildItem.h
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HUDItem.h"

@interface BuildItem : HUDItem {
	Class creationClass; 
	CCSprite* coin;
	int goldPrice;
}

@property(nonatomic, assign) Class creationClass;
@property(nonatomic, retain) CCLabelTTF* price;

-(id) initWithPrice:(int)p;
-(void) postInit;
@end
