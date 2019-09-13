<h1 align="center">
<img src="https://makeml.app/img/logo_vector.svg" width=300px href="https://makeml.app?utm=github_nails_segmentation" alt="Object Detection and Segmentation MakeML">
</h1>

[MakeML](https://makeml.app?utm=github_nails_segmentation) is a Developer Tool for Creating Object Detection and Segmentation Neural Networks without a Line of Code. It's built to make the training process easy to setup. It is designed to handle data sets, training configurations, markup and training processes — all in one place.

## MakeML Nails
Is an app example that shows how users can try on different nail polish colors. The machine learning model was trained for 3 hours with 50 photos.
<div align="center">
<img src="https://makeml.app/docs/assets/nails_results_MakeML_2.gif">
</div>

## Train Objects Segmentation .tflite model
[![MakeML object detection and segmentation ML models](https://img.shields.io/static/v1?label=platform&message=macOS&color=blue)](https://makeml.app)

See the [Tutorial](https://makeml.app/docs/nails_tutorial_intro?utm=github_nails_segmentation) for the training object segmentation model without a line of code with macOS desktop application.

<div align="center">
<img src="https://makeml.app/docs/assets/nails_adding_annotations.gif">
</div>

## Using another .tflite model
[![MakeML object detection and segmentation ML models](https://img.shields.io/static/v1?label=platform&message=iOS&color=blue)](https://makeml.app)    [![MakeML object detection and segmentation ML models](https://img.shields.io/static/v1?label=language&message=swift&nbsp;&#124;&nbsp;objective-c&color=green)](https://makeml.app)

For using MakeML Nails project with another .tflite file, add it to the project and change this line with your name of the model.
```
NSString *modelPath = FilePathForResourceName(@"result_model", @"tflite");
```

Change the number of classes and add colors to the array:
```
int class_count = 2;
unsigned int colors[class_count] = {  0000000000, additionalColor };
```

## Links

[More Tutorials](https://makeml.app/tutorials?utm=github_nails_segmentation) | [Full Documentation](https://makeml.app/docs/doc1?utm=github_nails_segmentation) | [MakeML Chat](https://discordapp.com/invite/vgcG3Su) | [Support page](https://makeml.app/support)
