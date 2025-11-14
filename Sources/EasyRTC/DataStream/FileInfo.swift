/* -- */

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

import CoreServices

/// Basic information about a file required to send it over a data stream.
struct FileInfo: Equatable {
    let name: String
    let size: Int
    let mimeType: String?
}

extension FileInfo {
    /// Reads information from the file located at the given URL.
    init?(for fileURL: URL) {
        var resourceKeys: Set<URLResourceKey> = [.nameKey, .fileSizeKey]
        if #available(macOS 11.0, iOS 14.0, *) {
            resourceKeys.insert(.contentTypeKey)
        }

        guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
              let name = resourceValues.name,
              let size = resourceValues.fileSize else { return nil }

        self.name = name
        self.size = size

        guard #available(macOS 11.0, iOS 14.0, *) else {
            guard let uti = UTTypeCreatePreferredIdentifierForTag(
                kUTTagClassFilenameExtension,
                fileURL.pathExtension as CFString,
                nil
            )?.takeRetainedValue() else {
                return nil
            }
            mimeType = UTTypeCopyPreferredTagWithClass(
                uti,
                kUTTagClassMIMEType
            )?.takeRetainedValue() as? String
            return
        }

        mimeType = resourceValues.contentType?.preferredMIMEType
    }
}

extension FileInfo {
    /// Returns the preferred file extension for the given MIME type.
    static func preferredExtension(for mimeType: String) -> String? {
        guard mimeType != "application/octet-stream" else {
            // Special case not handled by UTType
            return "bin"
        }
        guard #available(macOS 11.0, iOS 14.0, *) else {
            guard let uti = UTTypeCreatePreferredIdentifierForTag(
                kUTTagClassMIMEType,
                mimeType as CFString,
                nil
            )?.takeRetainedValue() else {
                return nil
            }
            guard let fileExtension = UTTypeCopyPreferredTagWithClass(
                uti,
                kUTTagClassFilenameExtension
            )?.takeRetainedValue() else {
                return nil
            }
            return fileExtension as String
        }
        guard let utType = UTType(mimeType: mimeType) else { return nil }
        return utType.preferredFilenameExtension
    }
}
