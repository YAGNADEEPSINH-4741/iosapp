import Foundation
import AVFoundation
import Combine

public class AudioPlayerService: NSObject, ObservableObject, AVAudioPlayerDelegate {
    public static let shared = AudioPlayerService()

    @Published public var isPlaying: Bool = false
    @Published public var currentPlayingId: String? = nil
    @Published public var currentTime: TimeInterval = 0
    @Published public var duration: TimeInterval = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?

    public func playAudio(from urlString: String, id: String) {
        if currentPlayingId == id && isPlaying {
            pause()
            return
        }

        stop()

        guard let url = URL(string: urlString) else { return }

        // Download or stream
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    try AVAudioSession.sharedInstance().setActive(true)

                    self?.player = try AVAudioPlayer(data: data)
                    self?.player?.delegate = self
                    self?.player?.prepareToPlay()
                    self?.player?.play()

                    self?.currentPlayingId = id
                    self?.isPlaying = true
                    self?.duration = self?.player?.duration ?? 0

                    self?.startTimer()
                } catch {
                    print("Error playing audio: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    public func pause() {
        player?.pause()
        isPlaying = false
        stopTimer()
    }

    public func stop() {
        player?.stop()
        player = nil
        isPlaying = false
        currentPlayingId = nil
        currentTime = 0
        stopTimer()
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentTime = player.currentTime
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.stop()
        }
    }
}
