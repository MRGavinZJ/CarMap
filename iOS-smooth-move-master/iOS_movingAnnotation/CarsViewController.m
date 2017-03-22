



#import <MAMapKit/MAMapKit.h>
#import "CustomMovingAnnotation.h"
#import "CustomMAAnimatedAnnotation.h"
#import "CarsViewController.h"

static CLLocationCoordinate2D s_coords[] =
{
    {39.97617053371078, 116.3499049793749},
    {39.97619854213431, 116.34978804908442},
    {39.97623045687959, 116.349674596623},
    {39.97626931100656, 116.34955525200917},
    {39.976285626595036, 116.34943728748914},
    {39.97628129172198, 116.34930864705592},
    {39.976260803938594, 116.34918981582413},
    {39.97623535890678, 116.34906721558868},
    {39.976214717128855, 116.34895185151584},
    {39.976280148755315, 116.34886935936889},
    {39.97628182112874, 116.34873954611332},
    {39.97626038855863, 116.34860763527448},
    {39.976306080391836, 116.3484658907622},
    {39.976358252119745, 116.34834585430347},
    {39.97645709321835, 116.34831166130878},
    {39.97655231226543, 116.34827643560175},
    {39.976658372925556, 116.34824186261169},
    {39.9767570732376, 116.34825080406188},
    {39.976869087779995, 116.34825631960626},
    {39.97698451764595, 116.34822111635201},
    {39.977079745909876, 116.34822901510276},
    {39.97718701787645, 116.34822234337618},
    {39.97730766147824, 116.34821627457707},
    {39.977417746816776, 116.34820593515043},
    {39.97753930933358, 116.34821013897107},
    {39.977652209132174, 116.34821304891533},
    {39.977764016531076, 116.34820923399242},
    {39.97786190186833, 116.3482045955917},
    {39.977958856930286, 116.34822159449203},
    {39.97807288885813, 116.3482256370537},
    {39.978170063673524, 116.3482098441266},
    {39.978266951404066, 116.34819564465377},
    {39.978380693859116, 116.34820541974412},
    {39.97848741209275, 116.34819672351216},
    {39.978593409607825, 116.34816588867105},
    {39.97870216883567, 116.34818489339459},
    {39.978797222300166, 116.34818473446943},
    {39.978893492422685, 116.34817728972234},
    {39.978997133775266, 116.34816491505472},
    {39.97911413849568, 116.34815408537773},
    {39.97920553614499, 116.34812908154862},
    {39.979308267469264, 116.34809495907906},
    {39.97939658036473, 116.34805113358091},
    {39.981052294975264, 116.34537348820508},
    {39.980956549928244, 116.3453513775533}
};

@interface CarsViewController ()<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

///车头方向跟随转动
@property (nonatomic, strong) CustomMAAnimatedAnnotation *car1;


///车头方向跟随转动
@property (nonatomic, strong) MAAnimatedAnnotation *car2;


///车头方向跟随转动
@property (nonatomic, strong) MAAnimatedAnnotation *car3;


///车头方向跟随转动
@property (nonatomic, strong) MAAnimatedAnnotation *car4;

///车头方向跟随转动
@property (nonatomic, strong) MAAnimatedAnnotation *car5;
/////车头方向不跟随转动
//@property (nonatomic, strong) CustomMovingAnnotation *car2;

///全轨迹overlay
@property (nonatomic, strong) MAPolyline *fullTraceLine;
///走过轨迹的overlay
@property (nonatomic, strong) MAPolyline *passedTraceLine;
@property (nonatomic, assign) int passedTraceCoordIndex;

@property (nonatomic, strong) NSArray *distanceArray;
@property (nonatomic, assign) double sumDistance;

@property (nonatomic, weak) MAAnnotationView *car1View;
@property (nonatomic, weak) MAAnnotationView *car2View;
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation CarsViewController

