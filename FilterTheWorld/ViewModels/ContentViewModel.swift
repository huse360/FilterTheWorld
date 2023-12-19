import CoreImage

class ContentViewModel: ObservableObject {
  @Published var frame: CGImage?
  private let frameManager:FrameManager = FrameManager.shared

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
  }
}
