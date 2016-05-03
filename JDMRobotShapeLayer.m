//
//  JDMRobotShapeLayer.m
//  CAShapeLayerTest
//
//  Created by Justin Madewell on 7/27/15.
//  Copyright © 2015 Justin Madewell. All rights reserved.
//

#import "JDMRobotShapeLayer.h"

@interface JDMRobotShapeLayer ()
@property (nonatomic, strong) CAShapeLayer *_eyeLayer;
@property (nonatomic, strong) CAShapeLayer *_faceLayer;
@property (nonatomic, strong) UIColor *_faceColor;
@property CGPoint _eyeballCenter;


@end

@implementation JDMRobotShapeLayer

+(JDMRobotShapeLayer*)faceLayer
{
    JDMRobotShapeLayer *faceLayer = [self layer];
    
    [faceLayer makeFaceLayer];
    
    return faceLayer;
    
}



#pragma mark - From Original 


-(CAShapeLayer*)makeFaceLayer
{
    // Config Layer
    CGFloat faceWidth = ScreenWidth() ;
    CGFloat faceHeight = faceWidth / 1.333;
    CGSize faceSize = CGSizeMake(faceWidth, faceHeight);
    CGRect faceRect = CGRectMake(0, 0, faceSize.width, faceSize.height);
    
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithRoundedRect:faceRect cornerRadius:faceRect.size.width/8];
    
    UIColor *randomColor = [UIColor colorWithRed:randomFloat(0, 1) green:randomFloat(0, 1) blue:randomFloat(0, 1) alpha:1.0];
    __faceColor = randomColor;
    
    UIColor *shapeColor = __faceColor; //[UIColor yellowColor];
    
    UIColor *strokeColor = [UIColor blackColor];
    
    // Make Layer
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.path = shapePath.CGPath;
    shapelayer.fillColor = shapeColor.CGColor;
    shapelayer.strokeColor = strokeColor.CGColor;
    
    // Make Mask Layer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = shapePath.CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    
    shapelayer.mask = maskLayer;
    
    // Eyes
    [self addEyesToLayer:shapelayer];
    [self addMouthToLayer:shapelayer];
    
    [self addSublayer:shapelayer];
    
    CGPoint newPosition;
    
    CGRect shapeRect = PathBoundingBox(shapePath);

    
    CGPoint centerPoint = RectGetCenter(ScreenRect());
    
    newPosition = CGPointMake(centerPoint.x - shapeRect.size.width/2, centerPoint.y - shapeRect.size.height/2);
    
    
    shapelayer.position = newPosition;
    
    
    __faceLayer = shapelayer;
    
    return shapelayer;
    
}

-(CAShapeLayer*)getLayerNamed:(NSString*)name
{
    NSArray *subLayers = __faceLayer.sublayers;
    
    CAShapeLayer *desiredLayer;
    
    for (CAShapeLayer *sublayer in subLayers) {
        if ([sublayer.name isEqualToString:name]) {
            desiredLayer = sublayer;
            return desiredLayer;
        }
    }
    
    return desiredLayer;
}


-(CAShapeLayer*)eyeLayerWithSize:(CGSize)eyeSize
{
    // Config Layer
    CGRect eyeRect = CGRectMake(0, 0, eyeSize.width, eyeSize.height);
    
    UIBezierPath *shapePath = [UIBezierPath bezierPathWithOvalInRect:eyeRect];
    UIColor *shapeColor = [UIColor whiteColor];
    UIColor *strokeColor = [UIColor blackColor];
    
    // Make Layer
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.path = shapePath.CGPath;
    shapelayer.fillColor = shapeColor.CGColor;
    shapelayer.strokeColor = strokeColor.CGColor;
    
    // Make Mask Layer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = shapePath.CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    maskLayer.strokeColor = [UIColor blackColor].CGColor;
    
    shapelayer.mask = maskLayer;
    
    return shapelayer;
    
}


