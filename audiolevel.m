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

struct data {
   float avg;
   float peak;
};

struct data
getData(AVAudioRecorder* recorder)
{
    [recorder updateMeters];
    struct data data;
    data.avg =  [recorder averagePowerForChannel:0];
    data.peak =  [recorder peakPowerForChannel:0];
    return data;
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
    duration.tv_nsec = 250000000L;

    nanosleep(&duration, NULL);
}

int
main(int argc, char const **argv)
{
    setbuf(stdout, NULL);

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    AVAudioRecorder *recorder = getAudioRecorder();

    while (true) {
        printf("%lld %f %f\n", getMillisecondsSinceEpoch(), getData(recorder).avg, getData(recorder).peak);
        sleepABit();
    }

    [pool release];

    return 0;
}
