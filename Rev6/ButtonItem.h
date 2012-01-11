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
	Label * buttonText;
}

@property(nonatomic) SEL func;
@property(nonatomic, retain)Label* buttonText;

-(void) postInitWithText:(NSString *)text;
-(void) hide;
-(void) show;
@end
