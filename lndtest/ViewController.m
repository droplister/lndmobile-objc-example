//
//  ViewController.m
//  lndtest
//
//  Created by Chris on 13/1/18.
//  Copyright © 2018 IndieSquare. All rights reserved.
//
#include <Lightning/Lightning.h>
#include <Lightning/Lightning.objc.h>
#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController


-(NSDictionary*)fromJSON:(NSString*)jsonString{
    
    NSError *jsonError;
    NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&jsonError];
    return json;
}

-(NSString*)toJSON:(NSDictionary*)dic{
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&err];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSError*)setConfig{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/Lnd/lnd.conf",
                          documentsDirectory];
    
    NSFileManager *fmngr = [[NSFileManager alloc] init];
    
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Lnd",
                                                           documentsDirectory]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error != nil) {
        NSLog(@"error creating directory: %@", error);
        //..
    }
    
    
    
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:fileName]) {
        
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:fileName error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lnd.conf" ofType:nil];
    
    
    
    NSError *error2;
    if(![fmngr copyItemAtPath:filePath toPath:fileName error:&error2]) {
        // handle the error
        return error2;
        
        
        
    }
     NSLog(@"added file to path %@", fileName);
    return NULL;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
   
 
}

-(IBAction)start:(id)sender{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeClient) name:UIApplicationWillEnterForegroundNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pauseClient) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    NSError * err = [self setConfig];
    if(err != NULL){
        NSLog(@"error setting config");
    }
    
 
  NSString* mnemonic = @"news flight okay blossom output goddess please sunset east yard axis view";
         
    
  
    err = NULL;
        
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
        LightningStart(documentsDirectory, mnemonic, &err);
  
    NSLog(@"ClientStart returned: %@", err);
 
   
}

-(IBAction)closeChannel{
    

    NSError * err = NULL;
    
    NSString *result = LightningCloseChannel(@"fe10116872ba0827e3b83a6ef7e73476d438e1c64c976fd2f8a7393ef793a754", 0, false, &err);
    
    NSLog(@"res %@",[self fromJSON:result]);
    
    //there seems to be no synchronized version of CloseChannel so no result will be returend
    
    
}
-(IBAction)getInfo:(id)sender{
     NSError * err = NULL;
   
    NSString *result = LightningGetInfo(&err);
    
    NSLog(@"res %@",[self fromJSON:result]);
    
}


-(IBAction)getWalletBalance:(id)sender{
    
    NSError * err = NULL;
    
    NSString *result = LightningWalletBalance(&err);
    
    NSLog(@"res %@",[self fromJSON:result]);
    
    
    
    
}


-(IBAction)listPeers:(id)sender{
    
    
    
    NSError * err = NULL;
    
    NSString *result = LightningListPeers(&err);
    
    if(err!=NULL){
        NSLog(@"res %@",[self fromJSON:result]);
    }
    
}
-(IBAction)openChannel:(id)sender{
    
    
    LightningOpenChannelHandler * mySub = LightningNewOpenChannelHandler();
    
    [mySub onUpdate:self];

    
    NSError * err = NULL;
    
     int64_t localFundingAmount = atoll([@"10000000" UTF8String]);
    
    NSString * peerhex= @"0270685ca81a8e4d4d01beec5781f4cc924684072ae52c507f8ebe9daf0caaab7b";
    
    [mySub onUpdate:self];
    
   
    NSString *result =LightningOpenChannel(peerhex, localFundingAmount, mySub, &err);
    
    if(err!=NULL){
        NSLog(@"res %@",[self fromJSON:result]);
    }
    
}


-(IBAction)generateAddress:(id)sender{
    
    
    NSError * err = NULL;
    
    //1 == NestedType
    //0 == Native Segwit
    NSString *result = LightningNewAddress(1,&err);
    
    NSLog(@"res %@",[self fromJSON:result]);
   
    
}
-(IBAction)sendPaymentSync:(id)sender{
    
    
    NSError * err = NULL;
    
    
    NSString *result = LightningSendPaymentSync(self.pr.text, &err);
    
    NSLog(@"res %@",[self fromJSON:result]);
    
    
}



-(IBAction)addPeer:(id)sender{
    
      NSLog(@"pressed");
    NSError * err = NULL;
    
    NSString *result = LightningConnectPeer(self.oc.text, &err);
    
    if(err == NULL){
    
        NSLog(@"res %@",[self fromJSON:result]);
        
        
    }
   
}

-(IBAction)getPendingChannels:(id)sender{
    
    
    NSError * err = NULL;
    
    NSString *result = LightningPendingChannels(&err);
    
    NSLog(@"res %@",[self fromJSON:result]);
    
 
    
}

-(IBAction)getChannels:(id)sender{
    
    
    
    NSError * err = NULL;
    
    NSString *result = LightningListChannels(&err);
    
    if(err != NULL){
         NSLog(@"err %@",err);
        return;
    }
    
     NSLog(@"res %@",result);
   
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
