# Pokemon_UIKit
<body>
  <div align="center">
    <img src="https://img.shields.io/static/v1?label=XCode%20Version&message=13.4.1&color=brightgreen&logo=xcode" alt="Xcode version 13">
    <img src="https://img.shields.io/static/v1?label=Swift%20Version&message=5.6&color=brightgreen&logo=swift" alt="Swift Version 5.5">
    <img src="https://img.shields.io/static/v1?label=Framework&message=UIKit&color=brightgreen&logo=Swift&logoColor=blue">
  </div>
  <p>This is a sample Project for fetching data from <a href="https://pokeapi.co">PokeAPI</a> in Swift &amp; UIKit</p>
  <ul>
    <li>This Application is full written in Swift.</li>
    <li>UI has been implemented implemented with UIKit.</li>
    <li>The http client for API requests leverage the latest <a href="https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html">Swift Concurrency Features</a> (Async-Await/Actors) because of that, all async methods can potentially been suspended awaiting results, this implies also a better reading and reasoning compared to the traditional callbacks.</li>
    <li>Images are downloaded with a basic caching system implemented inside Http Client for avoid useless downloads and data consumption.</li>
    <li>Because the pokemon count amount to 1154, is unrealistic to download everything in one shot, so it has been implemented also a pagination system, that download other pokemons while scrolling.</li>
    <li>Furthermore with <a href="https://developer.apple.com/documentation/swift/withthrowingtaskgroup(of:returning:body:)">withThrowingTaskGroup</a> we are able to download data in parallel instead of a sequential async requests.</li>
    <li>PokemonManager is an observable object just because is shared with the SwiftUI version of the same project that you can fine <a href="https://github.com/apemaia99/Pokemon_SwiftUI">here</a></li>
  </ul>
</body>
