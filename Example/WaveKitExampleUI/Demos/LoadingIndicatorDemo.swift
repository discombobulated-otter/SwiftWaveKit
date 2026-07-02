import SwiftUI
import Combine
import WaveKit

struct LoadingIndicatorDemo: View {
    @State private var pulseSpeed: Double = 1.5
    @State private var isSpinning: Bool = false
    @State private var scale: CGFloat = 1.0
    @State private var showGrid: Bool = false
    
    // We will automatically pulse the amplitude using a timer
    @State private var amplitude: Double = 1.0
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("3D Loading Indicators")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Micro-animations and rhythmic frequency pulses")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // Spinner View using WaveView + modifiers
                VStack(spacing: 30) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30, style: .continuous)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                        
                        WaveView(.sine)
                            .amplitude(amplitude)
                            .frequency(4.0)
                            .waveColor(.cyan)
                            .animated(true)
                            .renderMode3D(true)
                            .showGrid(showGrid)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .scaleEffect(scale)
                    }
                    .frame(width: 220, height: 220)
                    .rotationEffect(Angle(degrees: isSpinning ? 360 : 0))
                    
                    Text("Loading Asset Data...")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.cyan)
                }
                
                // Controls Panel
                VStack(spacing: 20) {
                    DemoSlider(title: "Pulse Speed multiplier", value: $pulseSpeed, range: 0.5...3.0, format: "%.1f")
                    
                    Toggle(isOn: $showGrid) {
                        Text("Show 3D Perspective Grid")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .tint(.cyan)
                    .padding(.bottom, 8)
                    
                    HStack(spacing: 30) {
                        Button(action: {
                            withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
                                isSpinning.toggle()
                            }
                        }) {
                            Text(isSpinning ? "Stop Spinning" : "Spin 3D Box")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.cyan.opacity(0.2))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.cyan, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                                scale = scale == 1.0 ? 0.8 : 1.2
                            }
                        }) {
                            Text(scale != 1.0 ? "Stop Pulse" : "Pulse Scale")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple.opacity(0.2))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.purple, lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer) { time in
            let factor = sin(time.timeIntervalSince1970 * 2.0 * pulseSpeed)
            amplitude = 1.0 + factor * 0.6
        }
    }
}

struct LoadingIndicatorDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoadingIndicatorDemo()
        }
    }
}
