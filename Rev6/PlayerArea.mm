//
//  PlayerArea.m
//  Rev3
//
//  Created by Bryce Redd on 1/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerArea.h"
#import "Weapon.h"
#import "AI.h"
#import "HUD.h"
#import "City.h"
#import "Battlefield.h"
#import "Projectile.h"
#import "GameSettings.h"

@implementation PlayerArea

@synthesize left, gold, overallHealth, ai, hasWeapon, timeTillLoss, destroyed, pieces, city;

-(id) initWithLeft:(float)l 
		dimentions:(CGPoint)dim 
			 world:(b2World *)w {
	
	if( (self=[super init])) {
		self.ai = nil;
		world = w;
		left = l;
		acceptsTouches = YES;
		acceptsDamage = NO;
		overallHealth = 1.0;
		uniquePieceID = 0;
		
        
        
		gold = [[GameSettings instance] startingGold];
		timeTillLoss = TIME_TO_LOSS_WITHOUT_WEAPON;
		destroyed = NO;
		hasWeapon = NO;
		
		// set position in the  world
		b2BodyDef bodydef;
		bodydef.position.Set(left/PTM_RATIO,dim.y/PTM_RATIO);
		body = w->CreateBody(&bodydef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
		
		// bottom wall
		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(dim.x/PTM_RATIO,0));
		body->CreateFixture(&groundBox, 0);
		body->SetUserData(self);
	
		self.pieces = [NSMutableArray array];
		
	}

	return self;
}

-(void) makeCityWithColor:(ccColor3B)color {
	self.city = [[[City alloc] initWithCoords:ccp(left+(PLAYER_GROUND_WIDTH/2.0), PLAYER_GROUND_HEIGHT) owner:self colorVal:color] autorelease];
	
    [self addPiece:city];
}

-(Piece*) getPiece:(int)pieceid {
	for (Piece* p in pieces) {
		if(p.pieceID == pieceid) { return p; }
	}
	
	NSLog(@"Searched for piece %d, found nothing", pieceid);
	return nil;
}

-(void) destroyPlayer{
	
	for (Piece* p in pieces) {
		if(![p isKindOfClass:[City class]]) { p.shouldDestroy = YES; }
	}
	
	destroyed = YES;
}

-(int) getUniquePieceID {
	return ++uniquePieceID;
}

-(void) moveToLeft:(float)l {
	float delta = l - left;
	
	// move the ground
	b2Vec2 pos = b2Vec2(body->GetPosition().x+delta/PTM_RATIO, body->GetPosition().y);
	body->SetTransform(pos, body->GetAngle());
	
	// move each piece
	for(Piece * p in pieces) {
		b2Body* b = p.body;
		b->SetAwake(false);
		b2Vec2 pos = b2Vec2(b->GetPosition().x+delta/PTM_RATIO, b->GetPosition().y);
		b->SetTransform(pos, b->GetAngle());
		b->SetAwake(true);
	}
	
	left = l;
	
}

-(int) giveMoney {
    int money = 0;
    
    // we'll calculate gold by height * .1 * total hp piece * .1
    for(Piece* piece in self.pieces) {
        if(piece.hasBeenPlaced)
            money += (piece.currentSprite.position.y / PTM_RATIO) * piece.hp * MONEY_FACTOR;
    }
        
    [self addMoney:money];
    
    return money;
}

-(void) addMoney:(int)g {
	[self setGold:gold+g];
}

-(void) removeMoney:(int)g {
	[self setGold:gold-g];
}

-(BOOL) canAfford:(int)g {
	return gold >= g;
}

-(void) addPiece:(Piece *)piece {
	
	[pieces addObject:piece];
	piece.owner = self;
    	
	[piece addObserver:self 
			forKeyPath:@"isChanged" 
			   options:NSKeyValueObservingOptionNew
			   context:nil];
}

-(void) removePiece:(Piece *)piece {
	
	if([pieces containsObject:piece]) {
		[piece removeObserver:self forKeyPath:@"isChanged"];    
    }
	
	[pieces removeObject:piece];
	
}

-(NSArray*) getPieceDescriptions {
	
	NSMutableArray* retArr = [NSMutableArray array];
	
	for(Piece* piece in pieces) {
		
		if([piece isKindOfClass:[City class]]) { continue; }
		
		[retArr addObject:[piece getPieceData]];
		
	}
	
	return retArr;
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self updateOverallHealth];
}

-(void) updateOverallHealth  {
	
	[self setOverallHealth:.6];
}

-(void) setHasWeapon:(BOOL)w {

	if(w) {
		hasWeapon = YES;
		timeTillLoss = TIME_TO_LOSS_WITHOUT_WEAPON;
		[Battlefield instance].sentLoseWarning = NO;
		if([Battlefield instance].sentFinalLoseWarning) {
			[Battlefield instance].sentFinalLoseWarning = NO;
			[[Battlefield instance].hud setCountdownTimer:-2.0];
		}
	}
}

-(BOOL) hasWeapon {
	for(Piece *p in pieces)
		if([p isKindOfClass:[Weapon class]])
			return hasWeapon = YES;
	return hasWeapon = NO;
}

-(void) onTouchBegan:(CGPoint)touch {}

-(void) onTouchMoved:(CGPoint)touch {}

-(BOOL) onTouchEnded:(CGPoint)touch {
	return NO;
}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile *)p {

	// ADD SOUND HERE for ground hit
}

-(void) dealloc {
    for(Piece* piece in [[pieces mutableCopy] autorelease]) {
        [self removePiece:piece];
    }

    [ai release];
	[pieces release];
    
	[super dealloc];
}


@end
