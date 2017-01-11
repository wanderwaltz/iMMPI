import AVFoundation

enum Sound {
    case clickPositive
    case clickNegative
}


extension Sound {
    var resourceName: String {
        switch self {
        case .clickPositive: return "button_tap2"
        case .clickNegative: return "button_tap1"
        }
    }

    var resourceExtension: String {
        switch self {
        case .clickPositive: return "wav"
        case .clickNegative: return "wav"
        }
    }
}


final class SoundPlayer: NSObject {
    fileprivate var players = Set<AVAudioPlayer>()
}


extension SoundPlayer {
    func play(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.resourceName, withExtension: sound.resourceExtension) else {
            return
        }

        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            return
        }

        player.delegate = self
        player.play()
        players.insert(player)
    }
}


extension SoundPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        players.remove(player)
    }
}

