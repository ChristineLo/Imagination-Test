//
//  DrawCanvasLayer.m
//  Test3D
//
//  Created by Mac06 on 12/12/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawCanvasLayer.h"

@implementation DrawCanvasLayer
@synthesize iDrawMode;
@synthesize activeLayer;

-(id) init {
    if (self = [super init])
    {
        panTouchArray = [[NSMutableArray alloc] init];
        eraseTouchArray = [[NSMutableArray alloc] init];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

-(id) initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h {
    if (self = [super initWithColor:color width:w height:h]) {
        panTouchArray = [[NSMutableArray alloc] init];
        eraseTouchArray = [[NSMutableArray alloc] init];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void)draw
{
    //if (self.isTouchEnabled) {
        //NSLog(@"draw");
        glEnable(GL_LINE_SMOOTH);
        glLineWidth(5.0f);
        
        glColor4f(0, 0, 0, 255);
        for(int i = 0; i < [panTouchArray count]; i+=2)
        {
            CGPoint start = CGPointFromString([panTouchArray objectAtIndex:i]);
            CGPoint end = CGPointFromString([panTouchArray objectAtIndex:i+1]);
            
            ccDrawLine(start, end);
        }
        
        glColor4f(255, 255, 255, 255);
        for(int i = 0; i < [eraseTouchArray count]; i+=2)
        {
            glLineWidth(20.0f);
            CGPoint start = CGPointFromString([eraseTouchArray objectAtIndex:i]);
            CGPoint end = CGPointFromString([eraseTouchArray objectAtIndex:i+1]);
            
            ccDrawLine(start, end);
        }
    //}
}

#pragma mark - GestureRecognizers

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Began mode:%d",iDrawMode);
    self.isTouchEnabled = NO;
    DrawCanvasLayer *layer = [[DrawCanvasLayer alloc] init];
    [self addChild:layer];
    
    activeLayer = layer;
    activeLayer.iDrawMode = iDrawMode;
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Ended");
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint new_location = [touch locationInView: [touch view]];
    new_location = [[CCDirector sharedDirector] convertToGL:new_location];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    // add my touches to the naughty touch array
    if (iDrawMode == EModeDrawPen) {
        NSLog(@"pen");
        [panTouchArray addObject:NSStringFromCGPoint(new_location)];
        [panTouchArray addObject:NSStringFromCGPoint(oldTouchLocation)];
    }
    else
    {
        NSLog(@"erase");
        [eraseTouchArray addObject:NSStringFromCGPoint(new_location)];
        [eraseTouchArray addObject:NSStringFromCGPoint(oldTouchLocation)];
    }
    
}

-(void) dealloc {
    [super dealloc];
    [panTouchArray dealloc];
    [eraseTouchArray dealloc];
}
@end