UIBezierPath* FrownPath()
{
    CGFloat startAngle = -30;
    CGFloat endAngle = 210;
    
    CGFloat faceWidth = ScreenWidth() ;
    CGFloat faceHeight = faceWidth / 1.333;
    
    CGFloat radius = faceHeight/4;
    
    CGRect arcRect = CGRectMake(0, 0, radius/2, radius/2);
    
    CGPoint arcCenter = RectGetCenter(arcRect);
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:RadiansFromDegrees(startAngle) endAngle:RadiansFromDegrees(endAngle) clockwise:NO];
    return arcPath;
}



UIBezierPath* SmilePath()
{
    UIBezierPath *smilePath = FrownPath();
    
    ApplyCenteredPathTransform(smilePath, CGAffineTransformMakeRotation(RadiansFromDegrees(180)));
    
    return smilePath;
    
}

UIBezierPath* MouthPath()
{
    UIBezierPath *mouthPath = [UIBezierPath bezierPath];
    
    CGFloat width = ScreenWidth() / 3;
    CGRect mouthRect = CGRectMake(0, 0, width, width);
    
    CGPoint startPoint = RectGetTopLeft(mouthRect);
    CGPoint endPoint = RectGetTopRight(mouthRect);
    
    
    [mouthPath moveToPoint:startPoint];
    [mouthPath addLineToPoint:endPoint];
    
    mouthPath.lineCapStyle = kCGLineCapRound;
    mouthPath.lineWidth = 8;
    
    
    return mouthPath;
    
}


UIBezierPath* NewMouthPath()
{
    UIBezierPath *new = MouthPath();
    
    ApplyCenteredPathTransform(new, CGAffineTransformMakeRotation(RadiansFromDegrees(10)));
    
    return new;
}



-(void)addMouthToLayer:(CAShapeLayer*)layer
{
    CGRect workRect = PathBoundingBox([UIBezierPath bezierPathWithCGPath:layer.path]);
    CGPoint faceCenter = RectGetCenter(workRect);
    CGPoint mouthCenter = CGPointMake(faceCenter.x, faceCenter.y + (faceCenter.y/2));
    
    UIBezierPath *shapePath;
    shapePath = MouthPath();
    
    CGRect shapeBox = PathBoundingBox(shapePath);
    CGSize mouthSize = PathBoundingBox(shapePath).size;
    CGPoint mouthPosition = CGPointMake((mouthCenter.x - shapeBox.origin.x) - mouthSize.width/2, (mouthCenter.y - shapeBox.origin.y) + mouthSize.height/8);
    
    UIColor *shapeColor = [UIColor clearColor];
    UIColor *strokeColor = [UIColor blackColor];
    
    // Make Layer
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.path = shapePath.CGPath;
    shapelayer.fillColor = shapeColor.CGColor;
    shapelayer.strokeColor = strokeColor.CGColor;
    shapelayer.lineWidth = 8.0;
    shapelayer.lineCap = kCALineCapRound;
    
    shapelayer.name = @"mouth";
    shapelayer.position =  mouthPosition;
    
    [layer addSublayer:shapelayer];
    
}

-(CGPoint)getPositionForMouthPath:(UIBezierPath*)mouthPath
{
    CGRect pathRect = PathBoundingBox(mouthPath);
    
    // Conversions
    CGRect workRect = PathBoundingBox([UIBezierPath bezierPathWithCGPath:__faceLayer.path]);
    CGPoint faceCenter = RectGetCenter(workRect);
    CGPoint mouthCenter = CGPointMake(faceCenter.x, faceCenter.y + (faceCenter.y/2));
    CGSize mouthSize = pathRect.size;
    CGPoint mouthPosition = CGPointMake((mouthCenter.x - pathRect.origin.x) - mouthSize.width/2, (mouthCenter.y - pathRect.origin.y) + mouthSize.height/8);
    
    return mouthPosition;
    
}


