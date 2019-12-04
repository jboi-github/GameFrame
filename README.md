# **GameFrame**
All your iOS game needs. Apart from the game.

![**GameFrame** Logo](./images/GameFrame.png)

**GameFrame** is a FrameWork, that implements all the nitty-gritty code-snippets for InApp purchases, GameCenter, synchronization of CoreData and iCloud, advertisements, player reviews and more. You can simply add it to your project and design and develop your game idea.

Implementing all this features is necessary to earn money with the App but often not the first priority. Learning how it works means to read a lot of documentation - often ending in a few lines of code for each.
I read all the documents, ran through deploying Apps based on the extracted code and bundled it then in this FrameWork.

## What it implements
The FrameWork is designed to support on two levels: The Model with the **GameFrameKit** and for the UI with **GameUIKit**.
### **GameFrameKit** does the low-level work behind the scenes.
It implements four object-types:
    - **Scores** are integers to count things. Examples are points, energy etc. The correspond to GameCenter-Leaderboards.
    - **Achievements** are defined as float number where 1.0 means, that the achievement was achieved one time. They correspond to GameCenter Achievements
    - **Consumables** are things the player consumes. Examples are bullets, fuel etc. They correspond to AppStore consumables.
    - **NonConsumables** are one time triggers, that a player can buy or earn. Examples are weapons, unlocked levels or the removal of advertisements. NonConsumables correspond to the same objects in the AppStore. **GameFrameKit** defines a special NonConsumable so that the player can buy removal of advertisements
    With this four types it enables to:
    - Synchronize all objects to local storage (**CoreData**) as well as to the **iCloud**. The player gets all objects synchronized across all devices, that are connected with the same Apple-Id
    - Synchronize all scores and achievements with the corresponding objects in **GameCenter**
    - Implement a **Share** Button, so that the player can share game experience with others via social media channels. It automatically fills AppName, logo, a screenshot, a message body with a greeting and formatted text around the obejcts, that you define.
    - It enables banners, rewarded videos and interstitials via AdMob.
    - InApp purchases
    - Audio, Reviews
    
The idea is simple. Four types of objects define the status of your game:
1. **Scores**: Integer numbers to count things like points, energy or whatever your game needs. Usually the player earns these things during game play. A score can be linked to a GameCenter Leaderboard by giving the **GameFrame**-Score the same ID as the Leaderboard in GameCenter has. In this case, if the player is logged in to GameCenter, scores are automatically reported when player leaves a level, the game or switches to another app. The score is locally saved in the same cases and synchronized with iCloud, if the player is logged in with an Apple-Id.
2. **Achievements**: Float numbers to measure achievements like gold medals, levels etc. Usually the player earns these things during game play. An achievement can be linked to a GameCenter Achievements by giving the **GameFrame**-Achievement the same ID as the Achievement in GameCenter has. In this case, if the player is logged in to GameCenter, achievements are automatically reported when player leaves a level, the game or switches to another app. The achievement is locally saved in the same cases and synchronized with iCloud, if the player is logged in with an Apple-Id.
3. **NonConsumables**: Products in the store for in-app purchases. Examples are unlocking a level, stop advertisements, etc. NonConsumables can be linked to the app store by giving the **GameFrame**-NonConsumable the same ID as the NonConsumable product in the Apple Store has. NonConsumables can be bought one time.
4. **Consumables**: Products in the store for in-app purchases. Examples are collectable goods, bullets, a number of hints and anything that can be earned or bought and will be consumed during gameplay. **GameFrame** allows consumables to be purchased in store, earned by game play or earned by rewarded videos. It also allows to configure for non-linear pricing (decoy-effect). For example, you have a consumable, say 'bullets' and offer a product to buy them as in-app purchase. You have a product for 10 bullets at 0.99$, one product for 50 bullets at 2.99$ and 100 bullets for 5.99$. **GameFrame** can handle this situation.

With this four objects, you get:
- Automatic saving locally and synchronized with iCloud. Synchronized, means uploaded to iCloud and automatically downloaded and merged with current play, when changes happened on another device, which is logged in with the same Apple-Id
- Show screen when requested and avialable:
  - GameCenter: Either the GameCenter itself or login screen to it as provided by Apple
  - Review and Feedback alert: You can ask Apple to show their review alert and additionally have the external URL for use with a user interaction like a button, to directly link to the review page in the AppStore.
  - A BannerView is provided for Banner advertisements. An interstitial can be shown at end of a level if available. A rewarded video can be shown with a reward - usually earnings for a consumable - given on success.
  - Any external links are possible, like calling Facebook, Instagram or the settings app on the iPhone/iPad. Allows to link to your community pages in social networks.
- For in-app purchases:
  - The list for available consumables or non-consumables, depending on age of the player, country, network conditions and what you configured is given back
  - Just call `buy` or `restore` in **GameFrame** and it handles all the rest for you until the purchase is done and reflected in one of th objects
  - If the purchase is deferred, e.g. an authorized person has to approve the purchase and the spent money, **GameFrame** acts like the purchase was succesful and is able to rollback, if the purchase fails later. This works only for one active purchase at a time to minimize possible misuse.
