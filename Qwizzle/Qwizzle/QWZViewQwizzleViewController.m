//
//  QWZViewAnswerViewController.m
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import "QWZViewQwizzleViewController.h"
#import "QWZQuiz.h"
#import "QWZQuizSet.h"
#import "QWZAppDelegate.h"

@interface QWZViewQwizzleViewController ()
{
    NSManagedObjectContext *context;
 
}
@end

@implementation QWZViewQwizzleViewController

@synthesize quizSet;
@synthesize qwz_id;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//        // Every viewcontroller has this navigationItem property
//        UINavigationItem *n = [self navigationItem];
//        [n setTitle:@"Answered Qwizzle"];
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSLog(@"QWZViewQwizzleViewController with a quizset %@", [quizSet title]);
    //NSLog(@"This quizset have %d questions", [[quizSet allQuizzes] count]);
    //for fetching/inserting ..
    QWZAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    context =[delegate managedObjectContext];
   
    //Quiz *quiz=[self getQuiz];
    NSArray *questionSet =[self getQuestionSet];
    NSArray *answerSet =[self getAnswerSet];
    
    
    // For each quiz
   // QWZQuiz *quiz;
    CGFloat position;
    CGFloat latestHeight;
    UILabel *label;
 

    
    NSInteger i=0;
    for (Question *questionObj in questionSet)
    {
       
       // quiz = [[quizSet allQuizzes] objectAtIndex:i];
        
        if (i == 0) { // Set initial position
            position = (i + 1) * OFFSET;
        }
        else { // Otherwise, set the position by the latest bound
            position = latestHeight + OFFSET;
        }
        
        //////// Preparing a label for a question
        
        CGRect labelFrame = CGRectMake(20, position, 250, 30);
        label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setText:[NSString stringWithFormat:@"%d.) %@", (i + 1), questionObj.question]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label sizeToFit];
        
        // Getting the label's height
        CGSize labelSize = [label.text sizeWithFont:label.font
                                  constrainedToSize:label.frame.size
                                      lineBreakMode:NSLineBreakByWordWrapping];
        latestHeight = labelSize.height + position;
        [scrollView addSubview:label];

        //////// Preparing the label for an answer
        
        position = latestHeight + 10; // Move just a little bit
        labelFrame = CGRectMake(40, position, 250, 30);
        label = [[UILabel alloc] initWithFrame:labelFrame];
        Answer *answer= [answerSet objectAtIndex:i];
        [label setText:[[NSString alloc] initWithFormat:@"%@", answer.answer]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label sizeToFit];
        
        labelSize = [label.text sizeWithFont:label.font
                                  constrainedToSize:label.frame.size
                                      lineBreakMode:NSLineBreakByWordWrapping];
        latestHeight = labelSize.height + position;

        [scrollView addSubview:label];
        
        NSLog(@"question: %@ - answer %@", questionObj, answer.answer);
    }
    
    [scrollView setContentSize:CGSizeMake(320, latestHeight + 20)];
    //for (QWZQuiz *quiz in [quizSet allQuizzes]) {
        
    //}
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
-(NSArray *)getAnswerSet
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Answer" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"qwz_id == %d", [qwz_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObj = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObj == nil) {
        NSLog(@"Cannnot fetch for a answers!");
    }
    
    return fetchedObj;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
