> <img src="https://github.com/hauntarl/hauntarl/blob/master/tmdb/TMDBLogo.svg" width="150">

A concept movie database app developed using SwiftUI, utilizing [themoviedb](https://developer.themoviedb.org/docs/getting-started) APIs.

Design inspired by [dribbble](https://dribbble.com/shots/17158465-Movie-App).

- Developed by: [Sameer Mungole](https://www.linkedin.com/in/sameer-mungole/)
- Using XCode Version **15.3 (15E204a)**
- Minimum deployment: **iOS 17.4**
- Tested on **iPhone 15** (Physical device), and **iPhone 15 Pro** (Simulator)
- Supports **portrait-up** device orientation

> **Note:** Requires stable internet connection for the application to function optimally.

I would appreciate your feedback and suggestions for further improvements in this project to better adhere to the industry standards for developing mobile applications.

## How To

You need to create and set an *API key* in the **Secrets.yml** file, this key is accessed by the application at run-time through the app's main bundle.
The contents should be in the following format:
```yml
api_key: YOUR_API_KEY
```
Once you set up your *API key* you can build and run the application to test it.

> **Note:** Generate your *API key* under [My API Settings](https://www.themoviedb.org/settings/api) from [themoviedb](https://developer.themoviedb.org/docs/getting-started).

## Techniques Used

- The [Model-View (MV)](https://forums.developer.apple.com/forums/thread/699003) architecture
- ***NSCache*** for caching images in memory
- ***Task Groups*** to bulk download images before displaying content
- *[NetworkImage](https://github.com/hauntarl/tmdb/blob/main/TMDB/Components/NetworkImage.swift)* component that utilizes *NSCache* for fetching images
- Custom ***decoding/encoding*** strategies to perform data transformation and cleaning
- ***Document-based*** persistent storage to save user’s *favorite* movies
- *[Debouncer](https://github.com/hauntarl/tmdb/blob/main/TMDB/Models/Debouncer.swift)* for the search text field to reduce the number of search API calls
- Custom *[components, shapes](https://github.com/hauntarl/tmdb/tree/main/TMDB/Components)*, and *[fonts](https://github.com/hauntarl/tmdb/tree/main/TMDB/Fonts)* for enhanced user experience
- ***Environment and Preference*** keys for data propagation through the view hierarchy
- Doc comments to improve code readability

## Resources

- [Protocol-based mocking](https://www.swiftbysundell.com/articles/dependency-injection-and-unit-testing-using-async-await/#:~:text=Protocol%2Dbased%20mocking)
- [Caching Strategies for iOS Applications](https://grokkingswift.io/caching-strategies-for-ios-applications/)
- [Pro SwiftUI](https://www.hackingwithswift.com/store/pro-swiftui) by *Paul Hudson*
- [Move TextField up when the keyboard has appeared in SwiftUI](https://stackoverflow.com/a/60178361)
- [Custom font in framework for SwiftUI](https://stackoverflow.com/a/66105745)
- Attribution, Logos, and Colors - [themoviedb](https://www.themoviedb.org/about/logos-attribution)
- Fonts [License](https://fonts.google.com/specimen/Jost/about)

## Next Steps

- Show movies from other categories like [popular](https://developer.themoviedb.org/reference/movie-popular-list), [top-rated](https://developer.themoviedb.org/reference/movie-top-rated-list), and [upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
- Add pagination support to load more movies once the user reaches the end of the carousel
- Add support for scrolling through carousel items using previous and next buttons
- Switch persistent storage from *Documents-based* to *SwiftData*
- Improve robustness by handling network failure situations
