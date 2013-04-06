//
//  Answer.h
//  Qwizzle
//
//  Created by Baneeen AL Mubarak on 4/5/13.
//  Copyright (c) 2013 Florida Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answer : NSManagedObject

@property (nonatomic, retain) NSNumber * a_id;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSString * postor;
@property (nonatomic, retain) NSNumber * q_id;
@property (nonatomic, retain) NSNumber * qwz_id;
@property (nonatomic, retain) NSManagedObject *quiz_r;
@property (nonatomic, retain) NSManagedObject *question_r;

@end
