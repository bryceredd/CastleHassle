//
//  ContactListener.h
//  Rev3
//
//  Created by Bryce Redd on 11/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Box2D.h"
#import "cocos2d.h"

const int32 k_maxContactPoints = 2048;

struct ContactPoint
{
	b2Fixture* fixtureA;
	b2Fixture* fixtureB;
	b2Vec2 normal;
	b2Vec2 position;
	b2PointState state;
};

class ContactListener : public b2ContactListener
{
    int32 m_pointCount;
    ContactPoint m_points[k_maxContactPoints];
	
public:
    void BeginContact(b2Contact* contact);
	
    void EndContact(b2Contact* contact);
	
    void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	
    void PostSolve(b2Contact* contact);
};
