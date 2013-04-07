//
//  Answer.h
//  Qwizzle
//
//  Created by Baneeen AL Mubarak on 4/7/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question, Quiz;

@interface Answer : NSManagedObject

@property (nonatomic, retain) NSNumber * a_id;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSString * postor;
@property (nonatomic, retain) NSNumber * q_id;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) Quiz *question_r;
@property (nonatomic, retain) Question *quiz_r;

@end
