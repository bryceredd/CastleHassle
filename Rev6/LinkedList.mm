//
//  LinkedList.m
//  Rev3
//
//  Created by Bryce Redd on 1/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//
//  LinkedList.m
//

#import "LinkedList.h"


@implementation LinkedList


/* Instantiates new linked list with a 
 * given first element. 
 */
- (id)initWithHead: (int)value 
{
	ListNode *n;
    self = [super init];
    if (self) {
		// creating head node with given value
		n = (ListNode *)malloc(sizeof(ListNode));
		n->value = value;
		n->next = NULL;
		n->prev = NULL;
		head = n;
		// initializing iterator to default
		[self getFirst];
    }
    return self;	
}


/* Adds a new element to the
 * front of the list */
- (void)addToFront: (int)value
{
	ListNode *n = (ListNode *)malloc(sizeof(ListNode));
	n->value = value;
	n->next = head;
	n->prev = NULL;
	// new element becomes the head node
	head->prev = n;
	head = n;
}


/* Sets internal iterator to
 * the head node and returns its
 * value */
- (int)getFirst {
	iterator = head;
	//reachedHead = TRUE;
	//reachedTail = FALSE;
	return (head->value);
}

/* Returns the value of the iterator node
 */
- (int)getCurrent {
	return (iterator->value);
}


/* Iterates to the next node in order and
 * returns its value */
/*
 - (int)getNext
 {
 // if we are finished iterating,
 // set the end-of-list flag
 if (iterator->next == NULL) {
 reachedTail = TRUE;
 } else {
 // if we're leaving the head
 // node, set the flag
 if (iterator->prev == NULL) {
 reachedHead = FALSE;
 }
 iterator = iterator->next;
 }
 return (iterator->value);
 }
 */
- (int)getNext
{
	if (iterator->next != NULL) {
		iterator = iterator->next;
	}
	return (iterator->value);
}


/* Iterates to the previous node in 
 * order and returns its value */
/*
 - (int)getPrevious
 {
 if (iterator->prev == NULL) {
 reachedHead = TRUE;
 } else {
 if (iterator->next == NULL) {
 reachedTail = FALSE;
 }
 iterator = iterator->prev;
 }
 return (iterator->value);
 }
 */
- (int)getPrevious
{
	if (iterator->prev != NULL) {
		iterator = iterator->prev;
	}
	return (iterator->value);
}


/* Indicates that iterator
 * is at the first (head) node */
- (bool)atHead 
{
	//return reachedHead;
	return (iterator->prev == NULL);
}


/* Indicates that iterator
 * is at the last (tail) node */
- (bool)atTail 
{
	//return reachedTail;
	return (iterator->next == NULL);
}


/* Removes the iterator node from
 * the list and advances iterator to the
 * next element. If there's no next element,
 * then it backs iterator up to the previous
 * element. Returns the old iterator value */
- (int)removeCurrent 
{
	int i = iterator->value;
	ListNode *l;
	// if we have only 1 item in the list...
	if ((iterator->next == NULL) && (iterator->prev == NULL)) {
		//... then we can safely delete it and set head to null
		free(iterator);
		iterator = NULL;
		head = NULL;
	} else {
		// sawing the gap between nodes
		l = iterator;
		if (iterator->next != NULL) {
			iterator->next->prev = iterator->prev;
		}
		if (iterator->prev != NULL) {
			iterator->prev->next = iterator->next;
		}
		// finally setting new iterator
		iterator = (iterator->next != NULL) ? iterator->next : iterator->prev;
		free(l);
	}
	// returning old value
	return i;
}

@end