-(void)animateMouthToPath:(UIBezierPath*)newPath withDuration:(CGFloat)duration
{
    CAShapeLayer *mouthLayer = [self getLayerNamed:@"mouth"];
    
    UIBezierPath *startPath = [UIBezierPath bezierPathWithCGPath:mouthLayer.path];
    UIBezierPath *endPath = newPath;
    
    CGPoint startPosition = mouthLayer.position;
    CGPoint endPosition = [self getPositionForMouthPath:endPath];
    
    // change the model
    mouthLayer.path = endPath.CGPath;
    mouthLayer.position = endPosition;
    
    CABasicAnimation *mouthChangeAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    mouthChangeAnimation.duration = duration;
    mouthChangeAnimation.fromValue = (__bridge id _Nullable)(startPath.CGPath);
    mouthChangeAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    mouthChangeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *mouthMoveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    mouthMoveAnimation.duration = duration;
    mouthMoveAnimation.fromValue = [NSValue valueWithCGPoint:startPosition];
    mouthMoveAnimation.toValue = [NSValue valueWithCGPoint:endPosition];
    mouthMoveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *mouthGroupAnimation = [CAAnimationGroup animation];
    mouthGroupAnimation.animations = @[mouthChangeAnimation,mouthMoveAnimation];
    mouthGroupAnimation.duration = duration;
    
    [mouthLayer addAnimation:mouthGroupAnimation forKey:@"mouthGroup"];
}


-(void)wiggleMouth
{
    CAShapeLayer *mouthLayer = [self getLayerNamed:@"mouth"];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.5;
    
    animation.additive = YES;
    
    [mouthLayer addAnimation:animation forKey:@"shake"];
}

-(void)toggleMouthAnimation
{
    CGFloat duration = 0.34;
    duration = 0.5;
    
    static int checker;
    
    if (checker>4) {checker=0;}
    
    switch (checker) {
        case 0:
            [self animateMouthToPath:SmilePath() withDuration:duration];
            break;
        case 1:
            [self animateMouthToPath:MouthPath() withDuration:duration];
            break;
        case 2:
            [self animateMouthToPath:FrownPath() withDuration:duration];
            break;
        case 3:
            [self animateMouthToPath:MouthPath() withDuration:duration];
            break;
        case 4:
            [self wiggleMouth];
            break;
            
        default:
            break;
    }
    
    checker++;
}




-(void)addEyesToLayer:(CAShapeLayer*)layer
{
    CGRect workRect = PathBoundingBox([UIBezierPath bezierPathWithCGPath:layer.path]);
    
    CGFloat eyeHeight =  workRect.size.height / 2.189;
    CGFloat eyeWidth = eyeHeight / 1.75;
    
    CGSize newEyeSize = CGSizeMake(eyeWidth, eyeHeight);
    
    // setup Eye
    CGSize eyeSize = CGSizeMake(200, 350);
    eyeSize = newEyeSize;
    
    // Rect Logic
    CGRect faceRect = workRect;
    
    CGSize quadRectSize = CGSizeMake(faceRect.size.width/2, faceRect.size.height/2);
    
    CGRect rectA = CGRectMake( RectGetTopLeft(faceRect).x ,RectGetTopLeft(faceRect).y ,quadRectSize.width, quadRectSize.height);
    CGRect rectB = CGRectMake( RectGetMidTop(faceRect).x ,  RectGetMidTop(faceRect).y , quadRectSize.width, quadRectSize.height);
    
    CGPoint leftEyePosition = CGPointMake(RectGetCenter(rectA).x - eyeSize.width/2 , RectGetCenter(rectA).y - eyeSize.height/4);
    CGPoint rightEyePosition = CGPointMake(RectGetCenter(rectB).x - eyeSize.width/2 , RectGetCenter(rectB).y - eyeSize.height/4);
    
    
    CAShapeLayer *leftEyeLayer = [self eyeLayerWithSize:eyeSize];
    leftEyeLayer.name = @"leftEye";
    CAShapeLayer *rightEyeLayer = [self eyeLayerWithSize:eyeSize];
    rightEyeLayer.name = @"rightEye";
    
    [self addEyelidsToLayer:rightEyeLayer];
    [self addEyeballToLayer:rightEyeLayer];
    
    [self addEyelidsToLayer:leftEyeLayer];
    [self addEyeballToLayer:leftEyeLayer];
    
    
    // Add the EyeLayer to calling layer
    [layer addSublayer:leftEyeLayer];
    [layer addSublayer:rightEyeLayer];
    
    rightEyeLayer.position = rightEyePosition;
    leftEyeLayer.position = leftEyePosition;
    
}


