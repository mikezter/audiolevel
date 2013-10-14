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

    AVAudioRecorder *recorder;

    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:NULL];

    [recorder setMeteringEnabled:YES];
    [recorder record];

    return recorder;
}

void
sleepABit()
{
    struct timespec duration;

    duration.tv_sec  = 0;
    duration.tv_nsec = 100000000L;

    nanosleep(&duration, NULL);
}

int
main(int argc, char const **argv)
{
    AVAudioRecorder *recorder = getAudioRecorder();

    while (true) {
        printf("%lld %f\n", getMillisecondsSinceEpoch(), getVolume(recorder));
        sleepABit();
    }

    return 0;
}
