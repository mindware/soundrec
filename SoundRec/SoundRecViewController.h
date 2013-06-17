//
//  SoundRecViewController.h
//  SoundRec
//
//  Created by ANDRES COLON on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SoundRecViewController : UIViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate> {
    
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *recButton;
    IBOutlet UILabel *recStateLabel;
    
    BOOL isRecording;
    BOOL isPlaying;
    NSURL *temporaryRecFile;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player; // al definirlo aqui el player no se autodestruye, a dif d si lo creo al darle play
    
}

@property(nonatomic, retain) IBOutlet UIButton *playButton;
@property(nonatomic, retain) IBOutlet UIButton *recButton;

-(IBAction)recording;
-(IBAction)playback;

@end
