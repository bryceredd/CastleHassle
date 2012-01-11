//
//  HUDSelectedMenu.h
//  Rev5
//
//  Created by Bryce Redd on 3/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HUDMenu.h"
#import "Piece.h"

@interface HUDSelectedMenu : HUDMenu {
}

-(void) clearItems;
-(StatusItem*) getSelectedItem;
-(Piece*) getSelectedPiece;

@end