#pragma mark - Map Delegate
- (void)mapInitComplete:(MAMapView *)mapView {
    [self initRoute];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    
    /* Step 2. */
    if ([annotation isKindOfClass:[CustomMAAnimatedAnnotation class]]){
        
        NSString *pointReuseIndetifier = @"pointReuseIndetifier1";
        
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if(!annotationView) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            
            annotationView.canShowCallout = YES;
            
            UIImage *imge  =  [UIImage imageNamed:@"car1"];
            annotationView.image =  imge;
            
            self.car1View = annotationView;
        }
        
        return annotationView;
        
    }else{
        
        NSString *pointReuseIndetifier = @"pointReuseIndetifier3";
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout = YES;
        }
        
        if ([annotation.title isEqualToString:@"route"]) {
            annotationView.enabled = NO;
            annotationView.image = [UIImage imageNamed:@"trackingPoints"];
            annotationView.hidden=YES;
        }
        
        //                [self.car1View.superview bringSubviewToFront:self.car1View];
        //                [self.car2View.superview bringSubviewToFront:self.car2View];
        
        return annotationView;
        
        
    }
    
    //    } else if(annotation == self.car2) {
    //        NSString *pointReuseIndetifier = @"pointReuseIndetifier2";
    //
    //        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
    //        if(!annotationView) {
    //            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
    //
    //            annotationView.canShowCallout = YES;
    //
    //            UIImage *imge  =  [UIImage imageNamed:@"car2"];
    //            annotationView.image =  imge;
    //
    //            self.car2View = annotationView;
    //        }
    //
    //        return annotationView;
    //    } else if([annotation isKindOfClass:[MAPointAnnotation class]]) {
    //        NSString *pointReuseIndetifier = @"pointReuseIndetifier3";
    //        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
    //        if (annotationView == nil) {
    //            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
    //            annotationView.canShowCallout = YES;
    //        }
    //
    //        if ([annotation.title isEqualToString:@"route"]) {
    //            annotationView.enabled = NO;
    //            annotationView.image = [UIImage imageNamed:@"trackingPoints"];
    //        }
    //
    //        [self.car1View.superview bringSubviewToFront:self.car1View];
    //        [self.car2View.superview bringSubviewToFront:self.car2View];
    //
    //        return annotationView;
    //    }
    
    return nil;
}
//
- (MAPolylineRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    if(overlay == self.fullTraceLine) {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 6.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0.47 blue:1.0 alpha:0.9];
        
        return polylineView;
    } else if(overlay == self.passedTraceLine) {
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 6.f;
        polylineView.strokeColor = [UIColor grayColor];
        
        return polylineView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    NSLog(@"cooridnate :%f, %f", view.annotation.coordinate.latitude, view.annotation.coordinate.longitude);
}

#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _annotations =[NSMutableArray array];
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
    
    [self initBtn];
    
    
    int count = sizeof(s_coords) / sizeof(s_coords[0]);
    double sum = 0;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for(int i = 0; i < count - 1; ++i) {
        CLLocation *begin = [[CLLocation alloc] initWithLatitude:s_coords[i].latitude longitude:s_coords[i].longitude];
        CLLocation *end = [[CLLocation alloc] initWithLatitude:s_coords[i+1].latitude longitude:s_coords[i+1].longitude];
        CLLocationDistance distance = [end distanceFromLocation:begin];
        [arr addObject:[NSNumber numberWithDouble:distance]];
        sum += distance;
    }
    
    self.distanceArray = arr;
    self.sumDistance = sum;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initRoute {
    int count = sizeof(s_coords) / sizeof(s_coords[0]);
    
    self.fullTraceLine = [MAPolyline polylineWithCoordinates:s_coords count:count];
    [self.mapView addOverlay:self.fullTraceLine];
    
    NSMutableArray * routeAnno = [NSMutableArray array];
    for (int i = 0 ; i < count; i++) {
        MAPointAnnotation * a = [[MAPointAnnotation alloc] init];
        a.coordinate = s_coords[i];
        a.title = @"route";
        [routeAnno addObject:a];
    }
    [self.mapView addAnnotations:routeAnno];
    [self.mapView showAnnotations:routeAnno animated:NO];

    
    
    for (int i =0 ; i <5; i++) {
        
        self.car1 = [[CustomMAAnimatedAnnotation alloc] init];
        self.car1.title = [NSString stringWithFormat:@"%d",i];
        
        int randomIndex =arc4random() % count;
        
        self.car1.carIndex=randomIndex;
        [self.car1 setCoordinate:s_coords[randomIndex]];


//        if (arc4random() % 5<2) {
//            self.car1.isRun =YES;
//        }else{
//            self.car1.isRun =NO;
//        }

        [_annotations addObject:self.car1];
        
    }
    
    [self.mapView addAnnotations:_annotations];
    
    //    self.car1 = [[MAAnimatedAnnotation alloc] init];
    //    self.car1.title = @"Car1";
    //    [self.mapView addAnnotation:self.car1];
    //
    //
    //    self.car2 = [[MAAnimatedAnnotation alloc] init];
    //
    //    self.car2.title = @"Car2";
    //    [self.mapView addAnnotation:self.car2];
    //
    //
    //    self.car3 = [[MAAnimatedAnnotation alloc] init];
    //
    //    self.car3.title = @"Car3";
    //    [self.mapView addAnnotation:self.car3];
    //
    //
    //    self.car4 = [[MAAnimatedAnnotation alloc] init];
    //
    //    self.car4.title = @"Car4";
    //    [self.mapView addAnnotation:self.car4];
    //
    //
    //    self.car5 = [[MAAnimatedAnnotation alloc] init];
    //
    //    self.car5.title = @"Car5";
    //    [self.mapView addAnnotation:self.car5];
    //
    //    [self.car1 setCoordinate:s_coords[0]];
    //    [self.car2 setCoordinate:s_coords[5]];
    //        [self.car3 setCoordinate:s_coords[10]];
    //        [self.car4 setCoordinate:s_coords[15]];
    //        [self.car5 setCoordinate:s_coords[20]];
}

