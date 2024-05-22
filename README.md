<br>

<p align="center">
  <picture> 
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Mijick/Assets/blob/main/NavigationView/Logotype/On%20Dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mijick/Assets/blob/main/NavigationView/Logotype/On%20Light.svg">
    <img alt="NavigationView Logo" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Logotype/On%20Dark.svg" width="76%"">
  </picture>
</p>

<h3 style="font-size: 5em" align="center">
    Navigation made simple
</h3>
                                                                                                                                          
<p align="center">
    Improve the navigation in your project in no time. Keep your code clean
</p>
                 
<p align="center">
    <a href="https://github.com/Mijick/NavigationView-Demo" rel="nofollow">Try demo we prepared</a>
    |
    <a href="https://github.com/orgs/Mijick/projects/5" rel="nofollow">Roadmap</a>
    |
    <a href="https://github.com/Mijick/NavigationView/issues/new" rel="nofollow">Propose a new feature</a>
</p>
                                                                      
<br>

<p align="center">
    <img alt="Designed for SwiftUI" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/Language.svg"/>
    <img alt="Platforms: iOS" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/Platforms.svg"/>
    <img alt="Current Version" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/Version.svg"/>
    <img alt="License: MIT" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/License.svg"/>
</p>

<p align="center">
    <img alt="Made in Kraków" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/Origin.svg"/>
    <a href="https://twitter.com/MijickTeam">
        <img alt="Follow us on X" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/X.svg"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/Work%20with%20us.svg"/>
    </a>  
    <a href="https://github.com/Mijick/NavigationView/stargazers">
        <img alt="Stargazers" src="https://github.com/Mijick/Assets/blob/main/NavigationView/Labels/Stars.svg"/>
    </a>                                                                                                               
</p>

<p align="center">
    <img alt="NavigationView Examples" src="https://github.com/Mijick/Assets/blob/main/NavigationView/GIFs/NavigationView-1.gif" width="24.5%"/>
    <img alt="NavigationView Examples" src="https://github.com/Mijick/Assets/blob/main/NavigationView/GIFs/NavigationView-2.gif" width="24.5%"/>
    <img alt="NavigationView Examples" src="https://github.com/Mijick/Assets/blob/main/NavigationView/GIFs/NavigationView-3.gif" width="24.5%"/>
    <img alt="NavigationView Examples" src="https://github.com/Mijick/Assets/blob/main/NavigationView/GIFs/NavigationView-4.gif" width="24.5%"/>
</p>

<br>

NavigationView by Mijick is a powerful, open-source library dedicated for SwiftUI that makes navigation process super easy and much cleaner.
* **Custom animations.** Our library provides full support for any animation.
* **Improves code quality.** Navigate through your screens with just one line of code. Focus on what’s important to you and your project, not on Swift's intricacies.
* **Stability at last!** At Mijick, we are aware of the problems that were (and still are) with the native NavigationView and how many problems it caused to developers. Therefore, during the development process we put the greatest emphasis on the reliability and performance of the library.
* **Designed for SwiftUI.** While developing the library, we have used the power of SwiftUI to give you powerful tool to speed up your implementation process.

<br> 

# Getting Started
### ✋ Requirements

| **Platforms** | **Minimum Swift Version** |
|:----------|:----------|
| iOS 15+ | 5.0 |

### ⏳ Installation
    
#### [Swift package manager][spm]
Swift package manager is a tool for automating the distribution of Swift code and is integrated into the Swift compiler.

Once you have your Swift package set up, adding NavigationView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/NavigationView", branch(“main”))
]
```


#### [Cocoapods][cocoapods]   
Cocoapods is a dependency manager for Swift and Objective-C Cocoa projects that helps to scale them elegantly.

Installation steps:
- Install CocoaPods 1.10.0 (or later)
- [Generate CocoaPods][generate_cocoapods] for your project
```Swift
    pod init
```
- Add CocoaPods dependency into your `Podfile`   
```Swift
    pod 'MijickNavigationView'