-(void)addEyelidsToLayer:(CAShapeLayer*)layer
{
    // this will be the rectangle in which we make all calulation from
    // in order to get the information we need to ask the shape layer for its bezierPath, well CGPath, then wrap it inside a UIBezier call in order to use a conveience call to get the retangle surrounding the path.
    CGRect workRect = PathBoundingBox([UIBezierPath bezierPathWithCGPath:layer.path]);
    
    UIColor *eyelidColor = [UIColor blackColor];
    eyelidColor = __faceColor; //[UIColor yellowColor];
    
    CGFloat largerRectSide = workRect.size.height;
    if (workRect.size.height < workRect.size.width) {
        largerRectSide = workRect.size.width;
    }
    
    CGFloat startThickness = 0.5;
    
    CGRect bottomRect = CGRectMake(0, 0, workRect.size.width, startThickness);
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithRect:bottomRect];
    
    CGRect topRect = CGRectMake(0, 0, workRect.size.width, startThickness);
    UIBezierPath *topPath = [UIBezierPath bezierPathWithRect:topRect];
    
    
    CGPoint topPos = CGPointMake(RectGetMidBottom(workRect).x , RectGetMidBottom(workRect).y + 1.0);
    
    CGPoint bottomPos = CGPointMake(RectGetMidTop(workRect).x , RectGetMidTop(workRect).y - 1.0);
    
    CAShapeLayer *bottomEyelid = [CAShapeLayer layer];
    bottomEyelid.name = [@"" stringByAppendingFormat:@"%@_%@",layer.name,@"bottomEyelid"];
    bottomEyelid.bounds = bottomRect;
    bottomEyelid.position = bottomPos;
    bottomEyelid.strokeColor = eyelidColor.CGColor;
    
    bottomEyelid.path = bottomPath.CGPath;
    
    CAShapeLayer *topEyelid = [CAShapeLayer layer];
    topEyelid.name = [@"" stringByAppendingFormat:@"%@_%@",layer.name,@"topEyelid"];
    topEyelid.bounds = topRect;
    topEyelid.position = topPos;
    topEyelid.strokeColor = eyelidColor.CGColor;
    topEyelid.path = topPath.CGPath;
    
    [layer addSublayer:topEyelid];
    [layer addSublayer:bottomEyelid];
}

-(void)addEyeballToLayer:(CAShapeLayer*)layer
{
    // Config
    CGRect workRect = PathBoundingBox([UIBezierPath bezierPathWithCGPath:layer.path]);
    CGFloat eyeballSize = ( workRect.size.width * 0.25 );
    CGRect eyeballRect = CGRectMake(0, 0, eyeballSize, eyeballSize);
    UIBezierPath *eyeballPath = [UIBezierPath bezierPathWithOvalInRect:eyeballRect];
    
    UIColor *eyeballColor = [UIColor blackColor];
    
    CGPoint wC = RectGetCenter(workRect);
    CGPoint eyeballPosition = CGPointMake(wC.x-eyeballSize/2, wC.y-eyeballSize/2);
    
    __eyeballCenter = eyeballPosition;
    
    CAShapeLayer *eyeballLayer = [CAShapeLayer layer];
    eyeballLayer.name = [@"" stringByAppendingFormat:@"%@_%@",layer.name,@"eyeball"];
    eyeballLayer.path = eyeballPath.CGPath;
    eyeballLayer.fillColor = eyeballColor.CGColor;
    eyeballLayer.strokeColor = eyeballColor.CGColor;
    eyeballLayer.position = eyeballPosition;
    
    [layer addSublayer:eyeballLayer];
    
}

#pragma mark - Animations
#pragma mark - Eyeball Movement


-(void)makeAndAddNewRandomEyeballMovement:(CAShapeLayer*)layer
{
    // make random
    CGFloat movementDuration = randomFloat(0.1, 0.6);
    
    CGPoint startPoint = layer.position;
    CGPoint endPoint = [self findNewPointFromPoint:startPoint];
    
    layer.position = endPoint;
    
    CABasicAnimation *moveEyeballAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveEyeballAnimation.duration = movementDuration;
    moveEyeballAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    moveEyeballAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    moveEyeballAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}


-(void)aninmate
{
    [self moveEyesLeftAndRight];
}


