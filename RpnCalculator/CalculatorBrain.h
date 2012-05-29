//
//  CalculatorBrain.h
//  RpnCalculator
//
//  Created by Ruian Xu on 5/28/12.
//  Copyright (c) 2012 ruian.xu@gmail.com . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;

- (double)performOperation:(NSString *)operation;

- (double)popOperand;

@end
