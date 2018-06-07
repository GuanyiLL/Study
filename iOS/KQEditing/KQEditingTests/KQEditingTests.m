//
//  KQEditingTests.m
//  KQEditingTests
//
//  Created by Guanyi on 2018/6/4.
//  Copyright © 2018 yiguan. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface KQEditingTests : XCTestCase

@end

@implementation KQEditingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    for (NSInteger i = 0; i < 5000; i++) {
        NSInteger hours = i / 3600;
        NSInteger minutes = i / 60 % 60;
        NSInteger seconds = i % 60;
        NSString *time = [NSString stringWithFormat:@"%zd:%zd:%zd",hours,minutes,seconds];
        NSLog(@"%@",time);
    }
}

- (void)testResource {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *configJSON =[NSString stringWithFormat:@"%@/hanfumei-800/config.json", resourcePath];
    NSData *data = [NSData dataWithContentsOfFile:configJSON];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