-(void)moveEyesLeftAndRight
{
    CAShapeLayer *leftEye = [self getLayerNamed:@"leftEye"];
    CAShapeLayer *rightEye = [self getLayerNamed:@"rightEye"];
    
    CAShapeLayer *leftEyeball = (CAShapeLayer*)[[leftEye sublayers] objectAtIndex:2];
    CAShapeLayer *rightEyeball = (CAShapeLayer*)[[rightEye sublayers] objectAtIndex:2];
    
    CGFloat duration = 0.5;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setCompletionBlock:^{
            [CATransaction begin];
            [CATransaction setAnimationDuration:duration];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
            [CATransaction setCompletionBlock:^{
                [self newBlinkCall];
            }];
            {
                [leftEyeball addAnimation:[self moveEyeball:leftEyeball toCenterAnimation:duration] forKey:@"leftcenter"];
                [rightEyeball addAnimation:[self moveEyeball:rightEyeball toCenterAnimation:duration] forKey:@"rightcenter"];
                [self toggleMouthAnimation];
                
            }
            [CATransaction commit];
        }];
        {
            [leftEyeball addAnimation:[self moveEyeball:leftEyeball toRight:duration] forKey:@"leftright"];
            [rightEyeball addAnimation:[self moveEyeball:rightEyeball toRight:duration] forKey:@"rightright"];
            [self newBlinkCall];
        }
        [CATransaction commit];
    }];
    {
        [leftEyeball addAnimation:[self moveEyeball:leftEyeball toLeft:duration] forKey:@"leftleft"];
        [rightEyeball addAnimation:[self moveEyeball:rightEyeball toLeft:duration] forKey:@"rightleft"];
    }
    [CATransaction commit];
    
}








#pragma mark - Animation Helpers

#pragma mark - Eyeball Basic Animations

-(CABasicAnimation*)moveEyeball:(CAShapeLayer*)layer toLeft:(CGFloat)duration
{
    CAShapeLayer *eyeballLayer = layer;
    
    CGFloat movementDuration = duration;
    
    CGPoint leftPoint = CGPointMake(0, __eyeballCenter.y) ;
    
    CGPoint startPoint = eyeballLayer.position;
    CGPoint endPoint = leftPoint;
    
    eyeballLayer.position = endPoint;
    
    CABasicAnimation *moveEyeballAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveEyeballAnimation.duration = movementDuration;
    moveEyeballAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    moveEyeballAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    moveEyeballAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return moveEyeballAnimation;
    
}


-(CABasicAnimation*)moveEyeball:(CAShapeLayer*)layer toRight:(CGFloat)duration
{
    CAShapeLayer *eyeballLayer = layer;
    
    CGFloat movementDuration = duration;
    CGPoint rightPoint = CGPointMake(__eyeballCenter.x*2, __eyeballCenter.y) ;
    
    CGPoint startPoint = eyeballLayer.position;
    CGPoint endPoint = rightPoint;
    
    eyeballLayer.position = endPoint;
    
    CABasicAnimation *moveEyeballAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveEyeballAnimation.duration = movementDuration;
    moveEyeballAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    moveEyeballAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    moveEyeballAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return moveEyeballAnimation;
    
}


-(CABasicAnimation*)randomEyeball:(CAShapeLayer*)layer movementAnimation:(CGFloat)duration
{
    CAShapeLayer *eyeballLayer = layer;
    
    CGFloat movementDuration = duration;
    
    CGPoint startPoint = eyeballLayer.position;
    CGPoint endPoint = [self findNewPointFromPoint:startPoint];
    
    eyeballLayer.position = endPoint;
    
    CABasicAnimation *moveEyeballAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveEyeballAnimation.duration = movementDuration;
    moveEyeballAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    moveEyeballAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    moveEyeballAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return moveEyeballAnimation;
}

-(CABasicAnimation*)moveEyeball:(CAShapeLayer*)layer toCenterAnimation:(CGFloat)duration
{
    CAShapeLayer *eyeballLayer = layer;
    
    CGFloat movementDuration = duration;
    
    CGPoint startPoint = eyeballLayer.position;
    CGPoint endPoint = __eyeballCenter;
    
    eyeballLayer.position = endPoint;
    
    CABasicAnimation *moveEyeballAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveEyeballAnimation.duration = movementDuration;
    moveEyeballAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    moveEyeballAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    moveEyeballAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    return moveEyeballAnimation;
    
}


