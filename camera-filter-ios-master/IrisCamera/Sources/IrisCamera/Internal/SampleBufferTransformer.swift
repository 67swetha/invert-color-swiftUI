import AVKit
import CoreImage
import Foundation
import CoreVideo

struct SampleBufferTransformer {
    func transform(videoSampleBuffer: CMSampleBuffer) -> CMSampleBuffer {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) else {
            print("failed to get pixel buffer")
            fatalError()
        }
        
        #warning("Implementation to invert colors in pixel buffer")
        // Create a CIImage from the pixel buffer
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        // Apply color to the image
        let outputImage = ciImage.applyingFilter("CIColorMonochrome", parameters: [
            kCIInputColorKey: CIColor.white,
            kCIInputIntensityKey: 1.0 // Adjust intensity as needed
        ])
        
        // Create a CIContext
        let context = CIContext()
       // Render the output image into a new pixel buffer
        context.render(outputImage, to: pixelBuffer)

        guard let result = try? pixelBuffer.mapToSampleBuffer(timestamp: videoSampleBuffer.presentationTimeStamp) else {
            fatalError()
        }
        
        return result
    }

}
