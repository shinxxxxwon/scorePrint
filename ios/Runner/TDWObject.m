//
//  objcSum.m
//  Runner
//
//  Created by 신정원 on 2023/02/23.
//


#import "TDWObject.h"
#import <Foundation/Foundation.h>


@interface TDWObject : NSObject

-(NSInteger)addNum:(NSInteger)num1 seconde:(NSInteger)num2;
-(NSInteger)loopSum:(NSInteger)num1;

@end

@implementation TDWObject

-(NSInteger)addNum:(NSInteger)num1 seconde:(NSInteger)num2{
    return num1 + num2;
}

-(NSInteger)loopSum:(NSInteger)num1{
    NSInteger res = 0;
    for(NSInteger index=0; index<10; index++)
    {
        res += index;
        printf("loop Sum! : %ld\n", (long)res);
    }
    return res;
}

int TDWObjcSum(int num1, int num2){
    TDWObject* tdwObject = [[TDWObject alloc]init];
//    int res = [tdwObject addNum:num1 seconde:num2];
    int res = [tdwObject loopSum:num1];
    printf("TDWbjcSum res : %d\n", res);
    [tdwObject release];
    
    return res;
}

@end
