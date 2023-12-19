import CoreImage

class ContentViewModel: ObservableObject {
  @Published var frame: CGImage?
  private let frameManager:FrameManager = .shared
  @Published var error: Error?
  private let cameraManager: CameraManager = .shared

  init() {
    setupSubscriptions()
  }

  func setupSubscriptions() {
    frameManager.$current
      .receive(on: RunLoop.main)
      .compactMap { buffer in
        return CGImage.create(from: buffer)
      }
      .assign(to: &$frame)
    cameraManager.$error
      .receive(on: RunLoop.main)
      .map { $0 }
      .assign(to: &$error)
  }
}
