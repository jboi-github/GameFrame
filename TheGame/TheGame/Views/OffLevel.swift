//
//  OffLevel.swift
//  TheGame
//
//  Created by Juergen Boiselle on 01.11.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GameFrameKit

struct OffLevel: View {
    @ObservedObject var sheets = activeSheet

    private struct Information: View {
        @ObservedObject private var points = GameFrame.coreData.getScore("Points")
        @ObservedObject private var medals = GameFrame.coreData.getAchievement("Medals")
        @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")
        @ObservedObject private var weaponB = GameFrame.coreData.getNonConsumable("weaponB")
        @ObservedObject private var weaponC = GameFrame.coreData.getNonConsumable("weaponC")

        var body: some View {
            HStack {
                Spacer()
                Group {
                    Text("\(medals.current.format("%.2f"))")
                    Image(systemName: "star.circle.fill")
                    Spacer()
                }
                Group {
                    Text("\(points.current) / \(points.highest)")
                    Spacer()
                }
                Group {
                    Text("\(bullets.available)")
                    Image(systemName: "bolt.fill")
                    Spacer()
                }
                Group {
                    if weaponC.isOpened {
                        Image(systemName: "location.fill")
                    } else if weaponB.isOpened {
                        Image(systemName: "location")
                    } else {
                        Image(systemName: "location.slash")
                    }
                    Spacer()
                }
            }
        }
    }
    
    private struct Navigation: View {
        @ObservedObject var sheets = activeSheet
        @ObservedObject private var bullets = GameFrame.coreData.getConsumable("Bullets")
        @ObservedObject private var adMob = GameFrame.adMob
        @ObservedObject private var inApp = GameFrame.inApp
        @ObservedObject private var gameCenter = GameFrame.gameCenter

        var body: some View {
            HStack {
                Spacer()
                Group {
                    Button(action: {self.sheets.next(.Store)}) {
                        Image(systemName: "cart")
                    }
                    .disabled(!inApp.available)
                    Spacer()
                }
                Group {
                    Button(action: {GameFrame.adMob.showReward(consumable: self.bullets, quantity: 100)}) {
                        Image(systemName: "film")
                    }
                    .disabled(!adMob.rewardAvailable)
                    Spacer()
                }
                Group {
                    Button(action: {GameFrame.gameCenter.show()}) {
                        Image(systemName: "rosette")
                    }
                    .disabled(!gameCenter.enabled)
                    Spacer()
                }
                Group {
                    Button(action: {
                        GameFrame.instance!.showShare(greeting: "Hi! Here's The Game", format: "%.1f")
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Spacer()
                }
                Group {
                    Button(action: getUrlAction("https://itunes.apple.com/app/idX?action=write-review")) {
                        Image(systemName: "hand.thumbsup")
                    }
                    Spacer()
                }
                Group {
                    Button(action: getUrlAction("https://www.apple.com")) {
                        Image(systemName: "link")
                    }
                    Spacer()
                }
                Group {
                    Button(action: getUrlAction(UIApplication.openSettingsURLString)) {
                        Image(systemName: "gear")
                    }
                    Spacer()
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Information()
            Spacer()
            Button(action: {
                self.sheets.next(.InLevel)
            }) {
                Image(systemName: "play.circle").resizable().scaledToFit()
            }
            Spacer()
            Navigation()
        }
    }
}

struct OffLevel_Previews: PreviewProvider {
    static var previews: some View {
        OffLevel()
    }
}
