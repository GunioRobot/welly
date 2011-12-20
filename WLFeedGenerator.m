//
//  TYFeedGenerator.m
//  Welly
//
//  Created by aqua on 11/2/2009.
//  Copyright 2009 TANG Yang. All rights reserved.
//

#import "WLFeedGenerator.h"


@implementation WLFeedGenerator

- (id)init {
    return [self initWithSiteName:@""];
}

- (id)initWithSiteName:(NSString *)siteName {
    [super init];
    [siteName retain];
    [_siteName release];
    _siteName = siteName;
    NSXMLElement *root = (NSXMLElement *)[NSXMLNode elementWithName:@"rss"];
    [root addAttribute:[NSXMLNode attributeWithName:@"version" stringValue:@"2.0"]];
    _xmlDoc = [[NSXMLDocument alloc] initWithRootElement:root];
    [_xmlDoc setVersion:@"1.0"];
    [_xmlDoc setCharacterEncoding:@"UTF-8"];
    NSXMLElement *channel = (NSXMLElement *)[NSXMLNode elementWithName:@"channel"];
    [channel addChild:[NSXMLNode elementWithName:@"title" stringValue:[@"Welly: " stringByAppendingString:siteName]]];
    [channel addChild:[NSXMLNode elementWithName:@"description" stringValue:[siteName stringByAppendingString:@" RSS feed generated by Welly."]]];
    [channel addChild:[NSXMLNode elementWithName:@"pubDate" stringValue:[[NSDate date] descriptionWithCalendarFormat:@"%a, %d %b %Y %H:%M:%S %z" timeZone:nil locale:nil]]];
    [root addChild:channel];
    return self;
}

- (void)dealloc {
    [_xmlDoc release];
    [_siteName release];
    [super dealloc];
}

- (void)addItemWithTitle:(NSString *)aTitle
			 description:(NSString *)aDescription
				  author:(NSString *)anAuthor
				 pubDate:(NSString *)aPubDate {
    NSXMLElement *item = (NSXMLElement *)[NSXMLNode elementWithName:@"item"];
    [item addChild:[NSXMLNode elementWithName:@"title" stringValue:aTitle]];
    [item addChild:[NSXMLNode elementWithName:@"description" stringValue:aDescription]];
    [item addChild:[NSXMLNode elementWithName:@"author" stringValue:anAuthor]];
    [item addChild:[NSXMLNode elementWithName:@"pubDate" stringValue:aPubDate]];
    [(NSXMLElement *)[[_xmlDoc rootElement] childAtIndex:0] addChild:item];
}

- (BOOL)writeFeedToFile:(NSString *)fileName {
    return [[_xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint] writeToFile:fileName atomically:YES];
}

@end
