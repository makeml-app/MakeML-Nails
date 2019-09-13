![MakeML object detection and segmentation](https://makeml.app/img/icon.png)

[MakeML](https://makeml.app?utm=github_nails_segmentation) is Developer Tool for Creating Object Detection and Segmentation Neural Networks without a Line of Code.

[MakeML](https://makeml.app?utm=github_nails_segmentation) is built to make training process easy to setup. It is designed to handle data sets, training configurations, markup and training process. All in one place.

## Train Objects Segmentation .tflite model
[![MakeML object detection and segmentation ML models](https://img.shields.io/static/v1?label=platform&message=macOS&color=blue)](https://makeml.app)
See the [Tutorial](https://makeml.app/docs/nails_tutorial_intro?utm=github_nails_segmentation) for the training object segmentation model without a line of code in macOS desktop application.

## Using another .tflite model
[![MakeML object detection and segmentation ML models](https://img.shields.io/static/v1?label=platform&message=iOS&color=blue)](https://makeml.app)    [![MakeML object detection and segmentation ML models](https://img.shields.io/static/v1?label=language&message=swift&nbsp;&#124;&nbsp;objective-c&color=green)](https://makeml.app)
For using MakeML-Nail project with another .tflite file just add it to project and change this line with your name of model.
```
NSString *modelPath = FilePathForResourceName(@"result_model", @"tflite");
```

Change number of classes:
```
int class_count = 2;
unsigned int colors[class_count] = {  0000000000, additionalColor };
```

## Support

[More Tutorials](https://makeml.app/tutorials?utm=github_nails_segmentation)
[Full Documentation](https://makeml.app/docs/doc1?utm=github_nails_segmentation)
[MakeML Chat](https://discordapp.com/invite/vgcG3Su)
[Support page](https://makeml.app/support)
