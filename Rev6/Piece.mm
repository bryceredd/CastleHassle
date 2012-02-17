//
//  Body.mm
//  Rev3
//
//  Created by Bryce Redd on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "Piece.h"
#import "Projectile.h"
#import "PlayerArea.h"
#import "Battlefield.h"
#import "PlayerAreaManager.h"
#import "GameSettings.h"
#import "PoofRepairAnimation.h"
#import "Weapon.h"
#import "HUD.h"

@implementation Piece

@synthesize body, hp, currentSprite, world, acceptsTouches, acceptsDamage, shouldDestroy, snappedTo, hasBeenPlaced;
@synthesize backSprite, maxHp, isChanged, repairPrice, owner, buyPrice, pieceID;
@synthesize animationLabel, acceptsPlayerColoring, isFacingLeft, spriteName, shouldDestroyReally;

-(id) initWithWorld:(b2World *)w coords:(CGPoint)p {
	
	if((self = [super init])) {
        world = w;
		shouldDestroy = NO;
		hasBeenPlaced = NO;
		isFacingLeft = YES;
		acceptsPlayerColoring = NO;
		snappedTo = nil;
		backSprite = nil;
		buyPrice = 0;
		repairPrice = 50;
		owner = nil;
		pieceID = -1;
	}
	
	
	return self;
}

-(void) setOwner:(PlayerArea *)pa {
	owner = pa;
	[self updateView];
}

-(int) getCurrentRepairPrice {
	float totalHP = 1-(float)hp/(float)maxHp;
	return (int)(totalHP*(float)repairPrice);
}

-(void) unselect {
	
}

-(void) repairPiece {
	
	if(![owner canAfford:[self getCurrentRepairPrice]]) {
		[[Battlefield instance].hud showMessage:@"Not enough gold"];
		return;
	}
	
	if(![self getCurrentRepairPrice]) {
		return;
	}
	
	[owner removeMoney:[self getCurrentRepairPrice]];
	
    [self repairPieceLocal];
}

-(void) repairPieceLocal {
	
	//This is for sound repair
	[[SimpleAudioEngine sharedEngine] playEffect:@"repair.caf"];
	
	//Riparazione Animazione
	CGPoint loc = ccp(body->GetPosition().x*PTM_RATIO, body->GetPosition().y*PTM_RATIO - 8);
	CCParticleSystem* ps = [[[PoofRepairAnimation alloc] initWithTotalParticles:60] autorelease];
	ps.position = loc;
	ps.life = 0.08f;
	[[Battlefield instance] addChild:ps z:ANIMATION_Z_INDEX];
	//Fine Animazione
	
	hp = maxHp;
	[self updateView];
}

-(int) zIndex {
    return PIECE_Z_INDEX;
}

-(int) zFarIndex {
    return FAR_PIECE_Z_INDEX;
}

-(void) setupSpritesWithRect:(CGRect)rect image:(NSString*)image atPoint:(CGPoint)p {

	self.currentSprite = spriteWithRect(image, rect);
	[[Battlefield instance] addChild:currentSprite z:[self zIndex]];
	currentSprite.position = ccp(p.x, p.y);
	
	self.backSprite = spriteWithRect(image, rect);
	[backSprite setScale:1/BACKGROUND_SCALE_FACTOR];
	[[Battlefield instance] addChild:backSprite z:[self zFarIndex]];
	backSprite.position = ccp(p.x, p.y+PLAYER_BACKGROUND_HEIGHT);
	backSprite.flipX = YES;
}

-(void) updateView {
	if (acceptsPlayerColoring) {
		currentSprite.color = [[GameSettings instance] getColorForPlayer:owner]; 
		backSprite.color = [[GameSettings instance] getColorForPlayer:owner]; 	
	} else {
		currentSprite.color = ccc3(255, 255, 255);
		backSprite.color = ccc3(255, 255, 255);
	}
	
	[self setIsChanged:!isChanged];
}

-(void) onTouchBegan:(CGPoint)touch {
	if(!hasBeenPlaced) { body->SetAwake(false); }
}

-(void) onTouchMoved:(CGPoint)touch {
	if(!hasBeenPlaced) {
		
		[currentSprite setOpacity:HUD_ITEM_DRAG_OPACITY];
        [currentSprite setScale:HUD_ITEM_DRAG_SIZE];
		
		body->SetAwake(false);
		
		// get touch location
		b2Vec2 pos = b2Vec2(touch.x/PTM_RATIO, touch.y/PTM_RATIO);
		
		// set the body position so we dont raycast ourselves
		body->SetTransform(pos, body->GetAngle());
		
		// snap the position
		pos = [self snapToPosition:pos];
		
		// assign the body transform to the given location
		body->SetTransform(pos, body->GetAngle());
	}
}

-(BOOL) onTouchEnded:(CGPoint)touch {
	if(!hasBeenPlaced) {
		if(!snappedTo) {
            shouldDestroy = YES;
			[[Battlefield instance].hud showMessage:@"Unable to build piece."];
            return NO;
		}
        
        b2Vec2 touchInBox2dCoords = b2Vec2(touch.x/PTM_RATIO, touch.y/PTM_RATIO);
        b2Vec2 snapPositionInBox2dCords = [self snapToPosition:touchInBox2dCoords];
        CGPoint pos = ccp(snapPositionInBox2dCords.x * PTM_RATIO, snapPositionInBox2dCords.y * PTM_RATIO);
        
        if([self touchIsInsideOtherBody:pos]) {
            shouldDestroy = YES;
			[[Battlefield instance].hud showMessage:@"Unable to build piece."];
            return NO;
        } 
        
        [owner removeMoney:buyPrice];
        [self finalizePiece];
	}
	
	return NO;
}

