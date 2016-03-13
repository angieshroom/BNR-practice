//
//  CAJDrawView.m
//  Doooodle
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 angieShroom. All rights reserved.
//

#import "CAJDrawView.h"
#import "CAJLine.h"

@interface CAJDrawView()
@property (nonatomic,strong)NSMutableDictionary *linesInProgress;
@property (nonatomic,strong)NSMutableArray *finishedLines;
@end

@implementation CAJDrawView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray  alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
    
}

- (void)strokeLine:(CAJLine *)line{
    
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth =  10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect{
    
    [[UIColor blackColor] set];
    for (CAJLine *line in self.finishedLines){
        [self strokeLine:line];
    }
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress){
        [self strokeLine:self.linesInProgress[key]];
    }

}


#pragma mark - Turning Touches into lines
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches){
        CGPoint location = [t locationInView:self];
        CAJLine *line = [[CAJLine  alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    [self setNeedsDisplay];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches){
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        CAJLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
          
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for (UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        CAJLine *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
        
    }
    
    
    [self setNeedsDisplay];
    
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

@end
