import SwiftUI
import WaveKit

struct ProgressWaveDemo: View {
    @State private var progress: Double = 0.5
    
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
                        .waveform(amplitude: 1.2, frequency: 3.0)
                        .waveStyle(WaveStyle(color: .cyan))
                        .animated(speed: 1.0)
                        .progress(progress)
                        .gridStyle(.subtle)
                        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
						.task {
							while progress < 1.0 {
								do {
									let next = try await progressFunction(progress: progress)
									withAnimation(.easeInOut(duration: 0.6)) {
										progress = min(next, 1.0)
									}
								} catch {
									break
								}
							}
						}
                    
                    // Centered Text indicator overlay
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 64, weight: .black, design: .rounded))
                        .foregroundColor(.white.opacity(0.15))
                        .allowsHitTesting(false)
                }
                .frame(height: 280)
                .padding(.horizontal, 20)
                
                CodeSnippetView(code: """
                WaveView(.sine)
                    .waveform(amplitude: 1.2, frequency: 3.0)
                    .waveStyle(WaveStyle(color: .cyan))
                    .animated(speed: 1.0)
                    .progress(progress)
                    .gridStyle(.subtle)
                """)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
func progressFunction(progress: Double) async throws -> Double {
	try await Task.sleep(nanoseconds: 3_000_000_000)
	return progress + 0.25
}

struct ProgressWaveDemo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProgressWaveDemo()
        }
    }
}
