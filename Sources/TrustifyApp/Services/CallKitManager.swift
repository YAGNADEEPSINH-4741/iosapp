import Foundation
import CallKit
import Combine

public class CallKitManager: ObservableObject {
    public static let shared = CallKitManager()

    public static let extensionBundleId = "com.safecallai.trustify.calldirectory"

    @Published public var isEnabled: Bool = false
    @Published public var statusMessage: String = "Checking CallKit status..."
    @Published public var isReloading: Bool = false

    public init() {
        checkStatus()
    }

    public func checkStatus() {
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(
            withIdentifier: Self.extensionBundleId
        ) { [weak self] status, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.statusMessage = "Error: \(error.localizedDescription)"
                    self?.isEnabled = false
                    return
                }

                switch status {
                case .enabled:
                    self?.isEnabled = true
                    self?.statusMessage = "Active: Caller ID & Spam Blocking is enabled in iOS Settings."
                case .disabled:
                    self?.isEnabled = false
                    self?.statusMessage = "Disabled: Enable Trustify in Settings > Phone > Call Blocking & Identification."
                case .unknown:
                    self?.isEnabled = false
                    self?.statusMessage = "Unknown: Extension state not reported."
                @unknown default:
                    self?.isEnabled = false
                    self?.statusMessage = "Status unavailable."
                }
            }
        }
    }

    public func reloadExtension() {
        isReloading = true
        CXCallDirectoryManager.sharedInstance.reloadExtension(
            withIdentifier: Self.extensionBundleId
        ) { [weak self] error in
            DispatchQueue.main.async {
                self?.isReloading = false
                if let error = error {
                    self?.statusMessage = "Failed to reload: \(error.localizedDescription)"
                } else {
                    self?.statusMessage = "Successfully updated on-device Call Directory!"
                    self?.checkStatus()
                }
            }
        }
    }
}

