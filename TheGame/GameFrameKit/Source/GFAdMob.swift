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
    internal init(adUnitIdBanner _adUnitIdBanner: String?, adUnitIdRewarded _adUnitIdRewarded: String?, adUnitIdInterstitial _adUnitIdInterstitial: String?) {
        log()
        adUnitIdBanner = _adUnitIdBanner
        adUnitIdRewarded = _adUnitIdRewarded
        adUnitIdInterstitial = _adUnitIdInterstitial
        super.init()
        
        setBannerSize()

        delegater = Delegater(parent: self)
        prepareReward()
    }
    
    // MARK: - Public functions and properties
    // MARK: For banner
    @Published public internal(set) var bannerAvailable: Bool = false
    @Published public internal(set) var bannerSize: CGSize = .zero

    // MARK: For rewards
    /// True, if reward is loaded and available to be shown
    @Published internal(set) public var rewardAvailable: Bool = false

    /// Show the rewarded video. If succesfull, player earns quantity of consumable
    public func showReward(consumable: GFConsumable, quantity: Int, completionHandler: @escaping () -> Void = {}) {
        log(consumable, quantity)
        guard rewardAvailable else {return}
        guard rewardedAd?.isReady ?? false else {return}
        
        rewardedAction = {
            log(quantity)
            consumable.earn(quantity)
        }
        rewardedCompletion = completionHandler
        if let rootViewController = rootViewController {
            rewardedAd?.present(fromRootViewController: rootViewController, delegate:delegater!)
            rewardAvailable.unset()
        }
    }

    // MARK: - Internal handling
    /// Is connected to corresponding nonConsumable in GameFrame createInstance
    var wasBought: Bool = true { // Maybe bought already, which has priority
        didSet(prev) {
            log(prev, wasBought)
            guard wasBought != prev else {return} // has actually changed
            
            if wasBought {
                bannerAvailable = false
            } else {
                if adUnitIdBanner != nil {GADMobileAds.sharedInstance().start(completionHandler: nil)}
                prepareInterstitial()
            }
        }
    }
    fileprivate var gadAdSize: GADAdSize? = nil
    
    // MARK: For Banner
    fileprivate func setBannerSize() {
        gadAdSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
        bannerSize = gadAdSize!.size
    }
    
    // MARK: For Rewards
    private let adUnitIdRewarded: String?
    private var rewardedAd: GADRewardedAd?
    fileprivate var rewardedAction: (() -> Void)?
    fileprivate var rewardedCompletion: (() -> Void)?

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
    internal private(set) var interstitial: GADInterstitial? = nil
    private let adUnitIdInterstitial: String?

    /// Show Interstial if available. If not do nothing.
    internal func showInterstitial() {
        if wasBought {return}
        guard adUnitIdInterstitial != nil else {return}
        guard interstitial?.isReady ?? false else {return}
        
        if let rootViewController = rootViewController {
            interstitial!.present(fromRootViewController: rootViewController)
        }
    }
    
    /// Load first interstitial. Is automatically called, when one interstitial was shown
    fileprivate func prepareInterstitial() {
        if wasBought {return}
        guard let adUnitIdInterstitial = adUnitIdInterstitial else {return}
        
        interstitial = GADInterstitial(adUnitID: adUnitIdInterstitial)
        interstitial!.delegate = delegater
        interstitial!.load(GADRequest())
    }
}

fileprivate var adUnitIdBanner: String? = nil
fileprivate var delegater: Delegater? = nil

/// The banner advertisement has fixed width and height. Should be positioned.
public struct GFBannerView: UIViewControllerRepresentable {
    public init() {log()}
    
    public func makeUIViewController(context: Context) -> UIViewController {
        log()

        let viewController = UIViewController()
        
        // No adId? Do nothing and don't bother the network
        if GameFrame.instance.adMobImpl.wasBought {return viewController}
        guard let adUnitIdBanner = adUnitIdBanner else {return viewController}
        guard let gadAdSize = GameFrame.instance.adMobImpl.gadAdSize else {return viewController}
        
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        view.adSize = gadAdSize
        view.adUnitID = adUnitIdBanner
        view.rootViewController = viewController

        viewController.view.addSubview(view)
        if let delegater = delegater {view.delegate = delegater}
        
        view.load(GADRequest())
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        log()
        GameFrame.instance.adMobImpl.setBannerSize()

        if GameFrame.instance.adMobImpl.wasBought {return}
        guard let gadAdSize = GameFrame.instance.adMobImpl.gadAdSize else {return}
        guard let view = uiViewController.view.subviews.first as? GADBannerView else {return}
        view.adSize = gadAdSize
        view.load(GADRequest())
}
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
        if parent.wasBought {return}
        parent.bannerAvailable.set()
    }
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        log()
        parent.bannerAvailable.unset()
        guard check(error) else {return}
    }
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {log()}
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {log()}
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {log()}
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {log()}

    // Rewarded events
    internal func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        log(reward.amount)
        parent.rewardedAction?()
    }

    internal func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        log()
        parent.rewardedCompletion?()
        parent.prepareReward()
    }
    
    internal func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        log()
        parent.rewardAvailable.unset()
        guard check(error) else {return}
    }

    // Interstitial events
    internal func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        log()
        parent.prepareInterstitial()
    }
}
