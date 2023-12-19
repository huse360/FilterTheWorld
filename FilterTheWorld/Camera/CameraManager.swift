import AVFoundation

class CameraManager: ObservableObject {
  enum Status {
    case unconfigured
    case configured
    case unauthorized
    case failed
  }

  static let shared: CameraManager = CameraManager()
  @Published var error: CameraError?
  let session = AVCaptureSession()
  private let sessionQueue: DispatchQueue = DispatchQueue(label: "com.raywenderlich.SessionQ")
  private let videoOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
  private var status: Status = .unconfigured

  private init() {
    configure()
  }

  private func configure() {

  }

  private func set(error: CameraError?) {
    DispatchQueue.main.async {
      self.error = error
    }
  }

  private func chechPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video) { authorized in
        if !authorized {
          self.status = .unauthorized
          self.set(error: .deniedAuthorization)
        }
        self.sessionQueue.resume()
      }
    case .restricted:
      self.status = .unauthorized
      set(error: .restrictedAuthorization)
    case .denied:
      status = .unauthorized
      set(error: .deniedAuthorization)
    case .authorized:
      break
    @unknown default:
      status = .unauthorized
      set(error: .unknownAuthorization)
    }
  }
}
