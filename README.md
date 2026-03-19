# E-Commerce UI Implementation App

A high-fidelity Flutter reproduction of a dark-themed e-commerce design, built for the PRM392 Practice Examination.

## 🏗️ Technical Architecture
The project follows a **Clean Architecture** approach with three distinct layers to ensure separation of concerns and maintainability:

1.  **Domain Layer**: Contains the core business logic, entities (`Product`, `CartItem`), and repository interfaces. It is entirely independent of any external frameworks or UI.
2.  **Data Layer**: Manages data retrieval via `ProductApiService` (from `dummyjson.com`) and implements the repository interfaces defined in the domain layer.
3.  **Presentation Layer**: Built with **Flutter Riverpod** for reactive state management.
    *   **Providers**: Centralize state for Products, Favorites, Cart, and Categories.
    *   **Screens**: High-fidelity implementation of Home, Detail, Favorites, and Cart screens matching the HTML designs 100%.

## 🌟 Key Features
-   **Dynamic Product Feed**: Asynchronous loading of products with shimmering placeholder effects.
-   **Search & Categorization**: Search by text and filter by categories reactively.
-   **Favorites System**: Global state management to favorite/unfavorite products across all screens.
-   **Full Cart Experience**: Add items to cart, adjust quantities, calculate totals, and remove items.
-   **Premium UI**: Custom theme matching the original design's Inter typography, shadows, and color palette (`#2111D4` primary).
-   **AI Creative Feature**: Integrated "AI Recommended for You" carousel in the product detail screen, which dynamically recommends items based on category similarity and price range.

## 🧪 Testing Coverage
Implemented required tests (Widget, Navigation, Integration) to ensure UI rendering and core flows work correctly across devices.

## ⚡ Performance
-   Optimized `ListView` rendering with `builder` patterns and `ValueKey`.
-   Image caching using `CachedNetworkImage` to reduce secondary loads and improve scrolling smoothness.
-   Minimal rebuilds using fine-grained Riverpod providers.
# PRM392_PE
