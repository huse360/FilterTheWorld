import CoreImage

class ContentViewModel: ObservableObject {
  @Published var frame: CGImage?
  private let frameManager:FrameManager = .shared
  @Published var error: Error?
  private let cameraManager: CameraManager = .shared
  var comicFilter: Bool = false
  var monoFilter: Bool = false
  var crystalFilter = false
  private let context = CIContext()

  init() {
    setupSubscriptions()
  }

  func setupSubscriptions() {
    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { buffer in
        guard let image =  CGImage.create(from: buffer) else { return nil }
        var ciImage = CIImage(cgImage: image)
        if self.comicFilter {
          ciImage = ciImage.applyingFilter("CIComicEffect")
        }
        if self.monoFilter {
          ciImage = ciImage.applyingFilter("CIPhotoEffectNoir")
        }
        if self.crystalFilter {
          ciImage = ciImage.applyingFilter("CICrystallize")
        }
        return self.context.createCGImage(ciImage, from: ciImage.extent)
      }
      .assign(to: &$frame)

    cameraManager.$error
      .receive(on: RunLoop.main)
      .map { $0 }
      .assign(to: &$error)
  }
}
