//
//  QWZCreateViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZCreateQwizzleViewController.h"
#import "QWZQwizzleViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"
#import "QWZAppDelegate.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"

#import "UIView+FindFirstResponder.h"

@interface QWZCreateQwizzleViewController ()
{
    NSManagedObjectContext *context;
}

@end

@implementation QWZCreateQwizzleViewController

@synthesize origin; // The origin's viewcontroller: it is needed to pass data back
@synthesize controlList;
//@synthesize questionList;
//@synthesize quizSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //for fetching/inserting ..
    QWZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    context =[delegate managedObjectContext];
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    // Preparing UI - Create and configure programmatically
    CGRect titleFrame = CGRectMake(20, 40, 50, 30);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
    [titleLabel setText:[[NSString alloc] initWithFormat:@"Title:"]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:titleLabel];
    
    CGRect fieldFrame = CGRectMake(70, 40, 230, 30);
    UITextField *titleField= [[UITextField alloc] initWithFrame:fieldFrame];
    [titleField setBorderStyle:UITextBorderStyleRoundedRect];
    [titleField setPlaceholder:@"Title for your Qwizzle"];
    [titleField setDelegate:self];
    [titleField setTag:25]; // For refenrencing: could any number
    [scrollView addSubview:titleField];

    // Krissada: Begin the dynamic part...
    x = 20;
    y = 85;
    textWidth = 25;
    textHeight = 30;
    fieldWidth = 255;
    fieldHeight = textHeight;
    fieldTextDistance = 25;
    
    buttonWidth = 280;
    buttonHeight = 40;
    buttonFormDistance = 40;
    
    eachQuestionDistances = 45;
    
    controlList = [[NSMutableArray alloc] init];
   // questionList = [[NSMutableArray alloc] init];
    
    // Adding the first textfield for the first question
    CGRect numberBulletFrame = CGRectMake(x, y, textWidth, textHeight);
    UILabel *numberBulletLabel = [[UILabel alloc] initWithFrame:numberBulletFrame];
    [numberBulletLabel setText:[[NSString alloc] initWithFormat:@"%d.", ([controlList count] + 1)]];
    [numberBulletLabel setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:numberBulletLabel];
    
    // Adding the corresponding textfield for the first question
    CGRect questionFrame = CGRectMake((x + fieldTextDistance), y, fieldWidth, fieldHeight);
    UITextField *questionField = [[UITextField alloc] initWithFrame:questionFrame];
    [questionField setBorderStyle:UITextBorderStyleRoundedRect];
    [questionField setPlaceholder:@"What's your question?"];
    [questionField setDelegate:self];
    [controlList addObject:questionField]; // We will need the reference later
    [scrollView addSubview:questionField];
    
    // Adding the add more question button
    CGRect buttonFrame = CGRectMake(x, (y + buttonFormDistance), buttonWidth, buttonHeight);
    insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [insertButton setFrame:buttonFrame];
    [insertButton addTarget:self
                     action:@selector(addMoreQuestion:)
           forControlEvents:UIControlEventTouchUpInside];
    [insertButton setTitle:@"Add more question"
                  forState:UIControlStateNormal];
    
    [insertButton setTag:50]; // For refenrencing: could any number
    [scrollView addSubview:insertButton];
    
    // Set content size of the scroll view to make it scrollable
    scrollviewWidth = 320;
    scrollviewHeight = 175;
    [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyboardNotifications];
}

// Dynamically add more UIView for questions
- (void)addMoreQuestion:(id)sender
{
    [self dismissKeyboard];
    
    // If it does not reach the limit, then add more questions
    if ([controlList count] < MAX_NUMBEROFQUESTIONS) { 
        // Adjust the distance between controls
        y = y + eachQuestionDistances;

        // Add the controls
        CGRect numberBulletFrame = CGRectMake(x, y, textWidth, textHeight);
        UILabel *numberBulletLabel = [[UILabel alloc] initWithFrame:numberBulletFrame];
        [numberBulletLabel setText:[[NSString alloc] initWithFormat:@"%d.", ([controlList count] + 1)]];
        [numberBulletLabel setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:numberBulletLabel];
        
        CGRect questionFrame = CGRectMake((x + fieldTextDistance), y, fieldWidth, fieldHeight);
        UITextField *questionField = [[UITextField alloc] initWithFrame:questionFrame];
        [questionField setBorderStyle:UITextBorderStyleRoundedRect];
        [questionField setPlaceholder:@"What's your question?"];
        [questionField setDelegate:self];
        [controlList addObject:questionField]; // We will need the reference later
        [scrollView addSubview:questionField];
        
        // Adjust the position of the add more question button
        CGRect newButtonFrame = CGRectMake(x, (y + buttonFormDistance), buttonWidth, buttonHeight);
        [[scrollView viewWithTag:50] setFrame:newButtonFrame];
        
        scrollviewHeight = scrollviewHeight + eachQuestionDistances;
        [scrollView setContentSize:CGSizeMake(scrollviewWidth, scrollviewHeight)];
        
        // If the number of control reached the maximum number defined, hide the add more button
        if ([controlList count] == MAX_NUMBEROFQUESTIONS) {
            [[scrollView viewWithTag:50] setHidden:YES];
            
            CGRect warningFrame = [[scrollView viewWithTag:50] frame];
            UILabel *warningLabel = [[UILabel alloc] initWithFrame:warningFrame];
            [warningLabel setText:[[NSString alloc] initWithFormat:@"The maximun of %d questions reached", MAX_NUMBEROFQUESTIONS]];
            [warningLabel setBackgroundColor:[UIColor clearColor]];
            [scrollView addSubview:warningLabel];
        }
    }
    else { // Otherwise, display a warning and hide the button
        NSLog(@"No more than %d, Mister!!", MAX_NUMBEROFQUESTIONS);
    }
}
#pragma submit
//get the last record nubmer ...
-(NSInteger)getQuizID{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSInteger qwz_id;
    if (fetchedObjects == nil) {
        NSLog(@"NULL Quiz fetched data");
        qwz_id=1;
    }else {
        qwz_id=(fetchedObjects.count+1);
        
    }
    return qwz_id;
    
}
//get last record nubmer for question
-(NSInteger)getQuestionID{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSInteger q_id;
    if (fetchedObjects == nil) {
        NSLog(@"NULL Questions fetched data");
        q_id=1;
    }else {
        q_id=(fetchedObjects.count+1);
        
    }
    return q_id;
    
}

