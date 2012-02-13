//
//  StaticUtils.m
//  Rev3
//
//  Created by Bryce Redd on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StaticUtils.h"
#import "cocos2d.h"
#import "Battlefield.h"
#import "Piece.h"
#import "Arch.h"
#import "City.h"

class RayCastCallback : public b2RayCastCallback
{
public:
	RayCastCallback()
	{
		m_fixture = NULL;
	}
	
	float32 ReportFixture(  b2Fixture* fixture, const b2Vec2& point,
						  const b2Vec2& normal, float32 fraction)
	{
		m_fixture = fixture;
		m_point = point;
		m_normal = normal;
		m_fraction = fraction;
		
		return fraction;
	}
	
	b2Fixture* m_fixture;
	b2Vec2 m_point;
	b2Vec2 m_normal;
	float m_fraction;
};

@implementation StaticUtils

+(void) snapVerticallyToClasses:(NSArray*)classes
					  withPoint:(b2Vec2*)p 
					  fromPiece:(Piece *)originalpiece
						  world:(b2World *)w {
	
	// convert point to cocos2d coords
	b2Vec2 objLoc = b2Vec2(p->x, p->y+SNAPPING_Y_ADDITION);
	b2Vec2 snappingVec = b2Vec2(p->x, p->y-SNAPPING_DISTANCE);
	RayCastCallback callback;
	
	w->RayCast(&callback, objLoc, snappingVec);
	
	if (callback.m_fixture) {
		Piece * piece = (Piece *)callback.m_fixture->GetBody()->GetUserData();
		
		for (Class c in classes) {
			if([piece isKindOfClass:c]) {
				
				// if it's the ground we dont want to set the x value
				if ([piece isKindOfClass:[Arch class]]) {
					// get in pixels
					int x = originalpiece.body->GetPosition().x * PTM_RATIO;
					
					p->x = ((float)(x + 15 - (x % 30)))/PTM_RATIO;	
					
				} else if ([piece isKindOfClass:[City class]]) {
					
					int basePieceX = callback.m_fixture->GetBody()->GetPosition().x * PTM_RATIO;
					int originalPieceX = originalpiece.body->GetPosition().x * PTM_RATIO;
					
					if(originalPieceX < basePieceX-150) originalPieceX = basePieceX-150;
					if(originalPieceX > basePieceX+140) originalPieceX = basePieceX+140;
					
					p->x = ((float)(originalPieceX + 15 - (originalPieceX % 30)))/PTM_RATIO;	
					
				} else {
					p->x = callback.m_fixture->GetBody()->GetPosition().x;			
				}
				
				// get the height for the right piece type
				p->y = callback.m_fixture->GetBody()->GetPosition().y + 
						piece.currentSprite.textureRect.size.height/(2*PTM_RATIO) +
						originalpiece.currentSprite.textureRect.size.height/(2*PTM_RATIO);
				
				originalpiece.snappedTo = piece;
				return;
			}
		}
	}
	
	originalpiece.snappedTo = nil;
}

+(void) snapVerticallyAndHorizontallyToClasses:(NSArray*)classes
									 withPoint:(b2Vec2*)p 
									 fromPiece:(Piece *)originalpiece
										 world:(b2World *)w {
	
	// shoot vertical ray
	b2Vec2 objLoc = b2Vec2(p->x, p->y);
	b2Vec2 snappingVecDown = b2Vec2(p->x, p->y-SNAPPING_DISTANCE);
	RayCastCallback callbackDown;
	
	// setup the two horizontal rays
	b2Vec2 snappingVecLeft = b2Vec2(p->x-SNAPPING_DISTANCE, p->y);
	b2Vec2 snappingVecRight = b2Vec2(p->x+SNAPPING_DISTANCE, p->y);
	RayCastCallback callbackLeft;
	RayCastCallback callbackRight;
	
	w->RayCast(&callbackDown, objLoc, snappingVecDown);
	w->RayCast(&callbackLeft, objLoc, snappingVecLeft);
	w->RayCast(&callbackRight, objLoc, snappingVecRight);
	
	float down = (callbackDown.m_fixture ? callbackDown.m_fraction : 2.0);
	float left = (callbackLeft.m_fixture ? callbackLeft.m_fraction : 2.0);
	float right = (callbackRight.m_fixture ? callbackRight.m_fraction : 2.0);

	if(down < left && down < right) {
		[StaticUtils snapVerticallyToClasses:classes withPoint:p fromPiece:originalpiece world:w];
	}
	
	if((left < right && left < down ) || (right < left && right < down)) {
		[StaticUtils snapHorizontallyToClasses:classes withPoint:p fromPiece:originalpiece world:w];
	}
}

