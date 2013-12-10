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
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


#define SOURCE    "cmokbox"
#define DEST_IP   "127.0.0.1"
#define DEST_PORT 6666

struct data {
   float avg;
   float peak;
   long long int timestamp;
};

long long int
getMillisecondsSinceEpoch()
{
    struct timeval res;
    gettimeofday(&res, NULL);
    return res.tv_sec * 1000 + res.tv_usec / 1000;
}

struct data
getData(AVAudioRecorder* recorder)
{
    [recorder updateMeters];
    struct data data;
    data.avg =  [recorder averagePowerForChannel:0];
    data.peak =  [recorder peakPowerForChannel:0];
    data.timestamp = getMillisecondsSinceEpoch();
    return data;
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

void
sendData(struct sockaddr_in address, int s, struct data *data)
{
    char message[150];
    sprintf(message, "{\"@timestamp\":%lld, \"peak\":%f, \"avg\":%f, \"type\":\"soundlevel\", \"source\":\"%s\"}", data->timestamp, data->avg, data->peak, SOURCE);
    int sent = sendto(s, &message, strlen(message), 0, (struct sockaddr *)&address, sizeof(address));
    printf("%d\n", sent);
    printf("%s\n", message);
}

int
main(int argc, char const **argv)
{

    setbuf(stdout, NULL);

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    AVAudioRecorder *recorder = getAudioRecorder();
    struct data data;

    int s = socket(AF_INET, SOCK_DGRAM, 0);
    printf("%d\n", s);
    struct sockaddr_in address;

    address.sin_family = AF_INET;
    address.sin_port = htons(DEST_PORT);
    address.sin_addr.s_addr = inet_addr(DEST_IP);

    while (true) {
        data = getData(recorder);
        sendData(address, s, &data);
        sleepABit();
    }

    [pool release];

    return 0;
}
