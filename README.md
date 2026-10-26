# Marketplace

Marketplace leverages DummyJSON's free products API to showcase my understanding of fundemental software development concepts.

## Table of Contents
- [Features](#features)
- [Acknowledgements](#acknowledgments)

## Features

- Paginated products list
  
  <img width="250" alt="final-products-list" src="https://github.com/user-attachments/assets/f0f79acf-7cd2-4a75-84d7-0979630e69fa"/>

  Notable:

  - Images are cached in memory using URLCache
 
  Note: Some of the image URLs DummyJSON provides download the same image. For example https://cdn.dummyjson.com/product-images/1/1.jpg and https://cdn.dummyjson.com/product-images/1/2.jpg are the same image. This is a DummyJSON issue and not a side effect of this application.
- Filtered products list

  <img width="250" alt="final-new-apply-filter" src="https://github.com/user-attachments/assets/59a0fb1b-9a56-48be-b696-40ca5bbd28b5"/>
  <img width="250" alt="final-new-clear-filter" src="https://github.com/user-attachments/assets/22b0cc8e-0aba-484d-9a50-02ebf9c598a1"/>

  Note: At the time of writing this, DummyJSON's products API does not allow filtering by multiple categories. So the filter in this project uses data in memory only. Items that have not been downloaded will not show in the filter. If you want to see the filter in full-effect, scroll to the bottom of the products list and then apply filters.
- Products search

  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/801d0ab4-7269-4c53-8c0d-650a31d93d08" alt="Search history screen" width="250"/>
  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/a5b49326-b956-4096-ad4d-ad762d3b9b82" alt="List of products from a search" width="250"/>

  Notable:
  
  - Core Data is used to persist user searches
  - Search updates use Combine and UITableViewDiffableDataSource
- Product detail

  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/c5db08aa-4a4f-43ed-aa4b-96c54796fead" alt="Selected a laptop screen" width="250"/>
  <img src="https://github.com/vcubez19/Marketplace/assets/67804332/9145ee54-e26f-4937-82e8-8ece3a79ffac" alt="Selected a laptop screen with laptops added to cart" width="250"/>

  Notable:

  - Screen written in SwiftUI
 
  
## Acknowledgments

- Thank you to [DummyJSON.com](https://dummyjson.com/) for providing all of the data used in this project.
