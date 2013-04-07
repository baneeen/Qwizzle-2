//
//  QWZViewAnswerViewController.h
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

#define OFFSET 40

@interface QWZViewQwizzleViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
}

// Hold a quiz set
@property (nonatomic, strong) QWZQuizSet *quizSet;

@property (nonatomic,strong) NSNumber *qwz_id; //hold the prameters passed from QWZQWZview

@end
