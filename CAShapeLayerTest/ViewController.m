//
//  ViewController.m
//  CAShapeLayerTest
//
//  Created by Justin Madewell on 7/23/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


@property (nonatomic, strong) UIView *_screenView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      __screenView = [[UIView alloc]initWithFrame:ScreenRect()];
    [self.view addSubview:__screenView];
    
    [self performAnimation];
    
    
}




#pragma mark - CALayer

// It doesn't matter what my path is. I could make it anything I wanted.


- (void)gearStrokeAnimation
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = PathMakeGear(__screenView.frame, 24, 0.2, YES);
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 1.5f;
    shapeLayer.lineJoin = kCALineJoinBevel;
    
    [__screenView.layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3.0;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}


- (void)gearStrokeAnimationForLayer:(CALayer*)layer
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = PathMakeGear(__screenView.frame, 18, 0.2, YES);
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 1.5f;
    shapeLayer.lineJoin = kCALineJoinBevel;
    
    [layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3.5;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}







// line width call
-(void)lineWidthAnimationForLayer:(CALayer*)layer
{
    CGRect workRect = [layer superlayer].frame;
    CGPoint center = RectGetCenter(workRect);
    
    CGFloat largerRectSide = workRect.size.height;
    if (workRect.size.height < workRect.size.width) {
        largerRectSide = workRect.size.width;
    }
    
    CGFloat startThickness = 1.0;
    CGFloat endThickness = largerRectSide * 2;
    
    CGRect rect = CGRectMake(0, 0,workRect.size.width, startThickness);
    
    CAShapeLayer *lineWidthLayer = [CAShapeLayer layer];
    lineWidthLayer.bounds = rect;
    lineWidthLayer.position = center;
    
    lineWidthLayer.strokeColor = [UIColor blueColor].CGColor;
    
    lineWidthLayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    
    [layer addSublayer:lineWidthLayer];
    
    // change the model
    lineWidthLayer.lineWidth = endThickness;
    
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.duration = 1.5;
    lineWidthAnimation.fromValue = @(startThickness);
    lineWidthAnimation.toValue = @(endThickness);
    lineWidthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [lineWidthLayer addAnimation:lineWidthAnimation forKey:lineWidthAnimation.keyPath];
}


-(void)fillAnimationForLayer:(CALayer*)layer
{
    CGRect workRect = [layer superlayer].frame;
    CGPoint center = RectGetCenter(workRect);
    
    CGFloat largerRectSide = workRect.size.height;
    if (workRect.size.height < workRect.size.width) {
        largerRectSide = workRect.size.width;
    }
    
    CGFloat circleSize = largerRectSide * 2;
    
    CGSize startSize = CGSizeMake(1, 1);
    CGSize endSize = CGSizeMake(circleSize,circleSize);
    
    UIBezierPath *startShape = [UIBezierPath bezierPathWithRoundedRect:RectAroundCenter(center, startSize) cornerRadius:startSize.width/2];
    UIBezierPath *endShape = [UIBezierPath bezierPathWithRoundedRect:RectAroundCenter(center, endSize) cornerRadius:endSize.width/2];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor yellowColor].CGColor;
    shapeLayer.path = startShape.CGPath;
    
    [layer addSublayer:shapeLayer];
    
    // change the model
    shapeLayer.path = endShape.CGPath;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue =  (__bridge id _Nullable)(startShape.CGPath);
    pathAnimation.toValue = (__bridge id _Nullable)(endShape.CGPath);
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [shapeLayer addAnimation:pathAnimation forKey:@"pathFill"];
    

}

