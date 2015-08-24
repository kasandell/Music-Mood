//
//  ViewController.m
//  MusicMood
//
//  Created by Kyle Sandell on 4/4/15.
//  Copyright (c) 2015 Kyle Sandell. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *ImFeelingPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *IWantToFeelPicker;
- (IBAction)saveValues:(id)sender;
@property (nonatomic, retain) UISwipeGestureRecognizer *kbDismiss;
@property (nonatomic, retain) NSArray *moods;
@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) UITextField *genreField;
@end


/*
 moods:
 1.	Joy/Appreciation/Empowered/Freedom/Love
 2.	Passion
 3.	Enthusiasm/Eagerness/Happiness
 4.	Positive Expectation/Belief
 5.	Optimism
 6.	Hopefulness
 7.	Contentment
 8.	Boredom
 9.	Pessimism
 10.	Frustration/Irritation/Impatience
 11.	Overwhelment
 12.	Disappointment
 13.	Doubt
 14.	Worry
 15.	Blame
 16.	Discouragement
 17.	Anger
 18.	Revenge
 19.	Hatred/Rage
 20.	Jealousy
 21.	Insecurity/Guilt/Unworthiness
 22.	Fear/Grief/Depression/Despair/Powerlessness
 */


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.defaults=[NSUserDefaults standardUserDefaults];
    self.kbDismiss=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRecognizer:)];
    self.moods=@[@"Joyous",@"Freedom",@"Love",@"Passionate",@"Enthusiastic",@"Eagerness",@"Happiness",@"Belief"/*,@"Positive Expectation"*/,@"Optimistic",@"Hopefulness",@"Contentment",@"Boredom",@"Pessimistic",@"Frustration",@"Irritation",@"Impatience",@"Overwhelmement",@"Dissapointment",@"Doubt",@"Worry",@"Blame",@"Discouragement",@"Anger",@"Revenge",@"Hatred",@"Rage",@"Jealousy",@"Insecurity",@"Guilt",@"Unworthiness",@"Fear",@"Grief",@"Depression",@"Despair",@"Powerlessness"];
    self.ImFeelingPicker.delegate=self;
    self.ImFeelingPicker.dataSource=self;
    
    self.IWantToFeelPicker.delegate=self;
    self.IWantToFeelPicker.dataSource=self;
    self.genreField=[[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width*.5)-40, self.view.frame.size.height*.75, 80, 20)];
    self.genreField.delegate=self;
    [self.genreField setText:@"Rock"];
    [self.view addSubview:self.genreField];
   // [self.view addGestureRecognizer:self.kbDismiss];
   // self.genreField.k
}
-(BOOL)textFieldShouldReturn:(UITextField *)field{
    [self.genreField resignFirstResponder];
    return NO;
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.moods.count;
}



// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.moods[row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//save values to nsuserdefaults for use later
- (IBAction)saveValues:(id)sender {
    NSString *picker1Value;
    NSString *picker2Value;
    picker1Value=[NSString stringWithString:[self.moods objectAtIndex:[self.ImFeelingPicker selectedRowInComponent:0]]];
    picker2Value=[NSString stringWithString:[self.moods objectAtIndex:[self.IWantToFeelPicker selectedRowInComponent:0]]];
    [self.defaults setObject:picker1Value forKey:@"Im Feeling"];
    [self.defaults setObject:picker2Value forKey:@"I Want To Feel"];
    [self.defaults setObject:self.moods forKey:@"Moods"];
    [self.defaults setObject:self.genreField.text forKey:@"Genre"];
    [self.defaults synchronize];
    //NSLog(@"%@, %@", picker1Value, picker2Value);
    //[self performSegueWithIdentifier:@"ShowPlayer" sender:self];
}
@end
