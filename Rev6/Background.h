//
//  Ground.h
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "Tileable.h"

@interface Background : Tileable 

- (id)initWithLeftImage:(NSString *)lImg 
			 rightImage:(NSString *)rImg
		 imageDimension:(CGPoint)dim
				  layer:(CCLayer*)parent 
				  index:(int)index 
		 parallaxFactor:(float)pf;
@end
