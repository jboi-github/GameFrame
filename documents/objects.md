# Working with Scores, Achievements, Consumables and NonConsumables
The named objects are the most important to understand in **GameFrame**. All of them are maintained, stored safely and distributed to all of the players devices. They can be linked to products for in-app purchases and to GameCenter and open the door to all other functionality, **GameFrame** provides.

Let's give a short list:
1. **Scores**: Integer numbers to count things like points, energy or whatever your game needs. Usually the player earns these things during game play. A score has two attributes: `current` and `highest`, which is the players high score. A score is reset to 0, every time a new level starts. By calling `earn(score: Int)` the players score is increased.
2. **Achievements**: Float numbers to measure achievements like gold medals, levels etc. Usually the player earns these things during game play. An achievement has three attributes `current` and `highest` and `timesAchieved`. While `current` and `highest` can contain fractions, e.g. to indicate that an achievement was achieved up to 50%, the `timesAchieved` is the number of times the achievement was achieved. With `achieved(current: Double)` is the currnt level of achievement set.
3. **NonConsumables**: A switch to unlock goods in a game. Examples are unlocking a level, unlock a weapon, stop advertisements, etc. A NonConsumable has one boolean attribue `isOpened` and can be unlocked with `unlock()`.
4. **Consumables**: Examples are collectable goods, bullets, a number of hints and anything that can be earned or bought and will be consumed during gameplay. Consumables have one attribute `available` with provides the currently available number of goods that can be consumed. A player can `earn(earned: Int)` consumables and `consume(consumed: Int)` them.

## Make them part of your Game design
All Game development starts with an idea. Write doen the idea. Then articulate it in a way, that explains, when a player earns and consumes, when he unlocks something and what he can achieve. It's all about getiing scored and compete against others. We see this now a days as Gameification in a lot of aspects in the world.

As soon as you've described your game wth scores, achievements, consumables and non-consumables, you've done a lot of the analytics work. You know what you need. Name each of them. That's all it needs.

## How to create them
You simply create them with a call to one of the `GameFrame.coreData.get...` functions. **GameFrame** looks for them in the local core data. If they're not available, it creates them with currents and highest of 0. If, at any time, an update from any other device arrives, it is merged to the local status. Whatever is the highest value is taken as new `highest`, whenever a non-consumable was unlocked, it is unlocked on all devices and so on. Whatever was bought around consumables will be available on devices but can be consumed only once across all devices.

Here's an example call to ContentView that gets and/or creates a score called "Points", an achievement called "Medals", two consumable called "Bullets" and "Lives" and a non-consumable called "weaponB":

    ContentView(
        points: GameFrame.coreData.getScore("Points"),
        medals: GameFrame.coreData.getAchievement("Medals"),
        bullets: GameFrame.coreData.getConsumable("Bullets"),
        lives: GameFrame.coreData.getConsumable("Lives"),
        weaponB: GameFrame.coreData.getNonConsumable("weaponB"))

The ContentView now has access to the five measures to get the current status of the game.
A little side note here: You could also use `@environment` to pass the values between views. It's a personal thing, that I dont like them as they look to me like global variables. I personally prefer the way shown here, using `@ObservedObjects`

## Show status to player
Within ContenView, three steps let the player check an attribute:
1. Add `import GameFrameKit` to the list of imports in `ContentView.swift`
2. Define the variable for, let's say points, just below the `struct ContentView: View {`. There, the line `@ObservedObject var points: GFScore` defines `points` to be known as a score.
3. Inside the View, put the value into a Text-View. Example: `Text("Points: \(points.current)")`. This view will update whenever (and wherever) you call `points.earn()` or any other change to the score happens.

## Actions to be taken
Call `earn()` to increase the score. Anything else is done by **GameFrame**:
- Save score when player leaves the App or a level ends
- Load from local store when available
- Sync with iCloud

## A working example
Check [TheGame/Delegates/SceneDelegate.swift]() to see, how the objects are defined and [TheGame/Views/MainView.swift]() for an example how they're used.

## Where to go from here
Now you have your Game status reflected, you can let the player buy more of it or let them compete in Leaderboards in GameCenter.
- [Link Scores and Achievements to GameCenter]()
- [Link Consumables and NonConsumables for in-app purchases]()

