<br>

<p align="center">
   <img alt="Navigattie Logo" src="https://github.com/Mijick/Navigattie/assets/23524947/6b8a20f0-2b68-4c10-a3b8-9a98e8838101" width="88%"">
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
    <img alt="SwiftUI logo" src="https://github.com/Mijick/Navigattie/assets/23524947/1c4d7a3a-bfe7-42f4-bb81-276603c8c603"/>
    <img alt="Platforms: iOS" src="https://github.com/Mijick/Navigattie/assets/23524947/ef0ddf24-3031-42da-a704-dbc596a642b1"/>
    <img alt="Release: 0.3.1" src="https://github.com/Mijick/Navigattie/assets/23524947/521ef500-b102-43ab-8ed4-58212575e138"/>
    <a href="https://www.swift.org/package-manager">
        <img alt="Swift Package Manager: Compatible" src="https://github.com/Mijick/Navigattie/assets/23524947/2b9d020a-7109-4bf9-9515-f217d3eb7965"/>
    </a>
    <img alt="License: MIT" src="https://github.com/Mijick/Navigattie/assets/23524947/d511695a-95b8-44f3-8668-3285b3f19780"/>
</p>

<p align="center">
    <a href="https://github.com/Mijick/Navigattie/stargazers">
        <img alt="Stars" src="https://github.com/Mijick/Navigattie/assets/23524947/47c688ba-be1b-46b8-ae2e-bd3035522239"/>
    </a>
    <img alt="Made in Kraków" src="https://github.com/Mijick/Navigattie/assets/23524947/56f6286e-0c3f-4fd0-9537-04a20372899b"/>                                                                                                                   
    <a href="https://twitter.com/tkurylik">
        <img alt="Follow us on Twitter" src="https://github.com/Mijick/Navigattie/assets/23524947/42d580e4-143c-462d-a421-518eb7d9b3fb"/>
    </a>
    <a href=mailto:team@mijick.com?subject=Hello>
        <img alt="Let's work together" src="https://github.com/Mijick/Navigattie/assets/23524947/8012c25f-c722-442a-9c83-cc986e9a339d"/>
    </a>             
</p>

<p align="center">
    <img alt="Navigattie Examples" src="https://github.com/Mijick/Navigattie/assets/23524947/096ad4ed-fab4-41fb-bc7c-f28bfa85c0df"/>
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
| iOS 15+, iPadOS 15+ | 5.0 |

### ⏳ Installation
    
#### [Swift package manager][spm]
Swift package manager is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding PopupView as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Mijick/Navigattie", branch(“main”))
]
``` 
<br>
    
# Usage
### 1. Setup library
Inside the `@main` structure, call the `implementNavigationView(config: Optional)` method on the view that is to be the root view in your navigation structure. 
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
Each view has its own set of methods that can be used to customise it, regardless of the config we mentioned in `step 1`.
                      
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
Just call `ExampleView().push(with: Animation)` from the selected place
                      
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
- By calling one of the methods `pop`, `pop(to type: NavigatableView.Type)`, `popToRoot` inside any view
                      
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
    - `NavigationManager.pop(to type: NavigatableView.Type)` where type is the type of view you want to return to
    - `NavigationManager.popToRoot()`   
                      
<br>
      
# Try our demo
See for yourself how does it work by cloning [project][Demo] we created
                      
# License
Navigattie is released under the MIT license. See [LICENSE][License] for details.

                    
                      
[MIT]: https://en.wikipedia.org/wiki/MIT_License
[SPM]: https://www.swift.org/package-manager
[Demo]: https://github.com/Mijick/Navigattie-Demo
[License]: https://github.com/Mijick/Navigattie/blob/main/LICENSE
