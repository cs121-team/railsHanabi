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

The app was built using Ruby on Rails. Specifically, the project uses Ruby version XXX and Rails XXX. We also used Redis with ActionCable to allow for real-time updates from the server.

## Architecture




## How to Run It
0. Install Ruby and Rails
1. Install redis. (INSERT LINK)
2. Clone this repository.
3. Cd into the project directory, then run "bundle install"
3. Open a terminal window. Cd into the project directory, and run "redis-server".
4. Open another terminal window. Cd into the project directory, and run "rails s".
5. Navigate to http://localhost:3000/. The app should be working!
6. To simulate multiple users, open multiple browser windows.



## Game Flow

## In Progress
