//
//  ISIrisElementLayer.m
//  IrisViewDemo
//
//  Created by yoyokko on 11-2-25.
//  Copyright 2011 yoyokko@gmail.com. All rights reserved.
//

#import "ISIrisElementLayer.h"

double Y_Coordinates(double x,double y,double k,double x0)
{
	return k * x0 - k * x + y;
}

CGPoint Circle_Center(CGPoint p1, CGPoint p2, double dRadius, BOOL isFirst)
{
	double k = 0.0,k_verticle = 0.0;
	double mid_x = 0.0,mid_y = 0.0;
	double a = 1.0;
	double b = 1.0;
	double c = 1.0;
	CGPoint center1, center2;
	k = (p2.y - p1.y) / (p2.x - p1.x);
	if(k == 0)
	{
		center1.x = (p1.x + p2.x) / 2.0;
		center2.x = (p1.x + p2.x) / 2.0;
		center1.y = p1.y + sqrt(dRadius * dRadius -(p1.x - p2.x) * (p1.x - p2.x) / 4.0);
		center2.y = p2.y - sqrt(dRadius * dRadius -(p1.x - p2.x) * (p1.x - p2.x) / 4.0);
	}
	else
	{
		k_verticle = -1.0 / k;
		mid_x = (p1.x + p2.x) / 2.0;
		mid_y = (p1.y + p2.y) / 2.0;
		a = 1.0 + k_verticle * k_verticle;
		b = -2 * mid_x - k_verticle * k_verticle * (p1.x + p2.x);
		c = mid_x * mid_x + k_verticle * k_verticle * (p1.x + p2.x) * (p1.x + p2.x) / 4.0 - 
        (dRadius * dRadius - ((mid_x - p1.x) * (mid_x - p1.x) + (mid_y - p1.y) * (mid_y - p1.y)));
		
		center1.x = (-1.0 * b + sqrt(b * b -4 * a * c)) / (2 * a);
		center2.x = (-1.0 * b - sqrt(b * b -4 * a * c)) / (2 * a);
		center1.y = Y_Coordinates(mid_x,mid_y,k_verticle,center1.x);
		center2.y = Y_Coordinates(mid_x,mid_y,k_verticle,center2.x);
	}
    
	if (isFirst)
    {
        return center1;
    }
    return center2;
}

#define A 0.133974586f
#define B 0.292893218f


@implementation ISIrisElementLayer

@synthesize layerIndex = layerIndex_;

- (CGPoint) originAtIndex:(int) i
               withRadius:(CGFloat) radius
          withCenterPoint:(CGPoint) center
                withAngle:(double) angle
{
	CGPoint origin = CGPointMake(center.x, center.y - radius);
	origin.x = origin.x - sin(angle*i)*radius;
	origin.y = origin.y + radius - cos(angle*i)*radius;
	return origin;
}

- (void) resetTransform
{
    self.hidden = NO;
        
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, (layerIndex_+1) * M_PI_4, 0.0, 0.0, -1.0);
    self.transform = transform;
    transform = CATransform3DRotate(transform, M_PI/120, 0, 0, 1.0);
    self.transform = transform;
}

- (void) drawInContext:(CGContextRef) context
{
    CGRect bounds = self.bounds;
    CGRect rect = bounds;
    CGFloat radius = rect.size.height;
    
    CGPoint p1 = CGPointMake(A * radius, bounds.size.height);
    CGPoint p2 = CGPointMake(A * radius, 0);
    CGPoint p3 = CGPointMake(bounds.size.width, B * radius);

    CGContextSetFillColorWithColor(context, [UIColor colorWithPatternImage:[UIImage imageNamed:@"is_camera_iris_background.png"]].CGColor);
    
    if (layerIndex_ == 8)
    {
        CGContextBeginPath(context);
        CGPoint center = Circle_Center(p1, p3, radius, YES);
        CGContextAddArc(context, center.x, center.y, radius, M_PI*13.0/12, M_PI*17/12, 0);
        CGContextAddArc(context, p1.x, p1.y, radius, -M_PI/4, -M_PI/2, 1);
        CGContextClosePath(context);
        
        CGContextSetShadowWithColor(context, CGSizeMake(5, 0), 5, [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor);
    }
    else
    {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, p1.x, p1.y);
        CGPoint center = Circle_Center(p1, p3, radius, YES);
        CGContextAddArc(context, center.x, center.y, radius, M_PI+M_PI/12, M_PI*17/12, 0);
        CGContextAddArc(context, p1.x, p1.y, radius, -M_PI/4, -M_PI/2, 1);
        center = Circle_Center(p2, p1, radius, YES);
        CGContextAddArc(context, center.x, center.y, radius, -M_PI*5/6, M_PI*5/6, 1);
        CGContextClosePath(context);
        
        CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 10, [[UIColor blackColor] colorWithAlphaComponent:0.6+0.05*layerIndex_].CGColor);
    }
    
    CGContextFillPath(context);
}

@end
