import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: Int = 0

    public init() {
        // Set tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(TrustifyTheme.cardBackground)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "shield.fill")
                }
                .tag(0)

            InstantLookupView()
                .tabItem {
                    Label("Lookup", systemImage: "magnifyingglass.circle.fill")
                }
                .tag(1)

            VoicemailsView()
                .tabItem {
                    Label("Voicemail", systemImage: "recordingtape")
                }
                .tag(2)

            NotedNumbersView()
                .tabItem {
                    Label("Noted", systemImage: "note.text")
                }
                .tag(3)

            TrustedCallersView()
                .tabItem {
                    Label("Trusted", systemImage: "person.crop.circle.badge.checkmark")
                }
                .tag(4)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(5)
        }
        .accentColor(TrustifyTheme.emerald)
    }
}
