//
//  ViewController.m
//  ZapposCalculator
//
//  Created by Yash Dalal on 2/4/16.
//  Copyright © 2016 Yash Dalal. All rights reserved.
//  This app does some math. Experiment with as much addition, subtraction, multiplication and division.
//  Both positive and negative numbers are supported

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController (){
    AVAudioPlayer *_audioPlayer;
}

@end

@implementation ViewController
NSMutableString *firstNum;
NSMutableString *secondNum;

bool operatorPressed = NO;
bool firstClick = YES;
bool evaluated = NO;
bool nextIsOperator = NO;
int count = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    firstNum = [[NSMutableString alloc]init];
    secondNum = [[NSMutableString alloc]init];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hello" ofType:@"mp3"];
    NSURL *soundFile = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clearTextFields:(id)sender{
    val1.text=@"";
    ans.text=@"";
    [self resetValues];
}

- (void) resetValues{
    firstNum = [[NSMutableString alloc]init];
    secondNum = [[NSMutableString alloc]init];
    currentOperation = NONE;
    operatorPressed = NO;
    firstClick = YES;
}


-(IBAction)numberEntered:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    [self firstClickReset];
    
    if(!operatorPressed){
        [firstNum appendString: button.currentTitle] ;
        val1.text = firstNum;
    }else{
        [secondNum appendString: button.currentTitle] ;
        val1.text = secondNum;
    }
    count++;
}

-(void) firstClickReset{
    if(firstClick){
        [self resetValues];
        val1.text=@"";
        ans.text=@"";
        firstClick = NO;
    }
}

-(IBAction)delete:(id)sender{
    if(!operatorPressed){
        firstNum = [self deleteLastChar:firstNum];
        val1.text = firstNum;
    }else{
        secondNum = [self deleteLastChar:secondNum];
        val1.text = secondNum;
    }
}

-(NSMutableString*)deleteLastChar: (NSMutableString*)currentNum{
    if ([currentNum length] > 0) {
        NSRange range = NSMakeRange([currentNum length]-1,1);
        [currentNum replaceCharactersInRange:range withString:@""];
    }
    return currentNum;
}

-(IBAction)addSelected:(id)sender{
    if(operatorPressed){
        [self evaluate];
    }
    if(evaluated){
        firstClick = NO;
    }
    currentOperation=ADD;
    ans.text = [NSString stringWithFormat:@"%@ + ", firstNum];
    val1.text = @"";
    operatorPressed = YES;
    count++;
}

-(IBAction)subtractSelected:(id)sender{
    //negative numbers
    if([val1.text isEqualToString: @""]){
        [self firstClickReset];
        if(!operatorPressed){
            [firstNum appendString: @"-"] ;
            val1.text = firstNum;
        }else{
            [secondNum appendString: @"-"] ;
            val1.text = secondNum;
        }
    }else{
        //regular subtraction
        if(operatorPressed){
            [self evaluate];
        }
        if(evaluated){
            firstClick = NO;
        }
        currentOperation=SUBTRACT;
        ans.text = [NSString stringWithFormat:@"%@ - ", val1.text];
        val1.text = @"";
        operatorPressed = YES;
    }
}

-(IBAction)multiplySelected:(id)sender{
    if(operatorPressed){
        [self evaluate];
    }
    if(evaluated){
        firstClick = NO;
    }
    currentOperation=MULTIPLY;
    ans.text = [NSString stringWithFormat:@"%@ × ", val1.text];
    val1.text = @"";
    operatorPressed = YES;
    
    count++;
}

-(IBAction)divideSelected:(id)sender{
    if(operatorPressed){
        [self evaluate];
    }
    if(evaluated){
        firstClick = NO;
    }
    currentOperation=DIVIDE;
    ans.text = [NSString stringWithFormat:@"%@ / ", val1.text];
    val1.text = @"";
    operatorPressed = YES;
}

-(void)drawAdele{
    UIGraphicsBeginImageContext(bgview.frame.size);
    [[UIImage imageNamed:@"adele1.jpg"] drawInRect:bgview.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    bgview.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(IBAction)calculate:(id)sender{
    [self evaluate];
    evaluated = YES;
    operatorPressed = NO;
    firstClick = YES;
}

-(void) evaluate{
    double int1 = [firstNum doubleValue];
    double int2 = [secondNum doubleValue];
    double answer = 0.0;
    
    switch (currentOperation){
        case NONE:
            answer = [firstNum intValue];
            //add message here
            break;
        case ADD:
            answer = int1 + int2;
            firstNum = [NSMutableString stringWithFormat:@"%g",answer];
            secondNum = [NSMutableString stringWithString:@""];
            break;
        case SUBTRACT:
            answer = int1 - int2;
            firstNum = [NSMutableString stringWithFormat:@"%g",answer];
            secondNum = [NSMutableString stringWithString:@""];
            break;
        case MULTIPLY:
            answer = int1 * int2;
            firstNum = [NSMutableString stringWithFormat:@"%g",answer];
            secondNum = [NSMutableString stringWithString:@""];
            break;
        case DIVIDE:
            if(int2!=0){
                answer = int1 / int2;
                firstNum = [NSMutableString stringWithFormat:@"%g",answer];
                secondNum = [NSMutableString stringWithString:@""];
            }
            break;
    }
    
    ans.text = [NSString stringWithFormat:@"%@%@", ans.text, val1.text];
    if(int2==0 && operatorPressed){
        val1.text = [NSString stringWithFormat: @"Not Defined"];
    }else{
        val1.text = [NSString stringWithFormat: @"%g",answer];
    }
    
    if([val1.text isEqualToString:@"25"]||[val1.text isEqualToString:@"21"]||[val1.text isEqualToString:@"19"]){
        bgview.alpha = 0.3;
        [self drawAdele];
    }else{
        bgview.backgroundColor = [UIColor colorWithRed:0.39607 green:0.39607 blue:0.39607 alpha:1];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:NO];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {

}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake )
    {
        [_audioPlayer play];
        [UIView animateWithDuration:6 delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{ adele.alpha = 1;}
                         completion:^(BOOL finished){
                             if (finished) {
                                 [UIView animateWithDuration:6 delay:0 options:UIViewAnimationOptionCurveEaseIn
                                                  animations:^{ adele.alpha = 0;}
                                                  completion:nil];
                             }
                         }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
