//
//  CalculatorViewController.m
//  RpnCalculator
//
//  Created by Ruian Xu on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringAFloatingPointNumber;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize brain = _brain;
@synthesize userIsInTheMiddleOfEnteringAFloatingPointNumber = _userIsInTheMiddleOfEnteringAFloatingPointNumber;

@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;

- (CalculatorBrain *)brain
{
    if ( !_brain )
    {
        _brain = [[CalculatorBrain alloc] init];
    }
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
//    NSLog( @"user touched button %@", digit );
    
    if ( self.userIsInTheMiddleOfEnteringANumber )
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else
    {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
    self.history.text = [self.history.text stringByAppendingFormat:digit];
}

- (IBAction)enterPressed 
{
    NSLog( @"operand pushed: %f", [self.display.text doubleValue] );
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    self.history.text = [self.history.text stringByAppendingFormat:@" "];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    //    self.userIsInTheMiddleOfEnteringAFloatingPointNumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if ( self.userIsInTheMiddleOfEnteringANumber )
    {
        self.history.text = [self.history.text stringByAppendingFormat:@" "];
        self.history.text = [self.history.text stringByAppendingString:sender.currentTitle];
        self.history.text = [self.history.text stringByAppendingFormat:@" = "];
        [self enterPressed];
    }
    
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result]; 
}

- (IBAction)dotPressed 
{
    [self enterPressed];
    
    // With a valid floating point #, there should be only 1 dot
    if ( !self.userIsInTheMiddleOfEnteringAFloatingPointNumber )
    {
        self.userIsInTheMiddleOfEnteringAFloatingPointNumber = YES;
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
        
        self.history.text = [self.history.text stringByAppendingFormat:@"0."];
    }
}

- (IBAction)clearPressed 
{
    // clear the view
    self.display.text = @"";
    self.history.text = @"";
    
    self.userIsInTheMiddleOfEnteringAFloatingPointNumber = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    // ask the brain to reset too
    [self.brain reset];
}

/// "backspace" button
- (IBAction)delPressed
{
    // "backspace" only takes effect when user is in the middle of entering a number
    if ( self.userIsInTheMiddleOfEnteringANumber )
    {
        NSString *currentNumber = self.display.text;
        int length = [currentNumber length];
        if ( ( length > 0 ) && ![currentNumber isEqualToString:@"0"] )
        {
            self.display.text = [currentNumber substringToIndex:length - 1];
            
            // If this is the last one that is deleted, update the dispaly with "0"
            if ( 0 == length - 1 )
            {
                self.display.text = @"0";
                self.userIsInTheMiddleOfEnteringANumber = NO;
            }
        }
    }
}

- (IBAction)changeSignPressed:(UIButton *)sender 
{
    if ( self.userIsInTheMiddleOfEnteringANumber )
    {
        NSString *currentNumber = self.display.text;
        // If the current # the user is entering has a "-"(minus value)
        if ( [@"-" isEqualToString:[currentNumber substringToIndex:1]] )
        {
            self.display.text = [currentNumber substringFromIndex:1];
        }
        else
        {
            self.display.text = [@"-" stringByAppendingString:currentNumber];
        }
    }
    else
    {
        [self operationPressed:sender];
    }
}

@end
