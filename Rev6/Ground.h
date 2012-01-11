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

@class Layer;

@interface Ground : Tileable {
	Layer *layer;
}

@property(nonatomic, retain) Layer *layer;

- (id)initWithGroundHeight:(int)height 
					 width:(int)width
					 world:(b2World*)w 
					 layer:(Layer*)parent;

- (id)initWithGroundHeight:(int)height 
					 world:(b2World*)w 
				 leftImage:(NSString *)lImg 
				rightImage:(NSString *)rImg 
			imageDimension:(CGPoint)dim
					 layer:(Layer*)parent;

@end
