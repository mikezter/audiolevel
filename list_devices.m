#include <CoreServices/CoreServices.h>
#include <AudioToolbox/AudioServices.h>
#include <AVFoundation/AVFoundation.h>

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
main(int argc, char **argv)
{
  listDevices();
}
