//
//  FactClass.h
//  Funfacts
//
//  Created by Vipin V on 27/03/14.
//  Copyright (c) 2014 vipin. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface FactClass : NSObject{
    NSString *factid,*fact,*category;
        NSMutableArray *dataset;
    NSMutableString *currentElementData;
    id currentElement;
}
@property (nonatomic,retain)NSString *factid,*fact,*category;


@property(nonatomic,retain)NSMutableArray *dataset;



@end
