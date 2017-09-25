App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    $('#status').html("Waiting for an other player")

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    switch data.action

      when "game_start"
        App.gamePlay = new Game('game-container', data.msg)

      when "distribute_cards"
        App.gamePlay.showState(data.msg)

      when "new_game"
        App.gamePlay.newGame()

      when "updated_state"
        App.gamePlay.updatedState(data.msg)

  setup: (cards) ->
    @perform("setup")

  takeTurn: (playerId, turnType, turnVal) ->
    @perform "takeTurn", message: {playerId: playerId, turnType: turnType, turnVal: turnVal}
    #@perform "takeTurn", message: [playerId, turnType, turnVal]

  disconnected: ->
    # Called when the subscription has been terminated by the server