#pragma mark - Eyeball Movement
-(CGPoint)findNewPointFromPoint:(CGPoint)currentPoint
{
    CGPoint newPoint;
    
    CGPoint movementPoint = [self newEyeballPoint:30];
    
    newPoint.x = movementPoint.x + currentPoint.x ;
    newPoint.y = movementPoint.y + currentPoint.y ;
    
    return newPoint;
}

-(CGPoint)newEyeballPoint:(CGFloat)range
{
    
    CGFloat x = randomFloat(1.0, range);
    CGFloat y = randomFloat(1.0, range);
    
    if (randomBool()) {
        x = x * -1;
    }
    
    if (randomBool()) {
        y = y * -1;
    }
    
    return CGPointMake(x, y);
}






#pragma mark - Blink Animation
-(void)newBlinkCall
{
    [self blinkLeftEye];
    [self blinkRightEye];
}

-(void)blinkLeftEye
{
    CAShapeLayer *leftEye = [self getLayerNamed:@"leftEye"];
    [self blinkAnimationForLayer:leftEye];
}

-(void)blinkRightEye
{
    CAShapeLayer *rightEye = [self getLayerNamed:@"rightEye"];
    [self blinkAnimationForLayer:rightEye];
}

-(void)blinkAnimationForLayer:(CAShapeLayer*)layer
{
    CAShapeLayer *topEyelid = (CAShapeLayer*)[[layer sublayers] objectAtIndex:0];
    CAShapeLayer *bottomEyelid = (CAShapeLayer*)[[layer sublayers] objectAtIndex:1];
    
    CGRect workRect = PathBoundingBox([UIBezierPath bezierPathWithCGPath:layer.path]);
    
    CGFloat largerRectSide = workRect.size.height;
    if (workRect.size.height < workRect.size.width) {
        largerRectSide = workRect.size.width;
    }
    
    CGFloat startThickness = 0.5;
    CGFloat endThickness = largerRectSide+1.0;
    
    // ANIMATION
    
    CGFloat closeDuration = 0.125;
    CGFloat openDuration = 0.125;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:openDuration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setCompletionBlock:^{
        [CATransaction begin];
        [CATransaction setAnimationDuration:closeDuration];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        {
            // Eye Open
            // change back the model value
            topEyelid.lineWidth = startThickness;
            bottomEyelid.lineWidth = startThickness;
            
            CABasicAnimation *topEyeOpen = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
            topEyeOpen.duration = openDuration;
            topEyeOpen.fromValue = @(endThickness);
            topEyeOpen.toValue = @(startThickness);
            topEyeOpen.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            CABasicAnimation *bottomEyeOpen = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
            bottomEyeOpen.duration = openDuration;
            bottomEyeOpen.fromValue = @(endThickness);
            bottomEyeOpen.toValue = @(startThickness);
            bottomEyeOpen.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            
            [bottomEyelid addAnimation:bottomEyeOpen forKey:bottomEyeOpen.keyPath];
            [topEyelid addAnimation:topEyeOpen forKey:topEyeOpen.keyPath];
            
        }
        [CATransaction commit];
    }];
    {
        // Eye Close
        // change the model value first
        topEyelid.lineWidth = endThickness;
        bottomEyelid.lineWidth = endThickness;
        
        CABasicAnimation *topEyeClose = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        topEyeClose.duration = closeDuration;
        topEyeClose.fromValue = @(startThickness);
        topEyeClose.toValue = @(endThickness);
        topEyeClose.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CABasicAnimation *bottomEyeClose = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
        bottomEyeClose.duration = closeDuration;
        bottomEyeClose.fromValue = @(startThickness);
        bottomEyeClose.toValue = @(endThickness);
        bottomEyeClose.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [bottomEyelid addAnimation:bottomEyeClose forKey:bottomEyeClose.keyPath];
        [topEyelid addAnimation:topEyeClose forKey:topEyeClose.keyPath];
    }
    [CATransaction commit];
    
}






@end
