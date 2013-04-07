//
//  QWZAnswerViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QWZAppDelegate.h"

#import "QWZQwizzleViewController.h"
#import "QWZTakeQwizzleViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"
#import "QWZAnsweredQuizSet.h"

#import "UIView+FindFirstResponder.h"

@interface QWZTakeQwizzleViewController ()
{
    NSManagedObjectContext *context;
    NSMutableArray *questionIDSet;
}
@end

@implementation QWZTakeQwizzleViewController

@synthesize origin; // The origin's viewcontroller: it is needed to pass data back
@synthesize quizSet;
@synthesize controlList;
@synthesize answerList;
@synthesize answeredQuizSet;
@synthesize qwz_id;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //for fetching/inserting ..
    QWZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    context =[delegate managedObjectContext];
    Quiz *quiz=[self getQuiz];

    
    // Do any additional setup after loading the view from its nib.
    NSLog(@"QWZTakeQwizzleViewController with a quizset %@", quiz.title );
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [scrollView addGestureRecognizer:tap];
    
    controlList = [[NSMutableArray alloc] init];
    questionIDSet=[[NSMutableArray alloc] init];
    answerList = [[NSMutableArray alloc] init];
    
    // Preparing UI - Create and configure programmatically
    CGRect titleFrame = CGRectMake(40, 10, 250, 60);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
  
    [titleLabel setText:[NSString stringWithFormat:@"Taking Qwizzle:\n %@",quiz.title ]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setNumberOfLines:2];
    [scrollView addSubview:titleLabel];
   
    NSArray *questionSet=[self getQuestionSet];
    NSInteger y = 100;
    

    for (Question *questionObj in questionSet)
    {
        
        NSString *qwzQuestion = questionObj.question;
        NSLog(@"question: %@", qwzQuestion);
        
        // store id's to be submitted with answers
        NSNumber *q_id=questionObj.q_id;
        [questionIDSet addObject:q_id];
        
        // Adding the text field for the question
        UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, y, 250, 60)];
        [questionLabel setText:[[NSString alloc] initWithFormat:@"%@", qwzQuestion]];
        [questionLabel setBackgroundColor:[UIColor clearColor]];
        [scrollView addSubview:questionLabel];
        
        // Adding the corresponding textfield for the first question
        UITextView *answerField = [[UITextView alloc] initWithFrame:CGRectMake(40, y + 50, 250, 60)];
        [answerField setScrollsToTop:true];
        [answerField setDelegate:self];
        answerField.layer.borderWidth = 2.0f;
        answerField.layer.borderColor = [[UIColor grayColor] CGColor];
        [controlList addObject:answerField]; // We will need the reference later
        [scrollView addSubview:answerField];
        
        y += 100;
    }
}
#pragma getQuiz
- (Quiz *)getQuiz
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
[fetchRequest setEntity:entity];

NSPredicate *predicate = [NSPredicate predicateWithFormat:@"qwz_id == %d", [qwz_id intValue]];
[fetchRequest setPredicate:predicate];

NSError *error = nil;
    Quiz *fetchedObj = [[context executeFetchRequest:fetchRequest error:&error]lastObject];
if (fetchedObj == nil) {
    NSLog(@"Cannnot fetch for a quiz!");
}
   
    return fetchedObj;
    
}
- (NSArray *)getQuestionSet
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Question" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"qwz_id == %d", [qwz_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObj = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObj == nil) {
        NSLog(@"Cannnot fetch for a questions!");
    }
    
    return fetchedObj;
    
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
-(NSInteger)getAnswerID{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answer" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSInteger a_id;
    if (fetchedObjects == nil) {
        NSLog(@"NULL Questions fetched data");
        a_id=1;
    }else {
        a_id=(fetchedObjects.count+1);
        
    }
    return a_id;
    
}
- (IBAction)fillOutAQwizzle:(id)sender
{
    NSLog(@"Submitting qwizzle answers....");
    
      
    
    NSError *errror;
    NSInteger a_id=[self getAnswerID];
    
    
    // Validate code may go here
    NSInteger emptyCount = 0;
    for (NSInteger i = 0; i < [controlList count]; i++) {
      
        // to be add to entity
        NSEntityDescription *enitty = [NSEntityDescription entityForName:@"Answer" inManagedObjectContext:context];
        NSManagedObject *mangedObj=[[NSManagedObject alloc]initWithEntity:enitty insertIntoManagedObjectContext:context];

        NSLog(@"%d of %d) %@", i, [controlList count], [[controlList objectAtIndex:i] text]);
        
        NSString *text = [[controlList objectAtIndex:i] text];
        if (text == nil || [text isEqualToString:@""]) {
            NSLog(@"Empty cell detected!");
            emptyCount++;
        }
        else {
            NSLog(@"Answer detected!: %@", [text copy]);
            
        [mangedObj setValue:text forKey:@"answer"];
        [mangedObj setValue:[NSNumber numberWithInt:((a_id+i)-emptyCount)] forKey:@"a_id"];
        [mangedObj setValue:[questionIDSet objectAtIndex:i] forKey:@"q_id"];
        [mangedObj setValue:qwz_id forKey:@"qwz_id"];
        
            //[answerList addObject:[text copy]];
        }
        [context save:&errror];
        
    }
   
    if (emptyCount > 0) {
        // All empty
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You should fill out some answers before you go." delegate:nil  cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
   /* else {
        NSLog(@"answerList: %@", answerList);
    
        answeredQuizSet = [[QWZAnsweredQuizSet alloc] initWithTitle:[quizSet title]];
        for (NSInteger i = 0; i < [answerList count]; i++) {
            // Add a new item to the answered quiz set with the original question and the given answer
            NSLog(@"getting the question: %@", [[[quizSet allQuizzes] objectAtIndex:i] question]);
            [answeredQuizSet addQuiz:[[QWZQuiz alloc] initWithQuestion:[[[quizSet allQuizzes] objectAtIndex:i] question] answer:[answerList objectAtIndex:i]]];*/
       // } 

        // Submit a qwizzle to parents' viewcontroller
        [origin fetchSubmitQuiz];
        
        // Dismiss this view
        [self.navigationController popViewControllerAnimated:YES];
        //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Get the current origin of the textfield
    CGPoint point = textView.frame.origin ;
    point.x = 0;
    point.y = point.y - 115; // adjust the position just to accommodate the keyboard
    [scrollView setContentOffset:point animated:YES]; // Move the scrollView to the position
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
