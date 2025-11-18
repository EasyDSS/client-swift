import Foundation

#if swift(>=5.9)
internal import LiveKitWebRTC
#else
@_implementationOnly import LiveKitWebRTC
#endif

extension LKRTCI420Buffer {
    func toPixelBuffer() -> CVPixelBuffer? {
        // default options
        let options = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:] as [String: Any],
        ] as [String: Any]

        var outputPixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32BGRA,
                                         options as CFDictionary,
                                         &outputPixelBuffer)

        guard status == kCVReturnSuccess, let outputPixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(outputPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelFormat = CVPixelBufferGetPixelFormatType(outputPixelBuffer)

        if pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange ||
            pixelFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        {
            // NV12
            let dstY = CVPixelBufferGetBaseAddressOfPlane(outputPixelBuffer, 0)
            let dstYStride = CVPixelBufferGetBytesPerRowOfPlane(outputPixelBuffer, 0)
            let dstUV = CVPixelBufferGetBaseAddressOfPlane(outputPixelBuffer, 1)
            let dstUVStride = CVPixelBufferGetBytesPerRowOfPlane(outputPixelBuffer, 1)

            LKRTCYUVHelper.i420(toNV12: dataY,
                                srcStrideY: strideY,
                                srcU: dataU,
                                srcStrideU: strideU,
                                srcV: dataV,
                                srcStrideV: strideV,
                                dstY: dstY,
                                dstStrideY: Int32(dstYStride),
                                dstUV: dstUV,
                                dstStrideUV: Int32(dstUVStride),
                                width: width,
                                height: height)

        } else {
            let dst = CVPixelBufferGetBaseAddress(outputPixelBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(outputPixelBuffer)

            if pixelFormat == kCVPixelFormatType_32BGRA {
                LKRTCYUVHelper.i420(toARGB: dataY,
                                    srcStrideY: strideY,
                                    srcU: dataU,
                                    srcStrideU: strideU,
                                    srcV: dataV,
                                    srcStrideV: strideV,
                                    dstARGB: dst,
                                    dstStrideARGB: Int32(bytesPerRow),
                                    width: width,
                                    height: height)
            } else if pixelFormat == kCVPixelFormatType_32ARGB {
                LKRTCYUVHelper.i420(toBGRA: dataY,
                                    srcStrideY: strideY,
                                    srcU: dataU,
                                    srcStrideU: strideU,
                                    srcV: dataV,
                                    srcStrideV: strideV,
                                    dstBGRA: dst,
                                    dstStrideBGRA: Int32(bytesPerRow),
                                    width: width,
                                    height: height)
            }
        }

        CVPixelBufferUnlockBaseAddress(outputPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return outputPixelBuffer
    }
}
