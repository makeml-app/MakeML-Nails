#ifndef RESEARCH_AIMATTER_TFLITE_METAL_DELEGATE_H_
#define RESEARCH_AIMATTER_TFLITE_METAL_DELEGATE_H_

#import <Metal/Metal.h>

#include "tensorflow/lite/context.h"

// Creates a new delegate instance that need to be destroyed with
// DeleteFlowDelegate when delegate is no longer used by tflite.
struct GpuDelegateOptions {
  // Allows to quantify tensors, downcast values, process in float16 etc.
  bool allow_precision_loss;

  enum class WaitType {
    // waitUntilCompleted
    kPassive,
    // Minimize latency. It uses active spinning instead of mutex and consumes
    // additional CPU resources.
    kActive,
    // Useful when the output is used with GPU pipeline then or if external
    // command encoder is set
    kDoNotWait,
  };
  WaitType wait_type;
};

TfLiteDelegate* NewGpuDelegate(const GpuDelegateOptions* options);

// Binds user-created MTLBuffer with the float32 data format
bool BindMetalBufferToTensor(TfLiteDelegate* delegate, int tensor_index,
                             id<MTLBuffer> metal_buffer);

// Destroys a delegate created with NewGpuDelegate call.
void DeleteGpuDelegate(TfLiteDelegate* delegate);

#endif  // RESEARCH_AIMATTER_TFLITE_METAL_DELEGATE_H_
