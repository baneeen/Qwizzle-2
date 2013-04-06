//
//  Quiz.h
//  Qwizzle
//
//  Created by Baneeen AL Mubarak on 4/5/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Answer, Question;

@interface Quiz : NSManagedObject

@property (nonatomic, retain) NSDate * creation_date;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *answer_r;
@property (nonatomic, retain) NSSet *question_r;
@end

@interface Quiz (CoreDataGeneratedAccessors)

- (void)addAnswer_rObject:(Answer *)value;
- (void)removeAnswer_rObject:(Answer *)value;
- (void)addAnswer_r:(NSSet *)values;
- (void)removeAnswer_r:(NSSet *)values;

- (void)addQuestion_rObject:(Question *)value;
- (void)removeQuestion_rObject:(Question *)value;
- (void)addQuestion_r:(NSSet *)values;
- (void)removeQuestion_r:(NSSet *)values;

@end