-(void)lineWidthAnimation
{
    
    CGRect rect =CGRectMake(0, 0,__screenView.frame.size.width, 1.0);
    
    CAShapeLayer *lineWidthLayer = [CAShapeLayer layer];
    lineWidthLayer.bounds = rect;
    lineWidthLayer.position = __screenView.center;
    
    lineWidthLayer.strokeColor = [UIColor blueColor].CGColor;
    
    lineWidthLayer.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    
    [__screenView.layer addSublayer:lineWidthLayer];
    
    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.duration = 1.5;
    lineWidthAnimation.toValue = @((ScreenLarger() *2));
    lineWidthAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    lineWidthAnimation.fillMode = kCAFillModeBoth;
//    lineWidthAnimation.removedOnCompletion = false;
    
    [lineWidthLayer addAnimation:lineWidthAnimation forKey:lineWidthAnimation.keyPath];

}

-(void)strokeAnimationForLayer:(CALayer*)layer
{
    
    CGRect circleRect = RectAroundCenter(__screenView.center, CGSizeMake(ScreenWidth()/2, ScreenWidth()/2));
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:circleRect].CGPath;
    
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.5;
    
    // Add
    [layer addSublayer:shapeLayer];
    
    
    CABasicAnimation *startStrokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    startStrokeAnimation.toValue = @(0.7);
    
    CABasicAnimation *endStrokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endStrokeAnimation.toValue = @(1.0);

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[startStrokeAnimation,endStrokeAnimation];
    groupAnimation.duration = 1.5;
    groupAnimation.autoreverses = YES;
    groupAnimation.repeatCount = HUGE;
    
    [shapeLayer addAnimation:groupAnimation forKey:@"rotation"];
}

-(void)rotatingGear
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIColor *endColor = [UIColor orangeColor];
    UIColor *startColor = [UIColor clearColor];
    
    UIBezierPath *path = PathMakeGear(__screenView.frame, 18, 0.2, YES);
    shapeLayer.path = [path CGPath];
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    shapeLayer.strokeColor = [[UIColor grayColor] CGColor];
    shapeLayer.fillColor = startColor.CGColor;
    shapeLayer.lineWidth = 1.5f;
    shapeLayer.lineJoin = kCALineJoinBevel;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:2.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setCompletionBlock:^{
        
        CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        spinAnimation.byValue = [NSNumber numberWithFloat:2.0f*M_PI];
        spinAnimation.duration = 10;
        spinAnimation.autoreverses = NO;
        spinAnimation.repeatCount = HUGE;
        
        [__screenView.layer addAnimation:spinAnimation forKey:spinAnimation.keyPath];
    }];
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:3.0];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [CATransaction setCompletionBlock:^{
            // Complete
            CABasicAnimation *fillShapeAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
            fillShapeAnimation.duration = 1.0;
            fillShapeAnimation.fromValue = (id)startColor.CGColor;
            fillShapeAnimation.toValue =(id)endColor.CGColor;
            fillShapeAnimation.fillMode = kCAFillModeBoth;
            fillShapeAnimation.removedOnCompletion = NO;
            
            [shapeLayer addAnimation:fillShapeAnimation forKey:fillShapeAnimation.keyPath];
        }];
        {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.fromValue = @(0.0f);
            pathAnimation.toValue = @(1.0f);
            [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        }
        [CATransaction commit];

    }
    
    [CATransaction commit];
   
    
    [__screenView.layer addSublayer:shapeLayer];
    
}



-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    
}

-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self performAnimation];
}

-(void)performAnimation
{
    static int counter;
    
    if (counter > 4) {
        counter = 0;
        __screenView.layer.sublayers = @[];
        [__screenView.layer removeAllAnimations];
    }
    
    switch (counter) {
        case 0:
            [self gearStrokeAnimationForLayer:__screenView.layer];
            break;
        case 1:
            [self fillAnimationForLayer:__screenView.layer];
            break;
        case 2:
            [self lineWidthAnimationForLayer:__screenView.layer];
            break;
        case 3:
            [self strokeAnimationForLayer:__screenView.layer];
            break;
        case 4:
            __screenView.layer.sublayers = @[];
            [self rotatingGear];
            break;
            
        default:
            break;
    }
    
    
    counter++;

}


-(void)handleTouch
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
