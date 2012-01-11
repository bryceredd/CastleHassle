//
//  Tower.h
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"


@interface Turret : Piece {
	
}

-(id) initWithManager:(AtlasSpriteManager*)spritemgr 
		  backManager:(AtlasSpriteManager*)backmanager
				world:(b2World*)w
			   coords:(CGPoint)p;
@end
