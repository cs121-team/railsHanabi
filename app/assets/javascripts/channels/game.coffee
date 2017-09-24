App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    $('#status').html("Waiting for an other player")
    console.log("WAITING!!!!!!!!!!!!!!")

  received: (data) ->
    console.log("GOT DATA!!!")
    # Called when there's incoming data on the websocket for this channel
    switch data.action

      when "game_start"
        console.log("LET'S PLAY A GAME!!!")
        $('#status').html("Your player ID: " + data.msg)
        App.gamePlay = new Game('game-container', data.msg)
        console.log(data.msg)

      when "distribute_cards"
        console.log("I GOT MY CARDS!!!!!! " + data.msg);
        App.gamePlay.showCards(data.msg)

      when "turn_finished"
        console.log("TURN FINISHED!!!");
        App.gamePlay.turnFinished()
        #App.gamePlay.move data.move
        #App.gamePlay.getTurn()

      when "new_game"
        App.gamePlay.newGame()

      when "opponent_withdraw"
        $('#status').html("Opponent withdraw, You win!")
        $('#new-match').removeClass('hidden');

      when "update_state"
        console.log("AWW YEAH, UPDATED STATE!!!!");

  setup: (cards) ->
    console.log("distributeCards got called in game.coffee!!!")
    @perform("setup")

  takeTurn: (playerId, turnType, turnVal) ->
    console.log("About to take a turn!", playerId, turnVal);
    @perform "takeTurn", message: {playerId: playerId, turnType: turnType, turnVal: turnVal}
    #@perform "takeTurn", message: [playerId, turnType, turnVal]

  disconnected: ->
    # Called when the subscription has been terminated by the server