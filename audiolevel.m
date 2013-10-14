//
//  main.c
//  audiolevel3
//
//  Created by Mike on 29.09.13.
//  Copyright (c) 2013 Mike. All rights reserved.
//

#include <CoreServices/CoreServices.h>
#include <AudioToolbox/AudioServices.h>
#include <AVFoundation/AVFoundation.h>
#include <sys/time.h>

float
getVolume(AVAudioRecorder* recorder)
{
    [recorder updateMeters];
    return [recorder peakPowerForChannel:0];
}

long long int
getMillisecondsSinceEpoch()
{
    struct timeval res;

    gettimeofday(&res, NULL);

    return res.tv_sec * 1000 + res.tv_usec / 1000;
}

AVAudioRecorder*
getAudioRecorder()
{
    NSURL *url = [NSURL fileURLWithPath:@"/tmp/audiolevel.temp"];
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

    return recorder;
}

void
listDevices()
{
    NSArray *devices = [AVCaptureDevice devices];

    for (AVCaptureDevice *device in devices) {

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

int
main(int argc, char const **argv)
{
#ifdef DEBUG
    listDevices();
#endif

    AVAudioRecorder *recorder = getAudioRecorder();

    while (true) {
        printf("%lld %f\n", getMillisecondsSinceEpoch(), getVolume(recorder));
    }

    return 0;
}

