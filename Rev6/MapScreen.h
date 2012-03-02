//
//  MapScreen.h
//  Rev5
//
//  Created by Dave Durazzani on 5/6/10.
//  Copyright 2010 Reel Connect LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseMenu.h"
#import "cocos2d.h"

#define ccpPrint(__POINT__) NSLog(@"%s : (%f, %f)", #__POINT__, __POINT__.x, __POINT__.y); 

@interface MapScreen : BaseMenu {
	CGPoint initialTouch;
    
	float initialDistance;
	float diff;
	float lastDist;
	float zoom;
	
	CCSprite* left;
	CCSprite* right;
    
    CCLabelTTF* victoryBlack;
    CCLabelTTF* victoryWhite;
}

@property(nonatomic, retain) NSMutableArray* statusGrid;
@property(nonatomic, retain) NSMutableDictionary* mapDictionary;
@property(nonatomic, retain) NSMutableDictionary* territories;
@property(nonatomic, retain) NSString *mapPlistPath;
@property(nonatomic, assign) CGRect zoomBox;
@property(nonatomic, retain) CCTexture2D* bases;
@property(nonatomic, retain) CCTexture2D* castles;
@property(nonatomic, retain) CCTexture2D* flags;


-(CGPoint) transformTouchToPoint:(UITouch *)touch withCameraOffset:(BOOL)cam;

-(void) updateZoomBox;


+(NSMutableDictionary*) conqueredDictionary;
+(void) saveConqueredTerritory:(int)territoryID;
+(void) resetConqueredDictionary;

-(void)createTerritories;

@end
