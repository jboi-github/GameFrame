# Add advertisement banners to your App
Banners are on the top or bottom of the screen and show advertisements. The longer and more often these advertisements are shown, the more money you earn.

## Setup Google's AdMob
On Google's adMob get a banner and note the corresponding `adUnitID`

## Add a view for banners
1. Add the given `adUnitID` the the call to **GameFrame** as parameter `adUnitIdBanner`in `SceneDelegate.swift`.If you're still testing take Googles test-Id and replace it before distributing the App.
2. Put a `GFBannerView()` into your View ad size it with the given attributes of `GameFrame.adMob`. Check [TheGame/Views/MainView.swift]() for a working example.

A few remarks of BannerView:
- As a banner is not always provided by Google, it is necessary to give n alternative. In TheGame this is the text "Thank you..." but it can be any view.
- Nevertheless, to get the sizes, it is necessary to call the `GFBannerView()`. Even if nothing is available.
- You must explicitely size the banner due to Gogls's way of setting this up
- The way, TheGame implements the Banner is optimal for revenue. It stays fixed all the time the app runs, during levels and between them.

## Test and production
Make sure to change in `SceneDelegate.swift`, in the call to `GameFrame.create...() `the paramter `adUnitIdBanner` to the number, that Google has provided. Otherwise you'll not earn any money with banners.