- (void)initBtn {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 100, 60, 40);
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:@"move" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(mov) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(0, 200, 60, 40);
    btn1.backgroundColor = [UIColor grayColor];
    [btn1 setTitle:@"stop" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn1];
}

#pragma mark - Action

- (void)mov {
//    double speed_car1 = 120.0 / 3.6; //80 km/h
    int count = sizeof(s_coords) / sizeof(s_coords[0]);
//    [self.car1 setCoordinate:s_coords[0]];
    
    
    
    for (CustomMAAnimatedAnnotation *car in _annotations) {
        
        
        //         NSLog(@"longitude is %f latitude is %f",car.coordinate.longitude,car.coordinate.latitude);
        //        [car setCoordinate:s_coords[arc4random() % count]];
        
        
//        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(car.coordinate.latitude,car.coordinate.longitude);//纬度
//        
//        [car setCoordinate:coords];
        
//        if (!car.isRun) {
//            [car addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:10.0 withName:nil completeCallback:^(BOOL isFinished) {
//                ;
//            }];
//        }
        //
        
        
                [car addMoveAnimationWithKeyCoordinates:&s_coords[car.carIndex] count:count-car.carIndex withDuration:10.0 withName:nil completeCallback:^(BOOL isFinished) {
                    ;
                }];
    }
    //    [self.car1 addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:3.0 withName:nil completeCallback:^(BOOL isFinished) {
    //        ;
    //    }];
    //
    //
    //    [self.car2 setCoordinate:s_coords[5]];
    //    [self.car2 addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:3.0 withName:nil completeCallback:^(BOOL isFinished) {
    //        ;
    //    }];
    //
    //
    //    [self.car3 setCoordinate:s_coords[10]];
    //    [self.car3 addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:3.0 withName:nil completeCallback:^(BOOL isFinished) {
    //        ;
    //    }];
    //
    //
    //    [self.car4 setCoordinate:s_coords[15]];
    //    [self.car4 addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:3.0 withName:nil completeCallback:^(BOOL isFinished) {
    //        ;
    //    }];
    //
    //
    //    [self.car5 setCoordinate:s_coords[20]];
    //    [self.car5 addMoveAnimationWithKeyCoordinates:s_coords count:count withDuration:3.0 withName:nil completeCallback:^(BOOL isFinished) {
    //        ;
    //    }];
    
    
    
    //小车2走过的轨迹置灰色, 采用添加多个动画方法
    //    double speed_car2 = 100.0 / 3.6; //60 km/h
    //    __weak typeof(self) weakSelf = self;
    //    [self.car2 setCoordinate:s_coords[0]];
    //    self.passedTraceCoordIndex = 0;
    //    for(int i = 1; i < count; ++i) {
    //        NSNumber *num = [self.distanceArray objectAtIndex:i - 1];
    //        [self.car2 addMoveAnimationWithKeyCoordinates:&(s_coords[i]) count:1 withDuration:num.doubleValue / speed_car2 withName:nil completeCallback:^(BOOL isFinished) {
    //            weakSelf.passedTraceCoordIndex = i;
    //        }];
    //    }
}

- (void)stop {
    for(MAAnnotationMoveAnimation *animation in [self.car1 allMoveAnimations]) {
        [animation cancel];
    }
    self.car1.movingDirection = 0;
    [self.car1 setCoordinate:s_coords[0]];
    
    for(MAAnnotationMoveAnimation *animation in [self.car2 allMoveAnimations]) {
        [animation cancel];
    }
    self.car2.movingDirection = 0;
    [self.car2 setCoordinate:s_coords[0]];
    
    if(self.passedTraceLine) {
        [self.mapView removeOverlay:self.passedTraceLine];
        self.passedTraceLine = nil;
    }
}

//小车2走过的轨迹置灰色
- (void)updatePassedTrace {
    if(self.car2.isAnimationFinished) {
        return;
    }
    
    if(self.passedTraceLine) {
        [self.mapView removeOverlay:self.passedTraceLine];
    }
    
    int needCount = self.passedTraceCoordIndex + 2;
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * needCount);
    
    memcpy(coords, s_coords, sizeof(CLLocationCoordinate2D) * (self.passedTraceCoordIndex + 1));
    coords[needCount - 1] = self.car2.coordinate;
    self.passedTraceLine = [MAPolyline polylineWithCoordinates:coords count:needCount];
    [self.mapView addOverlay:self.passedTraceLine];
    
    if(coords) {
        free(coords);
    }
}

@end
