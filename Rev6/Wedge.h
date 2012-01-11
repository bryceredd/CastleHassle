//
//  Wedge.h
//  Rev5
//
//  Created by Bryce Redd on 1/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"




@interface Wedge : Piece {

}

-(id) initWithManager:(AtlasSpriteManager*)spritemgr 
		  backManager:(AtlasSpriteManager*)backmanager
				world:(b2World*)w
			   coords:(CGPoint)p;

-(b2Vec2) snapToPosition:(b2Vec2)pos;

@end
