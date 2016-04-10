//
//  DistrictAvailabilityProtocol.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MapViewDataSource <NSObject>

-(void)loadDistricts:(NSMutableArray *)districts;
-(void)loadIncidents:(NSMutableArray *)incidents;


@end
