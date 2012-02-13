//
//  Territory.h
//  Rev5
//
//  Created by Dave Durazzani on 5/6/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapScreen.h"
#import "GameSettings.h"

typedef enum castleType {
	small,
	mediumC,
	large
} castleType;

@interface Territory : CCLayer {
	NSMutableArray* neighbors;
	NSNumber* territoryID;
	
    tileset tileset;
    castleType type;
    
	CGPoint baseOffset;
	CGPoint castleOffset;
    CGPoint flagPosition;
    CGPoint borderPosition;	
	
	BOOL conqured;
	BOOL hasBase;
    BOOL castleRotation;
	BOOL tapped;
	BOOL conquerable;
}

@property (nonatomic, assign) BOOL conqured; 
@property (nonatomic, assign) BOOL hasBase;
@property (nonatomic, assign) BOOL castleRotation;
@property (nonatomic, assign) BOOL conquerable;
@property (nonatomic, assign) BOOL tapped;
@property (nonatomic, retain) NSMutableArray* neighbors;
@property (nonatomic, retain) NSNumber* territoryID;
@property (nonatomic, assign) castleType type; 
@property (nonatomic, assign) tileset tileset; 
@property (nonatomic, retain) CCSprite* overlayImage;
@property (nonatomic, retain) CCSprite* borderImage;
@property (nonatomic, retain) CCSprite* flag;
@property (nonatomic, retain) CCSprite* castle;
@property (nonatomic, retain) CCSprite* castleBase;
@property (nonatomic, assign) MapScreen* mapScreen;


-(id)  initWithID:(int)tid 
	 flagPosition:(CGPoint)fPosition
		  hasBase:(BOOL)base
	   baseOffset:(CGPoint)bOffset
	 castleOffset:(CGPoint)cOffSet
   castleRotation:(BOOL)r
	   castleType:(castleType)cst 
territoryPosition:(CGPoint)territoryPosition
          tileset:(tileset)tileset
        mapScreen:(MapScreen*)mapScreen;

-(void) territoryTapped;

@end
