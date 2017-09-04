//
//  WALAwaitingFinalStateHandler.m
//  WalleeSDK
//
//  Created by Daniel Schmid on 04.09.17.
//  Copyright © 2017 smoca AG. All rights reserved.
//

#import "WALAwaitingFinalStateHandler.h"
#import "WALTransaction.h"

@interface WALAwaitingFinalStateHandler ()
@property (nonatomic, copy) WALTransaction *transaction;
@end

@implementation WALAwaitingFinalStateHandler

+ (instancetype)stateWithParameters:(NSDictionary *)parameters {
    return [self stateWithTransaction:parameters[WALFlowTransactionParameter]];
}

+ (instancetype)stateWithTransaction:(WALTransaction *)transaction {
    if (!transaction) {
        return nil;
    }
    return [[self alloc]initWithTransaction:transaction];
}

- (instancetype)initWithTransaction:(WALTransaction *)transaction {
    if (self = [super init]) {
        _transaction = transaction;
    }
    return self;
}
@end
