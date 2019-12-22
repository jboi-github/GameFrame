//
//  GFAudio.swift
//  GameFrameKit
//
//  Created by Juergen Boiselle on 20.12.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import AVFoundation

public class GFAudio: ObservableObject {
    // MARK: - Initialization
    init() {
        // Mix Audio Signals with existing sound like background music
        let avSession = AVAudioSession.sharedInstance()
        do {
            try avSession.setCategory(.ambient, mode: .default, options: .mixWithOthers)
            try avSession.setActive(true)
        } catch {
            log(error)
        }
        log()
    }
    
    // MARK: - Public
    /// Setting, if sounds are played or not. Sounds are always mixed with whatever else is currently played
    @Published public var turnedOn: Bool = !UserDefaults.standard.bool(forKey: GFAudio.turnedOffKey) {
        didSet {
            log(turnedOn)
            UserDefaults.standard.set(!turnedOn, forKey: GFAudio.turnedOffKey)
        }
    }
    
    /**
     Register a sound to be played later.
     
     The sound is stored to be played later multiple times in the game.
     - parameters:
        - key: Key of the sound to play later
        - resource: Name of the resource file that contains the sound without extension and path.
        - withExtension: Type of the resource file. Default is "mp3"
        - subdirectory: Directory that contains the resources. Defaults to "Sounds"
     */
    public func register(_ key: String, resource: String, withExtension: String = "mp3") {
        log(key, resource, withExtension)
        guard let url = Bundle.main.url(forResource: resource, withExtension: withExtension) else {
            log("No sound found!", key, resource, withExtension)
            return
        }
        
        sounds[key] = (url: url, players: [AVAudioPlayer]())
    }
    
    public enum Mix {
        /// When sound is already playing, stop and restart.
        case stopOther
        /// When sound is already playing, overlay both
        case overlay
        /// When sound is already playing, let continue and do not start new one
        case stopSelf
    }
    /**
     Play sound that was registered before.
     
     Plays sound as registered before. If no sound was registered, nothing happens.
     - parameters:
        - key: Key under which sound was registered before
        - mix: Define what happens, when sound is already playing
     */
    public func play(_ key: String, mix: Mix = .overlay) {
        log(turnedOn, key)
        guard turnedOn else {return}
        
        guard sounds[key] != nil else {
            log("No sound registered for key!", key)
            return
        }
        
        switch mix {
        case .overlay:
            playOnNextFreePlayer(key)
        case .stopSelf:
            if !isAnyPlaying(key) {playOnNextFreePlayer(key)}
        case .stopOther:
            stopAll(key)
            playOnNextFreePlayer(key)
        }
    }
    
    // MARK: - Internal
    private static let turnedOffKey = "GFAudioTurnedOffKey"
    
    private var sounds = [String : (url: URL, players: [AVAudioPlayer])]()
    
    private func hasFreePlayer(_ key: String) -> Bool {
        guard let players = sounds[key]?.players else {return false}
        
        return !players.filter {!$0.isPlaying}.isEmpty
    }
    
    private func isAnyPlaying(_ key: String) -> Bool {
        guard let players = sounds[key]?.players else {return false}
        
        return !players.filter {$0.isPlaying}.isEmpty
    }
    
    private func stopAll(_ key: String) {
        guard let players = sounds[key]?.players else {return}
        
        players.forEach {$0.stop()}
    }
    
    private func getFreePlayer(_ key: String) -> AVAudioPlayer? {
        guard let players = sounds[key]?.players else {return nil}
        
        return players.filter {!$0.isPlaying}.first
    }
    
    private func addPlayer(_ key: String) -> AVAudioPlayer? {
        guard let url = sounds[key]?.url else {return nil}
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            sounds[key]?.players.append(player)
            return player
        } catch {
            log(error)
            return nil
        }
    }
    
    private func playOnNextFreePlayer(_ key: String) {
        if let player = getFreePlayer(key) {
            player.play()
        } else if let player = addPlayer(key) {
            player.play()
        }
    }
}
