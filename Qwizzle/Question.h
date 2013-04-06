//
//  Question.h
//  Qwizzle
//
//  Created by Baneeen AL Mubarak on 4/5/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer;

@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * q_id;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) NSManagedObject *quiz_r;
@property (nonatomic, retain) NSSet *answer_r;
@end

@interface Question (CoreDataGeneratedAccessors)

- (void)addAnswer_rObject:(Answer *)value;
- (void)removeAnswer_rObject:(Answer *)value;
- (void)addAnswer_r:(NSSet *)values;
- (void)removeAnswer_r:(NSSet *)values;

@end
