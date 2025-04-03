# GoAnime
    This is an iOS app that displays a list of animes and their information. The app is written in Swift and uses Core Data for persistence and the MVVM architecture with the Repository pattern. It also uses Firebase and UserDefaults to save data

## Project Description 
This shows a short list of top airing animes and their few details after getting them from Jikan API (https://jikan.moe/). You are allowed to select favorites and message users with similar favorites.

## Table of Contents

In the structure files contains: Model, View, ViewModel, Network, Repository (with persistence file) and tests part. Tests contains NetworkAPITests with MockJSON file and its data.

# Installation
Can be used with Xcode 14 and above. Compatible with iPhone and iPad with minimum iOS version 15.0.

# Framework
SwiftUI 

# Architecture
This application uses MVVM for the views and clean architecture for the Network calls. URL Request is used for creating URL.

# Offline Storage
CoreData is used.
User Defaults is used.
Firebase Storage is used

# Design Patterns
Async await.
Manager desin patten
Singleton Design Pattern

# Testing
Units tests for success and failure situations.Mocked responses using MockNetworking, MockingPlanetRepository, MockRestAPIManager
