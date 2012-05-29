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
    self.userIsInTheMiddleOfEnteringAFloatingPointNumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if ( self.userIsInTheMiddleOfEnteringANumber )
    {
        self.history.text = [self.history.text stringByAppendingFormat:@" "];
        self.history.text = [self.history.text stringByAppendingString:sender.currentTitle];
        [self enterPressed];
    }
    
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result]; 
}

- (IBAction)dotPressed 
{
    // With a valid floating point #, there should be only 1 dot
    if ( !self.userIsInTheMiddleOfEnteringAFloatingPointNumber )
    {
        self.userIsInTheMiddleOfEnteringAFloatingPointNumber = YES;
        self.display.text = [self.display.text stringByAppendingFormat:@"."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
        
        self.history.text = [self.history.text stringByAppendingFormat:@"."];
    }
}


- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
