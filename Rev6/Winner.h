//
//  Settings.h
//  Rev5
//
//  Created by Dave Durazzani on 3/18/10.
//  Copyright 2010 Connect Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseMenu.h"

@interface Winner : BaseMenu {
}

-(void)homeScreen:(id)sender;
-(void)setGameTime:(float)gt;
-(void)setGameMode;

@end
