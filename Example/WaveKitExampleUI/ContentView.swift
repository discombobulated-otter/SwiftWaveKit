import SwiftUI
import WaveKit

public struct ContentView: View {
    @State private var amplitude: Double = 1.2
    @State private var frequency: Double = 2.5
    
    public init() {}
    
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    public var body: some View {
        NavigationStack {
            ZStack {
                // Premium Dark Gradient Background
                LinearGradient(
                    colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color.black],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // Header Title
                        VStack(spacing: 6) {
                            Text("WAVEKIT")
                                .font(.system(size: 14, weight: .black, design: .rounded))
                                .foregroundColor(.cyan)
                                .kerning(4)
                            
                            Text("3D Examples Suite")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 15)
                        
                        // 3D Header Showcase Card using WaveView with modifiers
                        ZStack {
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(Color.white.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 8)
                            
                            WaveView(.sine)
                                .waveform(amplitude: amplitude, frequency: frequency)
                                .waveStyle(WaveStyle(color: .cyan))
                                .animated(speed: 1.0)
                                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            
                            // Floating Interactive Overlay Text
                            VStack {
                                Spacer()
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Interactive Live Ribbon")
                                            .font(.system(.subheadline, design: .rounded))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text("SceneKit Hardware Accelerated 3D Renderer")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "cube.transparent")
                                        .font(.title2)
                                        .foregroundColor(.cyan)
                                }
                                .padding(20)
                                .background(
                                    LinearGradient(
                                        colors: [.clear, .black.opacity(0.8)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .cornerRadius(30)
                                )
                            }
                        }
                        .frame(height: 180)
                        .padding(.horizontal, 20)
                        
                        // Dashboard Section Label
                        HStack {
                            Text("Choose a Visualization")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        
                        // Grid of Demos
                        LazyVGrid(columns: columns, spacing: 16) {
                            DashboardCard(
                                title: "Basic Sine",
                                subtitle: "Single frequency wave",
                                icon: "waveform",
                                color: .cyan,
                                destination: AnyView(BasicSineDemo())
                            )
                            
                            DashboardCard(
                                title: "Multiple Waves",
                                subtitle: "Frequency superposition",
                                icon: "waveform.path",
                                color: .purple,
                                destination: AnyView(MultipleWavesDemo())
                            )
                            
//                                                        DashboardCard(
//                                title: "Damped Decay",
//                                subtitle: "Energy loss over depth",
//                                icon: "waveform.path.badge.minus",
//                                color: .orange,
//                                destination: AnyView(DampedWaveDemo())
//                            )
//                            
                            DashboardCard(
                                title: "Ocean Effect",
                                subtitle: "Overlap & interference",
                                icon: "waveform.and.mic",
                                color: .blue,
                                destination: AnyView(OceanEffectDemo())
                            )
                            
                            DashboardCard(
                                title: "ECG Heartbeat",
                                subtitle: "Cardiac pulse simulation",
                                icon: "heart.text.square",
                                color: .green,
                                destination: AnyView(ECGStyleDemo())
                            )
                            
//                            DashboardCard(
//                                title: "Load Indicators",
//                                subtitle: "Animation micro-pulses",
//                                icon: "arrow.triangle.2.circlepath",
//                                color: .yellow,
//                                destination: AnyView(LoadingIndicatorDemo())
//                            )
                            
                            DashboardCard(
                                title: "Z-Depth Progress",
                                subtitle: "Z-axis growing segments",
                                icon: "hourglass",
                                color: .mint,
                                destination: AnyView(ProgressWaveDemo())
                            )
                            
//                            DashboardCard(
//                                title: "AM Modulation",
//                                subtitle: "WaveQuest Level 5",
//                                icon: "radio",
//                                color: .purple,
//                                destination: AnyView(WaveQuestLevel5Demo())
//                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .tint(.cyan)
    }
}

struct DashboardCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 12) {
                // Icon Header
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(color)
                }
                
                // Titles
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(height: 160)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.03))
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(DashboardCardButtonStyle())
    }
}

struct DashboardCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
