//
//  Incident.m
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import "Incident.h"


@implementation Incident
@synthesize title;

-(NSString *)title
{
    
    return self.category;
    
}

-(NSString *)subtitle
{
    
    NSString * date = [NSString stringWithFormat:@"Date:%@",self.incidentDate];
    return date;
    
}

@end
