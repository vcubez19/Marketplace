# Marketplace

Marketplace is an iOS app that leverages DummyJSON's free products API to showcase my proficiency in iOS development.

## Table of Contents
- [Features](#features)
- [Acknowledgements](#acknowledgments)

## Features

- Paginated products list
  
  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/f1e114b0-289e-4295-b584-4e2e889a9505" alt="List of products" width="250"/>

  Notable:

  - Images are cached in memory using URLCache
- Filtered products list

  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/875296da-741c-415d-bcea-9e5227801517" alt="List of products behind apply filter button" width="250"/>
  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/77ad1df5-f080-4b87-9d89-913f817c6b40" alt="List of products behind clear filter button" width="250"/>

  Note: At the time of writing this, DummyJSON's products API does not allow filtering by multiple categories. So the filter in this project uses data in memory only. Items that have not been downloaded will not show in the filter.
- Products search

  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/801d0ab4-7269-4c53-8c0d-650a31d93d08" alt="Search history screen" width="250"/>
  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/a5b49326-b956-4096-ad4d-ad762d3b9b82" alt="List of products from a search" width="250"/>

  Notable:
  
  - Core Data is used to persist user searches
  - There's a debouncer on the searching
  - Search updates use Combine and UITableViewDiffableDataSource
- Product detail

  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/c5db08aa-4a4f-43ed-aa4b-96c54796fead" alt="Selected a laptop screen" width="250"/>
  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/9145ee54-e26f-4937-82e8-8ece3a79ffac" alt="Selected a laptop screen with laptops added to cart" width="250"/>

  Notable:

  - Entire screen written in SwiftUI
 
  
## Acknowledgments

- Thank you to [DummyJSON.com](https://dummyjson.com/) for providing all of the data used in this project.
