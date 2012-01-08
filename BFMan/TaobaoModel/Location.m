//
//  Location.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "Location.h"

@implementation Location
@synthesize zip, city, state, contry, district;

+ (Location *)locationFromResponse:(NSDictionary *)respDict {
    Location *loc = [[Location alloc] init];
    
    loc.zip = [respDict objectForKey:@"zip"];
    loc.city = [respDict objectForKey:@"city"];
    loc.state = [respDict objectForKey:@"state"];
    loc.contry = [respDict objectForKey:@"country"];
    loc.district = [respDict objectForKey:@"district"];
    
    return loc;
}

@end
