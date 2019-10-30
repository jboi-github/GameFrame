//
//  GFAdMob.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 28.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

/**
 Handle advertisements from Google AdMob: Banner, Interstitials and rewarded videos.
 - AdUnitIds of Google are stored in `GameFrame.plist`
 - Note that there're no public functions or properties for interstitials. To show Interstitials, call `GameFrame.leaveLevel` with `showInterstital` set to true. An Interstitial will be shown, when available
 - If any of the `adUnitId` is not set, the corresponding advertisements are not loaded
 */
public class GFAdMob: NSObject, ObservableObject {
    // MARK: - Initializaton
    internal init(_ _window: UIWindow?, adUnitIdBanner _adUnitIdBanner: String?, adUnitIdRewarded _adUnitIdRewarded: String?, adUnitIdInterstitial _adUnitIdInterstitial: String?) {
        log()
        window = _window
        adUnitIdBanner = _adUnitIdBanner
        adUnitIdRewarded = _adUnitIdRewarded
        adUnitIdInterstitial = _adUnitIdInterstitial
        super.init()
        delegater = Delegater(parent: self)

        GADMobileAds.sharedInstance().start(completionHandler: nil)
        prepareReward()
        prepareInterstitial()
    }
    
    // MARK: - Public functions and properties
    // MARK: For banner
    @Published public var bannerAvailable: Bool = false
    @Published public var bannerWidth: CGFloat = 0.0
    @Published public var bannerHeight: CGFloat = 0.0

    // MARK: For rewards
    /// True, if reward is loaded and available to be shown
    @Published public var rewardAvailable: Bool = false

    /// Show the rewarded video. If succesfull, player earns quantity of consumable
    public func showReward(consumable: GFConsumable, quantity: Int) {
        log()
        guard rewardAvailable else {return}
        guard rewardedAd?.isReady ?? false else {return}
        
        rewardedAction = {consumable.earn(quantity)}
        if let window = window {
            rewardedAd?.present(fromRootViewController: window.rootViewController!, delegate:delegater!)
            rewardAvailable = false
        }
    }

    // MARK: - Internal handling
    // MARK: For Banner
    
    // MARK: For Rewards
    private let adUnitIdRewarded: String?
    private var rewardedAd: GADRewardedAd?
    fileprivate var rewardedAction: (() -> Void)?
    
    /// Load first reward. Is automatically called, when one reward was shown
    fileprivate func prepareReward() {
        guard let adUnitIdRewarded = adUnitIdRewarded else {return}
        
        rewardedAd = GADRewardedAd(adUnitID: adUnitIdRewarded)
        rewardedAd!.load(GADRequest()) {
            error in
            
            self.rewardAvailable = (error == nil)
            guard check(error) else {return}
        }
    }

    // MARK: For Interstitials
    internal private(set) var interstitial: GADInterstitial?
    private let adUnitIdInterstitial: String?

    /// Show Interstial if available. If not do nothing.
    internal func showInterstitial() {
        guard interstitial?.isReady ?? false else {return}
        if let window = window {
            interstitial!.present(fromRootViewController: window.rootViewController!)
        }
    }
    
    /// Load first interstitial. Is automatically called, when one interstitial was shown
    fileprivate func prepareInterstitial() {
        guard let adUnitIdInterstitial = adUnitIdInterstitial else {return}
        
        interstitial = GADInterstitial(adUnitID: adUnitIdInterstitial)
        interstitial!.delegate = delegater
        interstitial!.load(GADRequest())
    }
}

fileprivate var adUnitIdBanner: String? = nil
fileprivate var window: UIWindow? = nil
fileprivate var delegater: Delegater? = nil

/// The banner advertisement has fixed width and height. Should be positioned.
public struct GFBannerView: UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> UIViewController {
        log()
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        let viewController = UIViewController()

        view.adUnitID = adUnitIdBanner
        if let width = window?.frame.width {
            view.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
            GameFrame.instance.adMobImpl.bannerWidth = view.adSize.size.width
            GameFrame.instance.adMobImpl.bannerHeight = view.adSize.size.height
        }
        view.rootViewController = viewController

        viewController.view.addSubview(view)
        
        view.load(GADRequest())
        if let delegater = delegater {view.delegate = delegater}
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {log()}
}

private class Delegater: NSObject, GADBannerViewDelegate, GADRewardedAdDelegate, GADInterstitialDelegate {
    private var parent: GFAdMob
    
    fileprivate init(parent: GFAdMob) {
        log()
        self.parent = parent
    }
    
    // Banner events
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        log()
        parent.bannerAvailable = true
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        log()
        parent.bannerAvailable = false
        guard check(error) else {return}
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {log()}
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {log()}
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {log()}
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {log()}

    // Rewarded events
    internal func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        log()
        if let rewardedAction = parent.rewardedAction {rewardedAction()}
    }

    internal func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        log()
        parent.prepareReward()
    }
    
    internal func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        log()
        parent.rewardAvailable = false
        guard check(error) else {return}
    }

    // Interstitial events
    internal func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        log()
        parent.prepareInterstitial()
    }
}
