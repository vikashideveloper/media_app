## Vikash Kumar
# Image Grid with data loaded from Network API
This app is developed in **SwiftUI** using MVVM and Clean architecture. 

Images are fetching as per below steps
1. from InMemory cache if available, otherwise
2. from Disk cache if available, otherwise
3. from Network if available, otherwise
4. No image found message is displaying as image placeholder.

   ## Architecture
The app is developed with MVVM Architecture. Here are details of app architecture. 
1. Views are interacting with ViewModel
2. ViewModel is interacting with DataService
3. DataService is interacting with Repositories(CacheRepository and NetworkRepository)

   ## UnitTest
   I have added some important UnitTest cases to validate the app's bussines logic

   ## Config files
   The app has debug config files to configure the enviroment settings.
   Network base url is configured in this file. 
