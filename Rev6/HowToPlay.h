//
//  HowToPlay.h
//  Rev5
//
//  Created by xCode on 4/2/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseMenu.h"


@interface HowToPlay : BaseMenu {

}

+(HowToPlay *)instance;

-(void)previousScreen:(id)sender;
-(void)screen2Call:(id)sender;

@end