+(void) snapHorizontallyToClasses:(NSArray*)classes
						withPoint:(b2Vec2*)p 
						fromPiece:(Piece *)originalpiece
							world:(b2World *)w {
	
	// setup the two rays
	b2Vec2 objLoc = b2Vec2(p->x, p->y);
	b2Vec2 snappingVecLeft = b2Vec2(p->x-SNAPPING_DISTANCE, p->y);
	b2Vec2 snappingVecRight = b2Vec2(p->x+SNAPPING_DISTANCE, p->y);
	RayCastCallback callbackLeft;
	RayCastCallback callbackRight;
	
	w->RayCast(&callbackLeft, objLoc, snappingVecLeft);
	w->RayCast(&callbackRight, objLoc, snappingVecRight);
	
	if (callbackLeft.m_fixture && (!callbackRight.m_fixture || callbackLeft.m_fraction < callbackRight.m_fraction)) {
		Piece * piece = (Piece *)callbackLeft.m_fixture->GetBody()->GetUserData();
		
		for (Class c in classes) {
			if([piece isKindOfClass:c]) {
				
				p->x = callbackLeft.m_fixture->GetBody()->GetPosition().x + 
						piece.currentSprite.textureRect.size.width/(2*PTM_RATIO) + 
						originalpiece.currentSprite.textureRect.size.width/(2*PTM_RATIO);
				
				// get the custom height for the right piece type
				p->y = callbackLeft.m_fixture->GetBody()->GetPosition().y;
				
				originalpiece.snappedTo = piece;
				[originalpiece setIsFacingLeft:YES];
				
				return;
			}
		}
	}
		
	if (callbackRight.m_fixture && (!callbackLeft.m_fixture || callbackRight.m_fraction < callbackLeft.m_fraction)) {
		Piece * piece = (Piece *)callbackRight.m_fixture->GetBody()->GetUserData();
		
		for (Class c in classes) {
			if([piece isKindOfClass:c]) {
				
				p->x = callbackRight.m_fixture->GetBody()->GetPosition().x - 
						piece.currentSprite.textureRect.size.width/(2*PTM_RATIO) - 
						originalpiece.currentSprite.textureRect.size.width/(2*PTM_RATIO);			
				
				// get the custom height for the right piece type
				p->y = callbackRight.m_fixture->GetBody()->GetPosition().y;
				
				originalpiece.snappedTo = piece;
				[originalpiece setIsFacingLeft:NO];
				
				return;
			}
		}
		
	}
		
	originalpiece.snappedTo = nil;
}


+(void) snapBetweenTwoClasses:(NSArray*)classes
				    withPoint:(b2Vec2*)p 
				    fromPiece:(Arch *)originalpiece
					    world:(b2World *)w {
	
	// setup the two rays
	b2Vec2 objLoc = b2Vec2(p->x, p->y);
	b2Vec2 snappingVecLeft = b2Vec2(p->x-SNAPPING_DISTANCE, p->y);
	b2Vec2 snappingVecRight = b2Vec2(p->x+SNAPPING_DISTANCE, p->y);
	RayCastCallback callbackLeft;
	RayCastCallback callbackRight;
	
	w->RayCast(&callbackLeft, objLoc, snappingVecLeft);
	w->RayCast(&callbackRight, objLoc, snappingVecRight);
	
	if (callbackLeft.m_fixture && callbackRight.m_fixture) {
		
		// check if the distances are about right
		float expectedGapSize = originalpiece.currentSprite.textureRect.size.width/PTM_RATIO;
		float currentGapSize = callbackLeft.m_fraction*SNAPPING_DISTANCE + callbackRight.m_fraction*SNAPPING_DISTANCE;
		
		NSLog(@"Fitting between %f and %f", callbackLeft.m_fixture->GetBody()->GetPosition().x, callbackRight.m_fixture->GetBody()->GetPosition().x);
		
		if(fabs(currentGapSize - expectedGapSize) > ARCHWAY_ERROR_MARGIN) return;
		
		Piece * leftPiece = (Piece *)callbackLeft.m_fixture->GetBody()->GetUserData();
		Piece * rightPiece = (Piece *)callbackRight.m_fixture->GetBody()->GetUserData();
		
		for (Class c in classes) {
			if([leftPiece isKindOfClass:c]) {
				for (Class c in classes) {
					if([rightPiece isKindOfClass:c]) {
						
						// get the custom height for the right piece type
						p->y = (callbackLeft.m_fixture->GetBody()->GetPosition().y + callbackRight.m_fixture->GetBody()->GetPosition().y) / 2.0;
						
						// put the x between the two values
						p->x = (callbackLeft.m_fixture->GetBody()->GetPosition().x + callbackRight.m_fixture->GetBody()->GetPosition().x) / 2.0;
						
						originalpiece.snappedTo = leftPiece;
						originalpiece.rightSnappedTo = rightPiece;
						
						return;
					}
				}
			}
		}
	}
	originalpiece.snappedTo = nil;
}


@end


