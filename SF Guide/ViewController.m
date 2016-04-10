//
//  ViewController.m
//  SF Guide
//
//  Created by Dheeraj Singh on 1/22/16.
//  Copyright © 2016 Dheeraj Singh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) NSDictionary * colorCoding;
@property (strong,nonatomic) ModelManager * model;
@property (strong,nonatomic) NSNumber * displayedIncidentsCounter;

@end

@implementation ViewController

static NSNumber * colorCodingNumber = 0;
static NSString * incident= @"INCIDENT";


// Dictionary used to provide colorCoding to district mkpolygon objects based on the count of incidents
-(NSDictionary *)colorCoding
{
    if (!_colorCoding) {
        _colorCoding = @{@1:@"#ff0000",@2:@"#eb3600",@3:@"#e54800",@4:@"#d86d00",@5:@"#d27f00",@6:@"#c5a300",@7:@"#b9c800",@8:@"#a6ff00",@9:@"#a6ff00",@10:@"#a6ff00"};
    }
    
    return _colorCoding;
}

//Lazy Instantiation of model object
-(ModelManager *)model
{
    if (!_model) {
        _model = [[ModelManager alloc]init];
        _model.delegate=self;
    }
    
    return _model;
}

// In viewdidload method to download districts is triggered and initial region for map view is set as San Francisco
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.model downloadDistricts];
    MKCoordinateSpan span;
    span.latitudeDelta = 0.3;
    span.longitudeDelta = 0.3;
    
    // define starting point for map
    CLLocationCoordinate2D start;
    start.latitude = 37.786996;
    start.longitude = -122.440100;
    
    // create region, consisting of span and location
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    // move the map to our location
    [self.mapView setRegion:region animated:YES];
}



-(void)loadDistricts:(NSMutableArray *)districts
{
    NSArray * overlays=[districts valueForKeyPath:@"districtCoordinatesPolygon"];
    [self.mapView addOverlays:overlays level:MKOverlayLevelAboveRoads ];
}

-(void)loadIncidents:(NSMutableArray *)incidents
{
    if ([self.displayedIncidentsCounter integerValue]==0) {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    [self.mapView addAnnotations:incidents];
}

- (IBAction)loadMoreIncidents:(id)sender
{
    self.displayedIncidentsCounter = @([self.displayedIncidentsCounter integerValue]+1);// incrementing counter everytim user clicks on 'load more incdents' button
    [self loadIncidentsforCount:self.displayedIncidentsCounter];

}


#pragma mark MKMapview Delegate methods


//This method provides MKOverlayRenderer objects to render MKPolygon objects
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    colorCodingNumber = @([colorCodingNumber integerValue]+1);
    MKPolygonRenderer * renderer = [[MKPolygonRenderer alloc]initWithOverlay:overlay];
    renderer.fillColor =[UIColor colorwithHexString:self.colorCoding[colorCodingNumber] alpha:1];
    return renderer;
}

//This method provides MKAnnotationView objects to show annotations on map view
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView * aView =[mapView dequeueReusableAnnotationViewWithIdentifier:incident];
    if (!aView) {
        aView =[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:incident];
        aView.canShowCallout=YES;
    }else{
        aView.annotation=annotation;
    }
    
    return aView;
    
}

//This method is implemented to trigger downloading new incidents whenever User scrolls and map view region displayed on screen changes
- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
    self.displayedIncidentsCounter = @0;// when user scrolls to new region,counter is reset to zero
    [self loadIncidentsforCount:self.displayedIncidentsCounter];
}

-(void)loadIncidentsforCount:(NSNumber *)count
{
    MKCoordinateRegion region = self.mapView.region;
    CLLocationCoordinate2D northWest = CLLocationCoordinate2DMake(
                                                                  region.center.latitude + region.span.latitudeDelta / 2.0,
                                                                  region.center.longitude - region.span.longitudeDelta / 2.0);
    CLLocationCoordinate2D southEast = CLLocationCoordinate2DMake(
                                                                  region.center.latitude - region.span.latitudeDelta / 2.0,
                                                                  region.center.longitude + region.span.longitudeDelta / 2.0);
    NSValue * northWestObject= [NSValue valueWithMKCoordinate:northWest];
    NSValue * southEastObject= [NSValue valueWithMKCoordinate:southEast];
    NSArray * coordinatesArray= @[northWestObject,southEastObject];
    [self.model downloadIncidentsForCoordinates:coordinatesArray andCount:@([self.displayedIncidentsCounter integerValue]*50) ];

    
}


@end
