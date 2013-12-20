class @Photos
  @token: null

  constructor: (@form)->
    @form.on 'submit', @events.submit.bind(@)
    @token = $('#users_token')

  events:
    submit: ->
      if @token.val() == ''
        Message.show('Error, you need to get token from the server first', 'danger', '#photos_message')
        return false
      true