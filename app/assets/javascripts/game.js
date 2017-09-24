var Game = function(element, playerId) {
  console.log("GAME CREATED", playerId)
  this.element = $(element); // This element is game-container. We can put stuff there!
  this.init = function() {
    this.turn == 0
    this.center_deck = [];
    this.remaining_deck = [];
    this.players = [[],[],[],[]];
    this.ranks = ['1','1','1','2','2','3','3','4','4','5'];
    this.suites = ['A','B','C','D','E'];

    //Create the initial deck
    for (i = 0; i < this.ranks.length; i++) {
      for (j = 0; j < this.suites.length; j++){
        this.remaining_deck.push([this.ranks[i],this.suites[j]]);
      }
    }
    if (playerId == 0) {
      this.distributeCards();
    }
    
  };
  this.start = function() {
    this.init()
    var displayCards = this.players;
    displayCards.splice(playerId,1);

    //player can only see other players' cards
    //$('#card1').html(displayCards);
    //console.log(this.players[playerId]);
    if (playerId == 0) {
      $('#status').html('Your turn');
    } else {
      $('#status').html('Waiting for Player0 to play.');
    }

  }

  this.distributeCards = function() {
    // for (i = 0; i < this.players.length; i++) {
    //   var x = 0;
    //   while (x < 5) {
    //     var index = Math.floor(Math.random() * this.remaining_deck.length);
    //     this.players[i].push(this.remaining_deck[index]);
    //     this.remaining_deck.splice(index,1);
    //     x += 1;
    //   }
    // };
    App.game.setup();
  };

  this.showCards = function(cards) {
    var handArr = []
    for (var hand of cards) {
      console.log("HAND: ", hand);
      var cardStr = "["
      for (var card of hand) {
        console.log("__card__", card)
        cardStr += card[0] + card[1] + ", "
      }
      cardStr += "], "
      handArr += cardStr
    }

    $('#card1').html(handArr);
  }

  this.takeTurn = function() {
    App.game.takeTurn();
  }

  this.turnFinished = function() {
    console.log("Turn finished!");
    // Later, do more with this turn
    this.turn == (this.turn + 1) % 4 //TODO(olivia): Later come back and don't hard code 4 players
  }


  this.start();

}
