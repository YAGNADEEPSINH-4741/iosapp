import Foundation
import CallKit

/**
 * CallDirectoryHandler is an iOS CallKit extension.
 * When the user enables Trustify in iOS Settings -> Phone -> Call Blocking & Identification,
 * iOS invokes this handler to populate its on-device caller ID cache and blocking list.
 */
class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        // 1. Check if this is an incremental update or a full fresh load
        if context.isIncremental {
            addOrRemoveIncrementalIdentificationPhoneNumbers(to: context)
        } else {
            addAllBlockingPhoneNumbers(to: context)
            addAllIdentificationPhoneNumbers(to: context)
        }

        context.completeRequest()
    }

    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Known aggressive spam telemarketing prefixes (e.g. TRAI 140 series samples)
        // Must be in ascending order
        let spamNumbers: [CXCallDirectoryPhoneNumber] = [
            9198177164
        ]

        for phoneNumber in spamNumbers.sorted() {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }

    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve seeded directory entries (Already sorted ascending!)
        let entries = OfflineDirectorySeeder.getSortedCallDirectoryEntries()

        for entry in entries {
            context.addIdentificationEntry(
                withNextSequentialPhoneNumber: entry.number,
                label: entry.label
            )
        }
    }

    private func addOrRemoveIncrementalIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Incremental updates if needed in future versions
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // Logs if requested numbers are unsorted or out-of-order
        NSLog("Trustify Call Directory error: \(error.localizedDescription)")
    }
}