-(BOOL) touchIsInsideOtherBody:(CGPoint)point {
    for(Piece* piece in owner.pieces) {
        if(piece == self) continue;
        
        if([piece containsPoint:b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO)]) {
            return YES;
        }
    }

    return NO;
}

-(b2Vec2) snapToPosition:(b2Vec2)pos {
	[self doesNotRecognizeSelector:_cmd];
	return b2Vec2(0,0);
}

-(void) destroyJoints {
	for(b2JointEdge* j = body->GetJointList(); j; j=j->next) { world->DestroyJoint(j->joint); }
}

-(void) addSnappingJoints {}

-(void) targetWasHit:(b2Contact*)contact by:(Projectile*)p {
	
	float speedFactor = p.body->GetLinearVelocity().Length() * p.body->GetMass();
	float damage = p.baseDamage + speedFactor * DAMAGE_VELOCITY_MULTIPLIER;
    
	// damage is some base + mass
	hp -= damage;
	
	shouldDestroy = hp <= 0;

	self.animationLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%.0f", damage] fontName:@"Arial-BoldMT" fontSize:20];
	[animationLabel setColor:ccc3(255,0,0)];
	
	//position the label relative to target hit
	animationLabel.position = CGPointMake(p.body->GetPosition().x * PTM_RATIO, p.body->GetPosition().y * PTM_RATIO + 40);
	
	// add some animation
	id labelAction1 = [CCMoveBy actionWithDuration:0.8 position:ccp(0,100)];
	id labelAction2 = [CCFadeOut actionWithDuration:0.9];
	id labelAction2Sel = [CCSequence actionOne:labelAction2 two:[CCCallFunc actionWithTarget:self selector:@selector(actionDone)]];
	
	//Start animating label
	[animationLabel runAction:labelAction1];
	[animationLabel runAction:labelAction2Sel];
	
	[[Battlefield instance] addChild:animationLabel z:ANIMATION_Z_INDEX];
	
	//************************** Sound section starts here *******************
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"cannonball-wall-hita.caf"];
	
	//************************** Sound section ends here *********************
	
	
	[self updateView];
}

-(void) setIsFacingLeft:(BOOL)b {
	isFacingLeft = b;
	currentSprite.flipX = !b;
	backSprite.flipX = b;
}

//label action calls this function when action is over to clean up label from screen
-(void) actionDone {
	[[Battlefield instance] removeChild:animationLabel cleanup:YES];
    self.animationLabel = nil;
}

-(void) finalizePieceBase {
    pieceID = [owner getUniquePieceID];
    body->SetType(b2_dynamicBody);
	body->SetAwake(true);
	hasBeenPlaced = YES;
	[currentSprite setOpacity:255];
    [currentSprite setScale:1.f];
	[self updateView];
}

-(void) finalizePiece {
	[self finalizePieceBase];
}

-(bool) containsPoint:(b2Vec2)p {
	
	// for each fixture in the body
	for (b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext()) {
	
		// test if touch is inside 
		if(f->TestPoint(p)) return true;
		   
	}
	
	return false;
}

-(void) restoreToState:(NSDictionary*)state {
	[self destroyJoints]; 
	
	float x = ([[state objectForKey:@"x"] floatValue]+owner.left)/PTM_RATIO;
	float y = [[state objectForKey:@"y"] floatValue]/PTM_RATIO;
	hp = [[state objectForKey:@"hp"] intValue];
	float angle = [[state objectForKey:@"angle"] floatValue];
	BOOL isLeft = [[state objectForKey:@"left"] intValue] == 1;
	
	body->SetAwake(false);
	body->SetTransform(b2Vec2(x,y), angle);
	body->SetAwake(true);
	
	[self updateView];
	[self setIsFacingLeft:isLeft];
	
}

-(NSDictionary*) getPieceData {
	
	float ang = body->GetAngle();
	
	if(!owner) { self.owner = [[Battlefield instance].playerAreaManager getCurrentPlayerArea]; }
	if(pieceID < 0) { pieceID = [owner getUniquePieceID]; }
	
	float x = body->GetPosition().x;
	float y = body->GetPosition().y - owner.left;
	
	NSMutableDictionary* pieceInfo = [NSMutableDictionary dictionary];
	[pieceInfo setObject:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
	[pieceInfo setObject:[NSString stringWithFormat:@"%f", x] forKey:@"x"];
	[pieceInfo setObject:[NSString stringWithFormat:@"%f", y] forKey:@"y"];
	[pieceInfo setObject:[NSString stringWithFormat:@"%f", ang] forKey:@"angle"];
	[pieceInfo setObject:[NSString stringWithFormat:@"%d", hp] forKey:@"hp"];
	[pieceInfo setObject:[NSString stringWithFormat:@"%d", pieceID] forKey:@"pieceid"];
	[pieceInfo setObject:[NSString stringWithFormat:(isFacingLeft?@"1":@"0")] forKey:@"left"];
	[pieceInfo setObject:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
	
	return pieceInfo;
}

- (void) dealloc {
    [currentSprite release];
    [backSprite release];
    [animationLabel release];
    
    [super dealloc];
}

@end
