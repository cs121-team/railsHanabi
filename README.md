# README

## Summary

This app implements the card game Hanabi. Hanabi, which is typically played in-person, is a cooperative game in which players hold their cards outwards so that they can see other players' cards but not their own. Other players are allowed to give each other limited numbers of hints to help each player play correctly. Full rules for Hanabi can be found [here.](http://www.spillehulen.dk/resources/product/EDR/RG8/69/Hanabi%20Card%20Game%20Rules.pdf)

You can play our game online at [http://hanabi.yancey.io:3000/](http://hanabi.yancey.io:3000/).

## Primary Contributors
The app was initially created for an assignment in Harvey Mudd's CS 121 class. It was created by Nupur Banerjee, Olivia Watkins, Gavin Yancey, and Jasmine Zhu.

## MVP
Our MVP allows users to do the following features:
0. Join a game. Once 4 players have arrived at the site, the game automatically begins.
1. See the cards in other players' hands and in the center pile.
2. Play a card when it's your turn. If this card is correct, it will be added to the center stack of cards. If it is incorrect, it will trigger one of the game's bombs. In either situation, a new card will be added to you hand.
3. Give a hint when it's your turn. If the hint counter is greater than 0, you can give a player information about the suit or rank of cards in their hand.
4. See information which has been revealed by hints, both for your own hand and for other players'.
5. Discard a card. This also increases the hint counter by 1.
6. End a game. The game ends when you run out of cards or when the bomb counter reaches 0.

## Functionality

[[DO THIS]]

## Architecture

The app was built using Ruby on Rails. Specifically, the project uses Ruby version XXX and Rails XXX. We also used Redis with ActionCable to allow for real-time updates from the server. [[EXPLAIN WHAT REDIS IS]]

### Main Technologies
[[DO THIS]]

### Important components (separated by file)
* new.html.erb - This file contains all of the HTML for our single-page application.
* game.js - This file updates the HTML in new.html.erb with changes as other players' actions change the game state. It also listens for user interactions in the HTML and triggers the appropriate responses. When it wants to send an update to the server, it makes calls to functions in game.coffee.
* game.coffee - This file acts as a switchboard, forwarding functions initiated in game.js to the GameChannel and recieving ActionCable messages sent back from the server. It then uses these messages to call the appropriate functions in game.js.
* game_channel.rb - This file contains a Redis ApplicationChannel called GameChannel. When users arrive at our site, they are automatically subscribed to a game channel. This class allows all subscribed users to be updated of changes initiated by other users via ActionCable messages. For the most part, functions game_channel.rb simply call corresponding functions in game.rb.
* game.rb - This class contains most of our game logic. It maintains a global game state, which includes what hands each player is holding, the hint and bomb counters, and the stacks of center and discarded cards.  This class validates whether a user's play is allowed and updates the game state in response to this play. It then sends a message containing the new game state to all users via ActionCable.

## Issues

### Resolved Issues
It took a long time to figure out how to integrate ActionCable and Redis into our app. The Tic-Tac-Toe tutorial mentioned in the references was the resource which helped us most in debugging this, followed by the "Action Cable Demo" file.

### Known Bugs
[[LATER]].

## Unimplemented Features
We would like to implement several more features
0. Add a more compelling UI. Designate the suits of different cards by different colors.
1. Let users mark down additional info they know about their cards which they can infer from their hints (e.g. if they get a hint telling them which cards in their hand are blue, they also know which ones are NOT blue).
2. Let users log in and save games in a database so they can access stats on their high scores.
3. Allow multiple games to go on at once.
4. Don't pass any hidden information to the client (for instance, make it impossible for a user to look up their own cards).
5. When a game ends, tell the players how well they did and give them the option to start a new game.


## How to Run It
0. Install Ruby and Rails
1. Install redis. (INSERT LINK)
2. Clone this repository.
3. Cd into the project directory, then run "bundle install"
3. Open a terminal window. Cd into the project directory, and run "redis-server".
4. Open another terminal window. Cd into the project directory, and run "rails s".
5. Navigate to http://localhost:3000/. The app should be working!
6. To simulate multiple users, open multiple browser windows.

## References

* [Tic-Tac-Toe Tutorial using ActionCable](https://www.cookieshq.co.uk/posts/tic-tac-toe-game-in-rails-5-with-action-cable) - This was the primary resource we used to integrate ActionCable into our app, and we have patterned most of our architecture off of it.
* [Layout and Rendering in Rails](http://edgeguides.rubyonrails.org/layouts_and_rendering.html) This helped us understand the basics of how Ruby works and how the various pieces of its design pattern (Model, View, and Controller) fit together.
* [ActionCable Overview](http://edgeguides.rubyonrails.org/action_cable_overview.html) This explains the basics of how ActionCable works. It was difficult to understand without an example for comparison, however.
* [Action Cable Demo](https://medium.com/@dhh/rails-5-action-cable-demo-8bba4ccfc55e) This tutorial by the creater of Ruby on Rails shows how to use ActionCable by implementing a simple app while explaining in depth how ActionCable fits in with the rest of Ruby.
* [WebSockets & ActionCable](https://blog.heroku.com/real_time_rails_implementing_websockets_in_rails_5_with_action_cable)This article helped explain conceptually how websockets and ActionCable interact with the server and client.
* [Instagram Clone](https://www.youtube.com/watch?v=MpFO4Zr0EPE): We created the outline of our app by copying the instructions described in this app.
* StackOverflow and W3Schools were both valuable tools for discovering answers to questions about Ruby or about HTML styling.

