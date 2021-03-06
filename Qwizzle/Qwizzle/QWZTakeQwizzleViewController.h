//
//  QWZAnswerViewController.h
//  Qwizzle
//
//  Created by Krissada Dechokul on 3/22/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quiz.h"
#import "Question.h"
#import "Answer.h"

@class QWZQuizSet;
@class QWZAnsweredQuizSet;
@class QWZQwizzleViewController;

@interface QWZTakeQwizzleViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, weak) QWZQwizzleViewController *origin;
@property (nonatomic, strong) NSMutableArray *answerList;
@property (nonatomic, strong) NSMutableArray *controlList;
@property (nonatomic, strong) QWZQuizSet *quizSet;
@property (nonatomic, strong) QWZAnsweredQuizSet *answeredQuizSet;

@property (nonatomic,strong) NSNumber *qwz_id; //hold the prameters passed from QWZQWZview

- (IBAction)fillOutAQwizzle:(id)sender;


@end
