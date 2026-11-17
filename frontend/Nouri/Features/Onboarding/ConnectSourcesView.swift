import SwiftUI

struct ConnectSourcesView: View {
    let model: OnboardingViewModel

    var body: some View {
        OnboardingPage(title: "Connect your apps",
                       subtitle: "Nouri reads from Apple Health, which also collects data from your other fitness apps.",
                       buttonTitle: "Continue",
                       action: model.continueToGoals) {
            SourceCard(name: "Apple Health", systemImage: "heart.fill",
                       detail: "Sleep, heart rate, workouts, steps, and more.") {
                if model.healthConnected {
                    Label("Connected", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Button("Connect") { Task { await model.connectHealth() } }
                        .buttonStyle(.bordered)
                        .disabled(model.isConnectingHealth)
                }
            }

            Text("Via Apple Health").font(.headline)
            ForEach(Self.viaHealthApps, id: \.self) { app in
                SourceCard(name: app, systemImage: "arrow.triangle.2.circlepath",
                           detail: "Turn on Apple Health sync in the \(app) app's settings, and Nouri will see it automatically.") {
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    static let viaHealthApps = ["Strava", "Oura", "Garmin Connect", "WHOOP"]
}

private struct SourceCard<Trailing: View>: View {
    let name: String
    let systemImage: String
    let detail: String
    @ViewBuilder let trailing: Trailing

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text(name).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            trailing
        }
        .padding(16)
        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
    }
}

#Preview { NavigationStack { ConnectSourcesView(model: .preview) } }
