//
//  Question.h
//  Qwizzle
//
//  Created by Baneeen AL Mubarak on 4/7/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Quiz;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * q_id;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) NSSet *answer_r;
@property (nonatomic, retain) Quiz *quiz_r;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswer_rObject:(Answer *)value;
- (void)removeAnswer_rObject:(Answer *)value;
- (void)addAnswer_r:(NSSet *)values;
- (void)removeAnswer_r:(NSSet *)values;

@end
