var Game = function(element, playerId) {
  this.element = $(element); // This element is game-container. We can put stuff there!
  var turnType = 'blah';
  var hintToPlayer;
  var hint;
  $('#player-id').html('You Are Player ' + playerId)
  $('#hint-'+playerId).hide()

  this.init = function() {
    this.turn = 0
    this.center_deck = [];
    this.remaining_deck = [];
    this.discard_deck = [];
    this.players = [[],[],[],[]];
    this.ranks = ['1','1','1','2','2','3','3','4','4','5'];
    this.suites = ['A','B','C','D','E'];
    this.play_card = false;
    this.discard_card = false;
    this.hint = false;


    //Create the initial deck
    for (i = 0; i < this.ranks.length; i++) {
      for (j = 0; j < this.suites.length; j++){
        this.remaining_deck.push([this.ranks[i],this.suites[j]]);
      }
    }
    $('#status').html("")
    if (playerId == 0) {
      this.distributeCards(); //TODO(olivia): Make this something that naturally gets called during game start
      $('#your-turn').show();
    }

  };

  this.start = function() {
    this.init();
    this.bindEvents();
    var displayCards = [];
    $('#game-container').show()

    //deep copy
    for (var i =0; i<this.players.length; i++){
      if (playerId != i) {
        displayCards.push(this.players[i])
      }
    };

  }

  this.bindEvents = function() {

    $('#take-turn').click(function(e){
      e.preventDefault();
      $('#your-turn').hide()
      if (turnType == "hint") {
		    App.game.takeTurn(playerId, turnType, [hintToPlayer, hint]);
      } else {
      	App.game.takeTurn(playerId, turnType, card);
      }
    });

    $("#play-options input:radio").click(function(e) {
      turnType = e.target.value;
      $('#hint-list').hide();
      switch(e.target.value) {
        case "play":
          $('#my-cards').show();
          $('#hint-players').hide();
          break;
        case "hint":
          $('#hint-players').show();
          $('#my-cards').hide();
          break;
        case "discard":
          $('#my-cards').show();
          this.play_card = true;
          $('#hint-players').hide();
          break;
        default:
          break;
      }
    });

    $("#my-cards input:radio").click(function(e) {
      card = parseInt(e.target.value);
    });

    $("#hint-players input:radio").click(function(e) {
      hintToPlayer = e.target.value;
      $('#hint-list').show();
    });

    $("#hint-list input:radio").click(function(e) {
      hint = e.target.value;
    });

  }

  this.distributeCards = function() {
    App.game.setup();
  };

  this.showCards = function(cards) {
    var handArr = [];
    for (var i = 0; i < cards.length; i++) {
      if (i == playerId) {
        var hand = cards[i];
        for (var j = 0; j < hand.length; j++) {
          var card = hand[j];
          var cardString = ""
          if (card[2]) {
            cardString += card[0];
          }
          if (card[3]) {
            cardString += card[1];
          }
          if(cardString == "") {
            cardString = "[]"
          }
          cardString += ', ';
          $('#my-card-' + j).html(cardString);
        }
      } else {
        var hand = cards[i];
        var cardStr = "Player " + i + ": ["
        for (var card of hand) {
          cardStr += card[0] //rank
          if (card[2]) {
            cardStr += "*" //rank known
          }
          cardStr += card[1] //suit
          if (card[3]) {
            cardStr += "*" //suit known
          }
          cardStr += ", "
        }
        cardStr += "], "
        handArr += cardStr
      }
    }
    $('#card1').html(handArr);
  }

  this.showHintCounter = function(data) {
  	text = "Hint counter: "
  	text += data.hint_counter
  	$('#hint-counter').html(text);
  }

  this.showBombCounter = function(data) {
  	text = "Bomb counter: "
  	text += data.bomb_counter
  	$('#bomb-counter').html(text);
  }

  this.showCenterDeck = function(center_deck) {
  	for(var i = 0; i < 5; i++) {
  	  $('#center-card-'+i).html(center_deck[i])
  	}
  }

  this.showDiscardPile = function(discard_pile) {
    text = ''
    for(var i = 0; i < discard_pile.length; i++) {
      card = discard_pile[i]
      text += card[0] + card[1] + ', '
    }
  	$('#discard-pile').html('['+text+']')
  }

  this.turnFinished = function() {
    // Later, do more with this turn
    this.turn = (this.turn + 1) % 4
    if (this.turn == playerId) {
      $('#your-turn').show();
    }
  }

  this.gameOver = function() {
    $('#title').html("Game Over!")
  }

  this.showState = function(data) {
    this.showHintCounter(data)
    this.showBombCounter(data)
    this.showCards(data.hands)
    this.showCenterDeck(data.center_deck)
    this.showDiscardPile(data.discard_pile)
  }

  this.updatedState = function(data) {
    this.showState(data)
    
    this.turnFinished();
  }

  this.start();
}

//remove method https://stackoverflow.com/questions/3954438/remove-item-from-array-by-value
Array.prototype.remove = function() {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};
