import SwiftUI
import WaveKit

struct ProgressWaveDemo: View {
    @State private var progress: Double = 0.5
    @State private var isAnimated: Bool = true
    @State private var showGrid: Bool = true
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.08, green: 0.08, blue: 0.18), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("3D Z-Depth Progress")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Wave generation along the depth axis")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                // 3D Wave Box using WaveView + modifiers
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                    
                    WaveView(.sine)
                        .amplitude(1.2)
                        .frequency(3.0)
                        .waveColor(.cyan)
                        .animated(isAnimated)
                        .progress(progress)
                        .renderMode3D(true)
                        .showGrid(showGrid)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    
                    // Centered Text indicator overlay
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.15))
                        .allowsHitTesting(false)
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                // Controls Panel
                VStack(spacing: 24) {
                    DemoSlider(title: "Progress Level", value: $progress, range: 0.0...1.0, format: "%.2f")
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 1.2)) {
                                progress = 0.0
                            }
                        }) {
                            Text("Reset")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(15)
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                progress = 1.0
                            }
                        }) {
                            Text("Fill 100%")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.cyan.opacity(0.3))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.cyan, lineWidth: 1)
                                )
                        }
                    }
                    
                    HStack(spacing: 30) {
                        Toggle(isOn: $isAnimated) {
                            Text("Animate")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Toggle(isOn: $showGrid) {
                            Text("Show Grid")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.cyan)
                }
                .padding(30)
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
    }
}

struct ProgressWaveDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProgressWaveDemo()
        }
    }
}
