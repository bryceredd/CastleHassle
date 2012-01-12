//
//  Ground.h
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Tileable.h"


@interface Ground : Tileable {
	CCLayer *layer;
}

@property(nonatomic, retain) CCLayer *layer;

- (id)initWithGroundHeight:(int)height 
					 width:(int)width
					 world:(b2World*)w 
					 layer:(CCLayer*)parent;

- (id)initWithGroundHeight:(int)height 
					 world:(b2World*)w 
				 leftImage:(NSString *)lImg 
				rightImage:(NSString *)rImg 
			imageDimension:(CGPoint)dim
					 layer:(CCLayer*)parent;

@end
