//
//  main.c
//  audiolevel3
//
//  Created by Mike on 29.09.13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#include <CoreServices/CoreServices.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>


AudioDeviceID getDefaultOutputDeviceID()
{
    AudioDeviceID outputDeviceID = kAudioObjectUnknown;

    // get output device device
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    propertyAOPA.mScope = kAudioObjectPropertyScopeGlobal;
    propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    propertyAOPA.mSelector = kAudioHardwarePropertyDefaultOutputDevice;

    if (!AudioHardwareServiceHasProperty(kAudioObjectSystemObject, &propertyAOPA))
    {
        printf("Cannot find default output device!");
        return outputDeviceID;
    }

    status = AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &propertyAOPA, 0, NULL, (UInt32[]){sizeof(AudioDeviceID)}, &outputDeviceID);

    if (status != 0)
    {
        printf("Cannot find default output device!");
    }
    return outputDeviceID;
}

float getVolume ()
{
    NSURL *url = [NSURL fileURLWithPath:@"/Users/mike/audiolevel.temp"];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];

    NSError *error;
    AVAudioRecorder *recorder;

    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];

    [recorder setMeteringEnabled:YES];
    [recorder record];
    [recorder updateMeters];

    float avg = [recorder averagePowerForChannel:0];
    float peak = [recorder peakPowerForChannel:0];
    // NSLog(@"AVG %f PEAK: %f", avg, peak);
    [recorder stop];

    return peak;

}

void devices()
{
    NSArray *devices = [AVCaptureDevice devices];

    for (AVCaptureDevice *device in devices) {

        // printf("%s", device.localizedName);
        NSLog(@"Device name: %@", [device localizedName]);

        if ([device hasMediaType:AVMediaTypeVideo]) {

            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
            }
            else {
                NSLog(@"Device position : front");
            }
        }
    }
}

int main(int argc, char const *argv[])
{
    devices();
    float oldVolume = -1.0;

    while (true) {
        if (oldVolume != getVolume()) {
            oldVolume = getVolume();
            printf("%f\n", getVolume());
        }
    }
    return 0;
}