- Everything, that can be shown in views or allow interaction to the player has observable variables for SwiftUI. This allows to hide or disable buttons, when the player disables for example GameCenter or there's no rewarded video loaded at the moment etc.

## How to use in your project

## Checklist to setup a project with full featured **GameFrame**
- [ ] Clone the **GameFrame** repository.
- [ ] Under "GameFrameKit" open the `GameFrameKit` project in XCode and build it (Cmd-B)
- [ ] Create a new project for your App, give it a name and ensure the following features:
  - [ ] Check "Use CoreData" and "Use CloudKit"
  - [ ] Find a place in your folder structure, ensure that "Don't add to any project or workspace" is selected
  - [ ] In the project setting, "Signing&Capabilities" add:
    - [ ] "iCloud", check "CloudKit" and create a new container or check an existing one. This will also add the "Push Notifications" capability
    - [ ] "In-App Purchase"
    - [ ] "Game Center"
    - [ ] "Background Modes", here check the "Remote Notifications" to get notified on changes in iCloud-Data, when changed on other devices of your player.
  - [ ] Drag and drop in XCode, from the window that has the **GameFrame** project open, the **GameFrame** product `GameFrameKit.framework` into the XCode window that has your project open, somewhere on top of your project-groups.
  - [ ] In the Xcode Project Navigator, click on your project and then select the target. In the "General" tab scroll down to "Frameworks, Libraries and Embedded Content" and ensure, that `GameFrameKit.framework` is set to "Embed & Sign"
- [ ] Make changes to `AppDelegate.swift` and `SceneDelegate.swift`. For all changes, check the same two files in "TheGame" folders to get an example.
  - [ ] In `AppDelegate.swift` delete the function `saveContext()` and the variable `persistentContainer`
  - [ ] In `SceneDelegate.swift`
    1. Add the `import GameFrame` at the beginning.
    2. In the function `scene( ... willConnectTo: ...)` delete the code in it and replace it with a simple first call to **GameFrame**: `GameFrame.createSharedInstance(scene, consumablesConfig: [:], adUnitIdBanner: nil, adUnitIdRewarded: nil, adUnitIdInterstitial: nil) {ContentView()}`
    3. In the function `sceneDidEnterBackground` delete the call to `saveContext`
    - [ ] In your `info.plist` add your AppID for Google AdMob as described in [Update Your `info.plist`](https://developers.google.com/admob/ios/quick-start#update_your_infoplist)
- [ ] To use **GameFrame** in Previews add a line in the view file (e.g. `ContentView.swift`). In the file scroll down to the Preview Provider `<View-Name>_Previews` and add the call to **GameFrame** ricgt before the view is created. Use the `createSharedInstanceForPreview` which has less attributes and is lacks all the external windows features like GameCenter and AdMob.
  - Check TheGame implementation to see how it works, e.g. here in [`ContenView.swift`](./TheGame/TheGame/ContentView.swift)
  - Remark: SwiftUI PreView is still buggy. So please don't blame me, if it shows it's famous "try again"/"Diagnostics" buttons.
- [ ] Build your App and run it. Nothing should happen other than, that it works.  
- [ ] Close the XCode window, where you have built the `GameFrameKit.framework` project.
  
  ### Congratulations! Your're done with the setup and start using **GameFrame**
  What's next:
  - [Work with Scores, Achievements, Consumables and NonConsumables](./documents/objects.md)
  - [Link Scores and Achievements to GameCenter](./documents/gameCenter.md)
  - [Link Consumables and NonConsumables for in-app purchases](./documents/inApps.md)
  - [Get players reviews and feedback](./documents/reviews.md)
  - [Connect to Social Media](./documents/externalLinks.md)
  - [A Button to your App Settings](./documents/settings.md)
  - [Add advertisement banners to your App](./documents/banners.md)
  - [Add advertisement interstitials to your App](./documents/interstitials.md)
  - [Add rewarded videos to your App](./documents/rewardedVideos.md)

## Checklist to deploy ready implemented App
You're ready to go? Did all the implementation? It's tested? It's profiled and performance tuned?

Then, let's go!

Here's a list of things, that probably need to be done now before deployment. 
- [ ] In `AppDelegate.swift`, function `application(...didFinishLaunchingWithOptions...)` add the line `maxLogLevel = 0` to save performance and do not write log-messages (not even generating them)
- [ ] In your call to `GameFrame.createSharedInstance()` (probably in `SceneDelegate.swift`) change the `adUnitIdXXXXX` parameters to the values, that Google has provided to you for banners, interstitials and rewarded videos.
- [ ] In the iCloud-Dashboard deploy the schema of your Container to production
- [ ] Build for Release
- [ ] Retest this. I've seen more then often, that the Debug-Compilation did work, but the Release not.
- [ ] Take a deep breath... Still sure? Yes? Then...
- [ ] Deploy

## More good readings
At least some, that I like and helped me. 
- [40 secrets to make money with in-app-purchases](https://www.raywenderlich.com/2700-40-secrets-to-making-money-with-in-app-purchases)