// CreateNewQuiz will create a new quiz, should check & validate every question here.
- (IBAction)submitAQwizzle:(id)sender
{
    
        NSLog(@"Submitting a Qwizzle, validation in process");
        
        NSInteger qwz_id=[self getQuizID];
         NSLog(@"Quiz id reqest success");
        NSInteger q_id=[self getQuestionID];
        NSLog(@"question id reqest success");
    
    NSMutableArray *questionSet=[[NSMutableArray alloc] init];
    
        
               
        //set title for quiz entity
        UITextField *title = (UITextField *)[scrollView viewWithTag:25];
        NSString *titleText = [title text];        
        NSError *error = nil;
        
        
        
          NSLog(@"quiz add success");
        // Validate code may go here
        NSInteger emptyCount = 0;
        
        for (NSInteger i = 0; i < [controlList count]; i++) {
            NSLog(@"%d of %d) %@", i, [controlList count], [[controlList objectAtIndex:i] text]);
            
            NSString *text = [[controlList objectAtIndex:i] text];
            [questionSet addObject:text];
            if (text == nil || [text isEqualToString:@""]) {
                NSLog(@"Empty cell detected!");
                emptyCount++;
            }
            else {
                NSLog(@"Question detected!: %@", [text copy]);
               
                           }
        }
        
        
         if (emptyCount < 0) {
        // It's all empty, show some alert
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You should add some question before you go." delegate:self.view cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         
         }
         else {
         //NSLog(@"questionList: %@", questionList);
         
         UITextField *title = (UITextField *)[scrollView viewWithTag:25];
         NSString *titleText = [title text];
         if (titleText == nil || [titleText isEqualToString:@""]) {
         
         
         // quizSet = [[QWZQuizSet alloc] init];
         }
         else {
             //to be add to quiz entity
             NSEntityDescription *quizEntity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
             
             NSManagedObject *quizObj=[[NSManagedObject alloc]initWithEntity:quizEntity insertIntoManagedObjectContext:context];
             //set qwz id
             [quizObj setValue:[NSNumber numberWithInt:qwz_id]  forKey:@"qwz_id"];
             
             [quizObj setValue:titleText forKey:@"title"];
             //add quiz
             
             [context save:&error];

        // quizSet = [[QWZQuizSet alloc] initWithTitle:[titleText copy]];
         }
         
         
         //added by core data
         for (NSInteger i = 0; i < [questionSet count]; i++) {
         //[quizSet addQuiz:[[QWZQuiz alloc] initWithQuestion:[questionList objectAtIndex:i]]];
             
             //establish question obj for insert
             NSEntityDescription *questionEntity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:context];
             NSManagedObject *questionObj=[[NSManagedObject alloc]initWithEntity:questionEntity insertIntoManagedObjectContext:context];
             
             //set quiz id
             [questionObj setValue:[NSNumber numberWithInt:qwz_id]  forKey:@"qwz_id"];
             
             //set question id
             [questionObj setValue:[NSNumber numberWithInt:((q_id+i)-emptyCount)]  forKey:@"q_id"];
             
             [questionObj setValue:[questionSet objectAtIndex:i] forKey:@"question"];
             //[questionList addObject:[text copy]];
             
             //add question
             [context save:&error];

         }
         
        
        // Submit a qwizzle to parents' viewcontroller
    
        [origin fetchTakenQuiz];
  
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
    }
}
- (IBAction)cancel:(id)sender
{
    // Dismiss this dialog
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyboard
{
    UIView *view = [scrollView findFirstResponder];
    [view resignFirstResponder];
}

#pragma mark handling keyboard
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    NSLog(@"Registering for Keyboard Notification");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)removeKeyboardNotifications
{
    NSLog(@"Removeing for Keyboard Notification");
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // Getting the keyboard's size
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Getting the scrollView height and add it with the keyboard's height
    CGRect currentFrame = [scrollView frame];
    currentFrame.size.height += keyboardSize.height;
    
    // Make the scrollView bigger
    [scrollView setContentSize:CGSizeMake(currentFrame.size.width, currentFrame.size.height)];
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Getting the keyboard's size
    NSDictionary* info = [aNotification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Getting the current scrollView height and minus it with the keyboard's height
    CGRect currentFrame = [scrollView frame];
    currentFrame.size.height -= keyboardSize.height;
    
    // Resize the scrollView back to the original
    [scrollView setContentSize:CGSizeMake(currentFrame.size.width, currentFrame.size.height)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Get the current origin of the textfield
    CGPoint point = textField.frame.origin ;
    point.x = 0;
    point.y = point.y - 115; // adjust the position just to accommodate the keyboard
    [scrollView setContentOffset:point animated:YES]; // Move the scrollView to the position
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
