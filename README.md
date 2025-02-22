# Fetch Take-Home

## Summary: 
The assignment was to build a modern, efficient, iOS App to download and display recipes with the provided API. I believe I have done just that. 
The UI was built with SwiftUI, asynchronous tasks were handled with async/await, Images were saved to an instance of NSCache, and unit tests were written with the modern Swift Testing framework. 

https://github.com/user-attachments/assets/00312878-09fc-4a5f-be15-9277f00a4e00



## Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
In the assignment document I noticed where it said "Use this take home project as an
opportunity to demonstrate your strengths." and "We want to know what production-ready code looks like to you." 

So I chose to focus my efforts of creating clean, safe, easy to read, well structured and documented code rather than developing pixel perfect UI. 
I chose to spend a good bit of time on the requirements of memory efficiency and unit testing. 


## Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
Approximately 18 hours in total. In the document found [here](https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html) under the FAQ where the question "How long should I work on this?" the answer "Use your judgement." is found.
I wanted to take my time and deliver the best possible project. I will admit that while I did go over the [PDF](https://github.com/user-attachments/files/18912071/iOS_Interview_Guide.pdf) document included with the email, I failed to notice the 4-5 hours suggested to spend on the project on first reading. I was about 8 hours in when I noticed this direction. 


## Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
While I don’t believe I made any significant trade-offs I would like to provide some context to my thinking behind some decisions. 
### Swift Testing VS XCTest
In deciding which testing framework to use I decided to go with Swift Testing for a number of reasons. 
1. In all material I’ve read from Fetch it seems like you are a very forward thinking company, you like to utilize new technologies, It seems likely you will have started already implementing Swift Testing in new testing suites.
2. Swift Testing is easier to read in my opinion.
3. XCTest would eventually need to be migrated over to Swift Testing so why not start with the newest.

### Testing the RecipeDataService: Endpoints VS JSON Data
When I went to test the RecipeDataService and HomeViewModel I decided to pass a String into the RecipeDataService initializer to point to one of the provided URL endpoints.
Typically I would create a Mock version of the RecipeDataService to return the contents of a local JSON file or throw an error, reducing the dependence on outside servers. 
Since you provided the endpoints that accomplish this I opted not to create that Mock service but if time were available I would implement this. 

## Weakest Part of the Project: What do you think is the weakest part of your project?
The design could be improved.

As mentioned above, I feel the testing suite could be more isolated given a mock server.

## Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
I very much enjoyed working on this project. I feel that the code structure, logic, and safety represent my skills well. 

To be frank I do not have extensive experience with Unit Testing. In fact this was my first time using the Swift Testing framework. 
But I think the test coverage and the quality of the tests written speaks to my ability to learn and adapt quickly. If given the opportunity I would love to show you the kind of engineer I can be. 

### Dive Deeper
I have attached a PDF that outlines my thinking process in real time. This document served as my "Rubber Duck" during the project.
[Fetch Take-Home Thoughts.pdf](https://github.com/user-attachments/files/18912834/Fetch.Take-Home.Thoughts.pdf)
