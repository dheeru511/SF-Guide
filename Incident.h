//
//  Incident.h
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Incident : NSObject<MKAnnotation>

// This class is a Model class which represents incidents and details about incident.This class also conforms to MKannotation protocol to provide to coordinates to draw incidents on Map


@property (strong,nonatomic) NSString * incidentDate;
@property (nonatomic,copy,readonly) NSString * title;
@property (nonatomic,copy,readonly) NSString * subtitle;
@property (nonatomic,copy) NSString * category;
@property (strong,nonatomic) NSString * incidentAddress;
@property (assign,nonatomic)  CLLocationCoordinate2D  coordinate;

@end
