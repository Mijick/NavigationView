<br>

<p align="center">
  <picture> 
    <source media="(prefers-color-scheme: dark)" srcset="https://github.com/Mijick/Assets/blob/main/Navigattie/Logotype/On%20Dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mijick/Assets/blob/main/Navigattie/Logotype/On%20Light.svg">
    <img alt="Navigattie Logo" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Logotype/On%20Dark.svg" width="76%"">
  </picture>
</p>

<h3 style="font-size: 5em" align="center">
    Navigation made simple
</h3>
                                                                                                                                          
<p align="center">
    Implement navigation in your project in no time. Keep your code clean
</p>
                 
<p align="center">
    <a href="https://github.com/Mijick/Navigattie-Demo" rel="nofollow">Try demo we prepared</a>
</p>
                                                                      
<br>

<p align="center">
    <img alt="Library in beta version" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/Beta.svg"/>
    <img alt="Designed for SwiftUI" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/Language.svg"/>
    <img alt="Platforms: iOS" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/Platforms.svg"/>
    <img alt="Current Version" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/Version.svg"/>
    <img alt="License: MIT" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/License.svg"/>
</p>

<p align="center">
    <img alt="Made in Kraków" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/Origin.svg"/>
    <a href="https://twitter.com/MijickTeam">
        <img alt="Follow us on X" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/X.svg"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/Work%20with%20us.svg"/>
    </a>  
    <a href="https://github.com/Mijick/Navigattie/stargazers">
        <img alt="Stargazers" src="https://github.com/Mijick/Assets/blob/main/Navigattie/Labels/Stars.svg"/>
    </a>                                                                                                               
</p>

<p align="center">
    <img alt="Navigattie Examples" src="https://github.com/Mijick/Assets/blob/main/Navigattie/GIFs/Navigattie.gif"/>
</p>

<br>

Navigattie is a free, and open-source library for SwiftUI that makes navigation easier and much cleaner.
* **Improves code quality.** Push your view using the `push(with:)` method.<br/>
    Pop the selected one with `pop()`. Simple as never.
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

Once you have your Swift package set up, adding Navigattie as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/Navigattie", branch(“main”))
]
``` 
                      
<br>
    
# Usage
### 1. Setup library
Inside the `@main` structure, call the `implementNavigationView(config:)` method on the view that is to be the root view in your navigation structure. 
The view to be the root must be of type `NavigatableView`. The method takes an optional argument - `config`, that can be used to configure some modifiers for all navigation views in the application.
                      
```Swift
  var body: some Scene {
        WindowGroup {
            ContentView()
               .implementNavigationView(config: nil)                    
        }
  }
```
                      
### 2. Declare structure of the view you want to push
Navigattie provides the ability to push (or pop) any view using its built-in stack. In order to do so, it is necessary to confirm to `NavigatableView` protocol.
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
Navigattie is released under the MIT license. See [LICENSE][License] for details.
                      
<br><br>
                      
# Our other open source SwiftUI libraries
[PopupView] - The most powerful popup library that allows you to present any popup
<br>
[GridView] - Lay out your data with no effort
<br>
[Timer] - Modern API for Timer


                      
[MIT]: https://en.wikipedia.org/wiki/MIT_License
[SPM]: https://www.swift.org/package-manager
                      
[Demo]: https://github.com/Mijick/Navigattie-Demo
[License]: https://github.com/Mijick/Navigattie/blob/main/LICENSE
                     
[PopupView]: https://github.com/Mijick/PopupView
[GridView]: https://github.com/Mijick/GridView
[Timer]: https://github.com/Mijick/Timer
