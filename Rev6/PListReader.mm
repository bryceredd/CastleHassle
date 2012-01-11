//
//  PListReader.m
//  ProSound
//
//  Created by Bryce Redd on 10/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PListReader.h"


@implementation PListReader

+ (NSDictionary *)getAppPlist {
	
	NSPropertyListFormat format;
	NSString *plistPath;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
															  NSUserDomainMask, YES) objectAtIndex:0];
	
	plistPath = [rootPath stringByAppendingPathComponent:PLIST_FILE_NAME];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		plistPath = [[NSBundle mainBundle] pathForResource:@"props" ofType:@"plist"];
	}
	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format
										  errorDescription:nil];
	
	if (!temp) {
		NSLog(@"Error reading plist: format: %d", format);
	}
	
	[[temp retain] autorelease];
	return temp;
}

+ (void)saveAppPlist:(NSDictionary *)plistDict {

	NSString *error;
	NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *plistPath = [rootPath stringByAppendingPathComponent:PLIST_FILE_NAME];
	
	NSLog(@"saving plist to %@", plistPath);
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
	if(plistData) {
		[plistData writeToFile:plistPath atomically:YES];
	} else {
		NSLog(@"%@", error);
		[error release];
	}
}

/*
 
 USEAGE:READ:
 
 NSDictionary *props = [PListReader getAppPlist];	
 
 if ([(NSString*)[props objectForKey:@"PrimaryEmail"] compare:@""] != NSOrderedSame && [(NSString*)[props objectForKey:@"PrimaryHandle"] compare:@""] != NSOrderedSame) {
 NSString* email = (NSString *)[props objectForKey:@"PrimaryEmail"];
 NSString* username = (NSString *)[props objectForKey:@"PrimaryHandle"];
 
 
 
 USEAGE:WRITE:
 
 NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: e, u, nil]
 forKeys:[NSArray arrayWithObjects: @"PrimaryEmail", @"PrimaryHandle", nil]];
 [PListReader saveAppPlist:dict];
 */
 
@end
