//
//  CalculatorBrain.m
//  RpnCalculator
//
//  Created by Ruian Xu on 5/28/12.
//  Copyright (c) 2012 ruian.xu@gmail.com . All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if ( !_operandStack )
    {
        _operandStack = [[NSMutableArray alloc] init]; 
    }
    
    return _operandStack;
}

- (void)reset
{
    [self.operandStack removeAllObjects];
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];  
    [self.operandStack addObject:operandObject];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    
    if ( operandObject )
    {
        [self.operandStack removeLastObject];
    }
    
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
    
    if ( [operation isEqualToString:@"+"] )
    {
        result = [self popOperand] + [self popOperand];
    }
    else if ( [@"*" isEqualToString:operation] )
    {
        result = [self popOperand] * [self popOperand];
    }
    else if ( [@"-" isEqualToString:operation] )
    {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    }
    else if ( [@"/" isEqualToString:operation] )
    {
        double divisor = [self popOperand];
        if ( divisor )
        {
            result = [self popOperand] / divisor;
        }
    }
    else if ( [@"sin" isEqualToString:operation] )
    {
        // calculates the sine of the top operand on the stack
        result = sin( [self popOperand] );
    }
    else if ( [@"cos" isEqualToString:operation] )
    {
        // calculates the cosine of the top operand on the stack
        result = cos( [self popOperand] );
    }
    else if ( [@"sqrt" isEqualToString:operation] )
    {
        // calculates the square root of the top operand on the stack
        result = sqrt( [self popOperand] );
    }
    else if ( [@"π" isEqualToString:operation] )
    {
        // pi is special
        double pi = 3.1415926;
        [self pushOperand:pi];
        result = pi;
    }
    else if ( [@"+/-" isEqualToString:operation] )
    {
        result = -[self popOperand];
    }
    
    [self pushOperand:result];
    
    return result;
}

@end
