
<img width="270" height="587" alt="Simulator Screenshot - iPhone 17 - 2026-02-26 at 14 56 47" src="https://github.com/user-attachments/assets/9ec49409-a68a-4fa8-b901-b22a3358f993" />

<img width="270" height="587" alt="Simulator Screenshot - iPhone 17 - 2026-02-26 at 14 57 08" src="https://github.com/user-attachments/assets/871eb890-4761-44d2-9d4c-f843af3cd95e" />

<img width="270" height="587" alt="Simulator Screenshot - iPhone 17 - 2026-02-26 at 14 57 12" src="https://github.com/user-attachments/assets/e03a0ac3-5e4f-429c-b74f-819dc0bcf3d1" />


# PokemonCard iOS App

Simple iOS application built with **Swift + UIKit** to display Pokémon
cards using the TCGdex API.

**Base URL:** https://tcgdex.dev/

------------------------------------------------------------------------

## Features

-   Card list with pagination
-   Detail screen with custom draggable bottom sheet
-   Dynamic background tint based on rarity
-   Reusable `InfoRowView` component
-   Remote image loading with SDWebImage
-   Clean ScrollView + StackView Auto Layout setup

------------------------------------------------------------------------

## Detail Screen Behavior

-   Initially shows card image
-   Bottom sheet can be dragged
-   Expands only to fit its content
-   Uses Auto Layout (no fixed heights)
-   Content size driven by `UIScrollView.contentLayoutGuide`

------------------------------------------------------------------------

## Tech Stack

-   Swift
-   UIKit
-   Auto Layout
-   SDWebImage
-   REST API (TCGdex)
-   Codable

------------------------------------------------------------------------

## How to Run

1.  Clone the repository
2.  Open the project in Xcode
3.  Build & Run

------------------------------------------------------------------------

## Author

Agil Febrianistian\
iOS Developer
