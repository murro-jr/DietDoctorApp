import AudioToolbox

class Sound {
    
    var name: String?
    var type: String?
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    func play() {
        if let soundUrl = Bundle.main.url(forResource: name!, withExtension: type!){
            var soundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
            AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
                AudioServicesDisposeSystemSoundID(soundId)
            }, nil)
            AudioServicesPlaySystemSound(soundId)
        }
    }
}
