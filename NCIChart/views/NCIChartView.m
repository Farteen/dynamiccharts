//
//  NCIChartView.m
//  NCIChart
//
//  Created by Ira on 12/22/13.
//  Copyright (c) 2013 FlowForwarding.Org. All rights reserved.
//

#import "NCIChartView.h"
#import "NCITopChartView.h"
#import "NCIBtmChartView.h"
#import "NCIZoomGraphView.h"

@interface NCIChartView(){
    float btmChartHeigth;
    float chartsSpace;
    NSMutableDictionary *topOptions;
    NSDictionary *bottomOptions;
}

@end

@implementation NCIChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGraps];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andOptions:(NSDictionary *)opts{
    self = [super initWithFrame:frame];
    if (self) {
        if ([opts objectForKey:nciTopGraphOptions]){
            topOptions = [[NSMutableDictionary alloc] initWithDictionary: [opts objectForKey:nciTopGraphOptions]];
        }
        if ([opts objectForKey:nciBottomGraphOptions]){
            bottomOptions = [opts objectForKey:nciBottomGraphOptions];
        }
        if ([opts objectForKey:nciBottomChartHeight]){
            btmChartHeigth = [[opts objectForKey:nciBottomChartHeight] floatValue];
        }
        [self addGraps];
    }
    return self;
}

- (void)defaultSetup{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        btmChartHeigth =  90;
        chartsSpace = 30;
    } else {
        btmChartHeigth =  50;
        chartsSpace = 10;
    }
    self.chartData = [[NSMutableArray alloc] init];
}

- (void)addGraps{
    [topOptions setObject:[[NCIZoomGraphView alloc] init] forKey:nciGraphRenderer];
    _topChart = [[NCITopChartView alloc] initWithFrame:CGRectZero andOptions:topOptions];
    _topChart.chartData = self.chartData;
    _topChart.nciChart = self;
    _topChart.nciHasSelection = YES;
    _btmChart = [[NCIBtmChartView alloc] initWithFrame:CGRectZero andOptions:bottomOptions];
    _btmChart.chartData = self.chartData;
    _btmChart.nciHasSelection = NO;
    _btmChart.hasYLabels = NO;
    _btmChart.nciChart = self;
    [self addSubview:_topChart];
    [self addSubview:_btmChart];
}

- (void)addSubviews{

}

-(void)drawChart{
    [_topChart drawChart];
    [_btmChart drawChart];

}

- (void)setMinRangeVal:(double)minRangeVal{
    self.topChart.minRangeVal = minRangeVal;
}

- (void)setMaxRangeVal:(double)maxRangeVal{
    self.topChart.maxRangeVal = maxRangeVal;
}

- (double)maxRangeVal{
    return self.topChart.maxRangeVal;
}

- (double)minRangeVal{
    return self.topChart.minRangeVal;
}

- (void)resetChart{
    [self.chartData removeAllObjects];
}

- (void)layoutSubviews{
    _topChart.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - btmChartHeigth - chartsSpace);
    _btmChart.frame = CGRectMake(0, self.frame.size.height - btmChartHeigth, self.frame.size.width, btmChartHeigth);
}


@end
