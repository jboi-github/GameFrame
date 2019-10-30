# GameFrame
All your iOS game needs. Apart from the game.

![GameFrame Logo](./images/GameFrame.png)

GameFrame is a FrameWork, that implements all the nitty-gritty little code for InApp purchases, GameCenter, synchronization of CoreData and iCloud, advertisements, players reviews and more. You can simply add it to your project and design and develop your game idea.

Implementing all this features is necessary to earn money with the App but often not the first priority. Learning how it works means to read a lot of documentation - often ending in a few lines of code for each.
I read all the documents, ran through deploying Apps based on the extracted code and bundled it then in this FrameWork.

## What it implements
The idea is simple. Four types of objects define the status of your game:
1. Scores: Integer numbers to count things like points, energy or whatever your game needs. Usually the player earns these things during game play. A score can be linked to a GameCenter Leaderboard by giving the GameFrame-Score the same ID as the Leaderboard in GameCenter has. In this case, if the player is logged in to GameCenter, scores are automatically reported when player leaves a level, the game or switches to another app. The score is locally saved in the same cases and synchronized with iCloud, if the player is logged in with an Apple-Id.
2. Achievements: Float numbers to measure achievements like gold medals, levels etc. Usually the player earns these things during game play. An achievement can be linked to a GameCenter Achievements by giving the GameFrame-Achievement the same ID as the Achievement in GameCenter has. In this case, if the player is logged in to GameCenter, achievements are automatically reported when player leaves a level, the game or switches to another app. The achievement is locally saved in the same cases and synchronized with iCloud, if the player is logged in with an Apple-Id.
3. NonConsumables: Products in the store for in-app purchases. Examples are unlocking a level, stop advertisements, etc. NonConsumables can be linked to the app store by giving the GameFrame-NonConsumable the same ID as the NonConsumable product in the Apple Store has. NonConsumables can be bought one time.
4. Consumables: Products in the store for in-app purchases. Examples are collectable goods, bullets, a number of hints and anything that can be earned or bought and will be consumed during gameplay. GameFrame allows consumables to be purchased in store, earned by game play or earned by rewarded videos. It also allows to configure for non-linear pricing (decoy-effect). For example, you have a consumable, say 'bullets' and offer a product to buy them as in-app purchase. You have a product for 10 bullets at 0.99$, one product for 50 bullets at 2.99$ and 100 bullets for 5.99$. GameFrame can handle this situation.

With this four objects, you get:
- Automatic saving locally and synchronized with iCloud. Synchronized, means uploaded to iCloud and automatically downloaded and merged with current play, when changes happened on another device, which is logged in with the same Apple-Id
- Show screen when requested and avialable:
  - GameCenter: Either the GameCenter itself or login screen to it as provided by Apple
  - Review and Feedback alert: You can ask Apple to show their review alert and additionally have the external URL for use with a user interaction like a button, to directly link to the review page in the AppStore.
  - A BannerView is provided for Banner advertisements. An interstitial can be shown at end of a level if available. A rewarded video can be shown with a reward - usually earnings for a consumable - given on success.
  - Any external links are possible, like calling Facebook, Instagram or the settings app on the iPhone/iPad. Allows to link to your community pages in social networks.
- For in-app purchases:
  - The list for available consumables or non-consumables, depending on age of the player, country, network conditions and what you configured is given back
  - Just call `buy` or `restore` in GameFrame and it handles all the rest for you until the purchase is done and reflected in one of th objects
  - If the purchase is deferred, e.g. an authorized person has to approve the purchase and the spent money, GameFrame acts like the purchase was succesful and is able to rollback, if the purchase fails later. This works only for one active purchase at a time to minimize possible misuse.
- Everything, that can be shown in views or allow interaction to the player has observable variables for SwiftUI. This allows to hide or disable buttons, when the player disables for example GameCenter or there's no rewarded video loaded at the moment etc.

## How to use in your project

## Checklist to setup a project with full featured GameFrame
- [ ] Clone the GameFrame project and build it
- [ ] Create a new project for your App, give it a name and ensure the follwoign features:
  - [ ] Check "Use CoreData" and "Use CloudKit"
- [ ] Find a place in your folder structure, ensure that "Don't add to any project or workspace" is selected
- In the project setting, "Signing&Capabilities" add:
  - [ ] "iCloud", check "CloudKit" and create or check a container. This will also add the "Push Notifications" capability
  - [ ] "In-App Purchase"
  - [ ] "Game Center"
  - [ ] "Background Modes", here check the "Remote Notifications" to get notified on changes in iCloud-Data, when changed on other devices
- [ ] Now you have a Framework folder in your project. Drag and drop in XCode, from the window that has the GameFrame project open, the GameFrame product `GameFrame.framework` into the XCode window that has your project open, into the Framework-Folder. 
  - [ ] Check "Copy items if needed"
  
Close the GameFrame project.

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
