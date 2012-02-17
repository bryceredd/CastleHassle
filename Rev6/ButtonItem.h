//
//  ButtonItem.h
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HUDItem.h"

@interface ButtonItem : HUDItem {
	SEL func;
	CCLabelTTF * buttonText;
}

@property(nonatomic) SEL func;
@property(nonatomic, retain) CCLabelTTF* buttonText;

-(void) postInitWithText:(NSString *)text;
@end
