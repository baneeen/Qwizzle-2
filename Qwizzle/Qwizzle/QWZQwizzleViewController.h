//
//  QWZViewController.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Quiz.h"
#import "Answer.h"
#import "Question.h"

@class QWZQuizSet;
@class QWZAnsweredQuizSet;

// QWZViewController can fill all 3 roles: view controller, data source, and delegate
// by implementing the following protocol: UITableViewDataSource and UITableViewDelegate.

// Implement UITableViewDelegate to set the label of the delete button
// Optional methods of the protocol allow the delegate to manage selections,
// configure section headings and footers, help to delete and reorder cells, and perform other actions...
@interface QWZQwizzleViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    // This array stores all quiz sets
    NSMutableArray *allQuizSets;
    
    // This array stores all answered quiz sets
    NSMutableArray *allAnsweredQuizSets;
    
    // Handle the selected quiz tapped by the user
    QWZQuizSet *selectedQuiz1;
    NSNumber *selectedQuiz;
    
    //this will stores titles for taken quiz
    NSArray *takenQuizSet;
    
    //this will stores titles for taken quiz
    NSArray *submitQuizSet;
  
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//- (void)submitAQwizzle:(QWZQuizSet *)qz;

- (void)fillOutAQwizzle:(QWZAnsweredQuizSet *)qzAnswers;

@end
