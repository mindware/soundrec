//
//  SoundRecViewController.m
//  SoundRec
//
//  Created by ANDRES COLON on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SoundRecViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import <CoreAudio/CoreAudioTypes.h>
//#import <AudioToolbox/AudioToolbox.h>


@interface SoundRecViewController ()

@end

@implementation SoundRecViewController
@synthesize recButton, playButton;
-(IBAction)recording {
    
    if(!isRecording) {
        isRecording = YES;
        [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [recButton setTitle:@"STOP" forState:UIControlStateNormal];
        playButton.hidden = YES;
        recStateLabel.text = @"Recording";
     
        if(temporaryRecFile != nil)
            NSLog(@"I have created a temporary file at: %@.", temporaryRecFile);
        
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];      
    }
    else {
        isRecording = NO;
        [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [recButton setTitle:@"REC" forState:UIControlStateNormal];
        playButton.hidden = NO;
        recStateLabel.text = @"Mensaje grabado...";
        [recorder stop];
        if(temporaryRecFile != nil)
            NSLog(@"Temporary file still exists at: %@.", temporaryRecFile);        
    }
}
/*
-(IBAction)recording {
    
    if(!isRecording) {
        isRecording = YES;
        [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [recButton setTitle:@"STOP" forState:UIControlStateNormal];
        playButton.hidden = YES;
        recStateLabel.text = @"Recording";
        
        temporaryRecFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithString: @"VoiceMessage"]]];
        
        if(temporaryRecFile != nil)
            NSLog(@"I have created a temporary file at: %@.", temporaryRecFile);
        
        recorder = [[AVAudioRecorder alloc] initWithURL:temporaryRecFile settings:nil error:nil];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];      
    }
    else {
        isRecording = NO;
        [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [recButton setTitle:@"REC" forState:UIControlStateNormal];
        playButton.hidden = NO;
        recStateLabel.text = @"Mensaje grabado...";
        [recorder stop];
        if(temporaryRecFile != nil)
            NSLog(@"Temporary file still exists at: %@.", temporaryRecFile);        
    }
} 
 */

/*
-(IBAction)playback {
    if(isPlaying) {
        isPlaying = NO;
        [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        recStateLabel.text = @"Ready to Play";
        
    } else {
        isPlaying = YES;
        NSError *error = nil;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error: &error];
        player.volume = 1;
        recStateLabel.text = @"Playing...";
        [playButton setTitle:@"STOP" forState:UIControlStateNormal];
        
        // To minimize lag time before start of output, preload buffers      
        [player prepareToPlay];
        // Play the sound once (set negative to loop)
        [player setNumberOfLoops:0];
        
        [player play];
        if (player == nil || error != nil) {
            NSLog(@"Error playing sound. %@.\nDelivery: %@", [error description], temporaryRecFile);
        } else { 
            //NSLog(@"No problems with the player. Special Delivery: %@", temporaryRecFile);
        }
        
        if(player.isPlaying) {
            //NSLog(@"Player Settings: %@.", player.settings);
            NSLog(@"The player is playing.");
        } else 
            NSLog(@"Not playing...");
    }
}
*/


-(IBAction)playback {
    if(isPlaying) {
        isPlaying = NO;
        [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        recStateLabel.text = @"Ready to Play";
        [player stop];
    } else {
        
        isPlaying = YES;
        NSError *error = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:temporaryRecFile error: &error];
        player.volume = 1;
        recStateLabel.text = @"Playing...";
        [playButton setTitle:@"STOP" forState:UIControlStateNormal];
    
        
        if(!error)
        {     
            [player setDelegate:self];
            [player prepareToPlay];
            [player play];
        
        }
        else {
            NSLog(@"Error ocurred.");
        }
    
    }
}



- (void)viewDidLoad
{
    
    isRecording = NO;
    isPlaying   = NO;
    playButton.hidden = YES;
    recStateLabel.text = @"No estoy grabando...";
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    //when the category is play and record the playback comes out of the speaker used for phone conversation to avoid feedback
    //change this to the normal or default speaker
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [audioSession setActive:YES error:nil];
 
    UInt32 doChangeDefaultRoute = 1;        
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    
    
    // Create the temp file and recorder
    temporaryRecFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithString: @"VoiceMessage"]]];
    recorder = [[AVAudioRecorder alloc] initWithURL:temporaryRecFile settings:nil error:nil];
    
    
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
        NSLog(@"The player concluded.");
        recStateLabel.text = @"Ready to Play";
        [playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        isPlaying = NO;
}


- (void)viewDidUnload
{
    NSFileManager *fileHandler  = [NSFileManager defaultManager];
    [fileHandler removeItemAtURL: temporaryRecFile error:nil];
    recorder = nil;
    temporaryRecFile = nil;
    playButton.hidden = YES;
    isRecording = NO;
    isPlaying = NO;
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
