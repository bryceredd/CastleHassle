#import "ContactListener.h"
#import "Piece.h"
#import "Weapon.h"
#import "Projectile.h"
#import "Ground.h"

void ContactListener::BeginContact(b2Contact* contact)
{
	b2Fixture* fixtureA = contact->GetFixtureA();
	b2Fixture* fixtureB = contact->GetFixtureB();
	
	if (contact->IsTouching()) {
		
		//check if the object is a block
		Piece *p1 = (Piece *)fixtureA->GetBody()->GetUserData();
		Piece *p2 = (Piece *)fixtureB->GetBody()->GetUserData();
		
		// update the non projectile
		if([p1 isKindOfClass:[Projectile class]] && p2.acceptsTouches) {
			[p2 targetWasHit:contact by:(Projectile *)p1];
		} else if ([p2 isKindOfClass:[Projectile class]] && p1.acceptsTouches) {
			[p1 targetWasHit:contact by:(Projectile *)p2];
		}
		
		// update the projectil
		if([p1 isKindOfClass:[Projectile class]]) 
			[p1 targetWasHit:contact by:(Projectile *)p2];
		if([p2 isKindOfClass:[Projectile class]])
			[p2 targetWasHit:contact by:(Projectile *)p1];
		
		
		// if contact is made with the ground, blow it up
		if([p1 isKindOfClass:[PlayerArea class]] && p2.acceptsDamage) {
			p2.shouldDestroy = YES;
		}
		
		if([p2 isKindOfClass:[PlayerArea class]] && p1.acceptsDamage) {
			p1.shouldDestroy = YES;
		}
			
	}
}
	
void ContactListener::EndContact(b2Contact* contact)
{
	
}
	
void ContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold)
{
	//const b2Manifold* manifold = contact->GetManifold();
}
	
void ContactListener::PostSolve(b2Contact* contact)
{
	//const b2ContactImpulse* impulse;
}
