class @Photos
  @token: null

  constructor: (@form)->
    @form.on 'submit', @events.submit.bind(@)
    @token = $('#users_token')
    @wait_images_and_start_masonry()

  wait_images_and_start_masonry: ->
    loaded = 0
    numImages = $("#photos img").length

    $("#photos img").load ->
      ++loaded
      if loaded == numImages
        $('#photos').masonry
  #      columnWidth:  230
          gutter: 0
          columnWidth:  '.item'
          itemSelector: '.item'

  events:
    submit: ->
      if @token.val() == ''
        Message.show('Error, you need to get token from the server first', 'danger', '#photos_message')
        return false
      true