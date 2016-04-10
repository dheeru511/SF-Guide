//
//  District.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Incident.h"
#import <MapKit/MapKit.h>

@interface District : NSObject

// This class is a Model class which represents district, no of incidents in the district(to determine overlay color) and mkpolygon object required to overlay distict on map

@property (strong,nonatomic) NSString * districtName;
@property (strong,nonatomic) NSNumber * incidentsCount;
@property (strong,nonatomic) MKPolygon * districtCoordinatesPolygon ;


@end
