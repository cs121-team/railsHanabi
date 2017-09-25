# README

## Summary

This app implements the card game Hanabi. Hanabi, which is typically played in-person, is a cooperative game in which players hold their cards outwards so that they can see other players' cards but not their own. Players are allowed to give each other limited numbers of hints to allow each other to discover the contents of their hands and therefore what plays are valid. Full rules for Hanabi can be found [here.](http://www.spillehulen.dk/resources/product/EDR/RG8/69/Hanabi%20Card%20Game%20Rules.pdf)

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

This game lets you perform all the actions you would want to do in a real Hanabi game.

Let's walk through the game flow.

0. When you first arrive to the page, you'll be asked to wait for other players to arrive.
![waiting for players](https://user-images.githubusercontent.com/12390123/30809789-db13fad8-a1b7-11e7-96d8-c33685693a6c.png)
1. As soon as enough players (4) are present, the game automatically starts.
2. When the game has started, you can see all other players' cards except your own.
![new game](https://user-images.githubusercontent.com/12390123/30809787-db03802c-a1b7-11e7-8b57-c55806f36a3f.png)
3. The player whose turn it is has three options: play a card, give a hint, or discard a card.
![three play options](https://user-images.githubusercontent.com/12390123/30809788-db11150c-a1b7-11e7-81cc-ce100fe35811.png)
  1. To play a card, select which of your cards you want to play. You may have some information about some of them.
  2. To give a hint, select which other player you would like to give a hint to, then choose which hint you would like to give (e.g. tell them all cards of a certain rank). This also decreases the hint counter by 1.
  3. To discard a card, select which of your cards you want to discard. This also increases the hint counter.
  4. When all the bombs have been exploded or you run out of cards, the game ends.
  ![game over](https://user-images.githubusercontent.com/12390123/30809783-dae90184-a1b7-11e7-911d-29ee6b45ddd6.png)


## Architecture

### Main Technologies
The app was built using Ruby on Rails. Specifically, the project uses Ruby 2.4.1p with Rails 5.1.4. 

We also used Redis with ActionCable to allow for real-time updates from the server.

### Important components (separated by file)
* [new.html.erb](app/views/games/new.html.erb) - This file contains all of the HTML for our single-page application.
* [game.js](app/assets/javascripts/game.js) - This file updates the HTML in new.html.erb with changes as other players' actions change the game state. It also listens for user interactions in the HTML and triggers the appropriate responses. When it wants to send an update to the server, it makes calls to functions in game.coffee.
* [game.coffee](app/assets/javascripts/channels/game.coffee) - This file acts as a switchboard, forwarding functions initiated in game.js to the GameChannel and recieving ActionCable messages sent back from the server. It then uses these messages to call the appropriate functions in game.js.
* [game\_channel.rb](app/channels/game_channel.rb) - This file contains a Redis ApplicationChannel called GameChannel. When users arrive at our site, they are automatically subscribed to a game channel. This class allows all subscribed users to be updated of changes initiated by other users via ActionCable messages. For the most part, functions game\_channel.rb simply call corresponding functions in game.rb.
* [game.rb](app/models/game.rb) - This class contains most of our game logic. It maintains a global game state, which includes what hands each player is holding, the hint and bomb counters, and the stacks of center and discarded cards.  This class validates whether a user's play is allowed and updates the game state in response to this play. It then sends a message containing the new game state to all users via ActionCable.

## Issues

### Resolved Issues
It took a long time to figure out how to integrate ActionCable and Redis into our app. The Tic-Tac-Toe tutorial mentioned in the references was the resource which helped us most in debugging this, followed by the "Action Cable Demo" file.

### Known Bugs
0. Reloading the page makes the game think you're a new player. This is because we don't require any login, so there's no easy way to tell whether you opened the app in a new tab or reloaded the page. 
1. You trigger an error if you try to play before first selecting a card or a player to give a hint to. With a bit more time, this could be fixed by disabling the "Complete Move" button until the required selections have been made.
2. Sometimes, when you reload multiple tabs to represent different users, the game will restart before all of hte users' pages have been realoaded. This may be due to the fact that old tabs still are maintaining a connection to our GameChannel. This could be debugged by testing which situations the error occurs and by printing out how many connections there are to the GameChannel at any given time.

## Unimplemented Features
We would like to implement several more features which are currently unimplemented due to time constraints.

0. Add a more compelling UI. Designate the suits of different cards by different colors.
1. Let users mark down additional info they know about their cards which they can infer from their hints (e.g. if they get a hint telling them which cards in their hand are blue, they also know which ones are NOT blue).
2. Let users log in and save games in a database so they can access stats on their high scores.
3. Allow multiple games to go on at once.
4. Don't pass any hidden information to the client (for instance, make it impossible for a user to look up their own cards).
5. When a game ends, tell the players how well they did and give them the option to start a new game.
6. Indicate more visually when a user performs an action (e.g. triggering a bomb).
7. Better error handling.
8. Allow for variable numbers of players per game.


## How to Run It
0. Install Ruby and Rails
1. [Install redis.](https://redis.io/download)
2. Clone this repository.
3. Cd into the project directory, then run "bundle install"
3. Open a terminal window. Cd into the project directory, and run "redis-server".
4. Open another terminal window. Cd into the project directory, and run "rails s".
5. Navigate to http://localhost:3000/. The app should be working!
6. To simulate multiple users, open multiple browser windows.

Alternatively, you can play it at <http://hanabi.yancey.io:3000/>, where we've already done steps 1-6.

## References

* [Tic-Tac-Toe Tutorial using ActionCable](https://www.cookieshq.co.uk/posts/tic-tac-toe-game-in-rails-5-with-action-cable) - This was the primary resource we used to integrate ActionCable into our app, and we have patterned most of our architecture off of it.
* [Layout and Rendering in Rails](http://edgeguides.rubyonrails.org/layouts_and_rendering.html) This helped us understand the basics of how Ruby works and how the various pieces of its design pattern (Model, View, and Controller) fit together.
* [ActionCable Overview](http://edgeguides.rubyonrails.org/action_cable_overview.html) This explains the basics of how ActionCable works. It was difficult to understand without an example for comparison, however.
* [Action Cable Demo](https://medium.com/@dhh/rails-5-action-cable-demo-8bba4ccfc55e) This tutorial by the creater of Ruby on Rails shows how to use ActionCable by implementing a simple app while explaining in depth how ActionCable fits in with the rest of Ruby.
* [WebSockets & ActionCable](https://blog.heroku.com/real_time_rails_implementing_websockets_in_rails_5_with_action_cable)This article helped explain conceptually how websockets and ActionCable interact with the server and client.
* [Instagram Clone](https://www.youtube.com/watch?v=MpFO4Zr0EPE): We created the outline of our app by copying the instructions described in this app.
* StackOverflow and W3Schools were both valuable tools for discovering answers to questions about Ruby or about HTML styling.

