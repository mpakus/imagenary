class @Users
  @token: null

  constructor: (@form)->
    @form.on 'submit', @events.submit.bind(@)
    @token = $('#users_token')

  events:
    submit: ->
      $.ajax
        url: @form.attr('action')
        type: 'POST'
        dataType: 'json'
        data: @form.serialize()
        success: (resp)=>
          if resp.status? && resp.status.code == 200
            @token.val(resp.user.token)
            Message.show("Done, your token is #{resp.user.token}", 'success', '#users_message')
          else
            Message.show(resp.status.error, 'danger', '#users_message')
        error: (xhr, status, err)->
          if xhr.responseJSON? and xhr.responseJSON.error
            Message.show("Critical error #{xhr.responseJSON.error}", 'danger', '#users_message')
      false