```
- Install dependency and generate `.xcworkspace` file
```Swift
    pod install
```
- Use new XCode project file `.xcworkspace`
<br>

    
# Usage
### 1. Setup library
Inside your `@main` structure, call the `implementNavigationView` method with the view that is to be the root of the navigation stack. The view must be of type `NavigatableView`. The method takes an optional argument - `config`, which can be used to configure certain attributes of all the views that will be placed in the navigation stack.
                      
```Swift
@main struct NavigationView_Main: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
               .implementNavigationView(config: nil)                    
        }
    }
}
```
                      
### 2. Declare structure of the view you want to push
NavigationView provides the ability to push (or pop) any view using its built-in stack. In order to do so, it is necessary to confirm to `NavigatableView` protocol.
So that an example view you want to push will have the following declaration:
```Swift
struct ExampleView: NavigatableView {
    ...
}
```
                      
### 3. Implement `body` method
Fill your view with content
                      
```Swift
struct ExampleView: NavigatableView {    
    var body: some View {
        VStack(spacing: 0) {
            Text("Witaj okrutny świecie")
            Spacer()
            Button(action: pop) { Text("Pop") } 
        }
    }
    ...
}
```
                      
### 4. Implement `configure(view: NavigationConfig) -> NavigationConfig` method
*This step is optional - if you wish, you can skip this step and leave the configuration as default.*<br/>
Each view has its own set of methods that can be used to customise it, regardless of the config we mentioned in **step 1**.
                      
```Swift
struct ExampleView: NavigatableView {   
    func configure(view: NavigationConfig) -> NavigationConfig { view.backgroundColour(.red) }
    var body: some View {
        VStack(spacing: 0) {
            Text("Witaj okrutny świecie")
            Spacer()
            Button(action: pop) { Text("Pop") } 
        }
    }
    ...
}
```
                      
### 5. Present your view from any place you want!
Just call `ExampleView().push(with:)` from the selected place
                      
```Swift
struct SettingsViewModel {
    ...
    func openSettings() {
        ...
        ExampleView().push(with: .verticalSlide)
        ...
    }
    ...
}
```
                      
### 6. Closing views
There are two ways to do so:
- By calling one of the methods `pop`, `pop(to type:)`, `popToRoot` inside any view
                      
```Swift
struct ExampleView: NavigatableView {
    ...
    func createButton() -> some View {
        Button(action: popToRoot) { Text("Tap to return to root") } 
    }
    ...
}
```
- By calling one of the static methods of NavigationManager:
    - `NavigationManager.pop()`
    - `NavigationManager.pop(to type:)` where type is the type of view you want to return to
    - `NavigationManager.popToRoot()`   
                      
<br>
      
# Try our demo
See for yourself how does it work by cloning [project][Demo] we created
                      
# License
NavigationView is released under the MIT license. See [LICENSE][License] for details.
                      
<br><br>
                      
# Our other open source SwiftUI libraries
[PopupView] - The most powerful popup library that allows you to present any popup
<br>
[CalendarView] - Create your own calendar object in no time
<br>
[GridView] - Lay out your data with no effort
<br>
[CameraView] - The most powerful CameraController. Designed for SwiftUI
<br>
[Timer] - Modern API for Timer


                      
[MIT]: https://en.wikipedia.org/wiki/MIT_License
[spm]: https://www.swift.org/package-manager
[cocoapods]: https://cocoapods.org/
[generate_cocoapods]: https://github.com/square/cocoapods-generate
                      
[Demo]: https://github.com/Mijick/NavigationView-Demo
[License]: https://github.com/Mijick/NavigationView/blob/main/LICENSE
                     
[PopupView]: https://github.com/Mijick/PopupView
[CalendarView]: https://github.com/Mijick/CalendarView 
[CameraView]: https://github.com/Mijick/CameraView
[GridView]: https://github.com/Mijick/GridView
[Timer]: https://github.com/Mijick/Timer
