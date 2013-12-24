class @Photos
  token: null
  template:
    photo: null
    photo_more: null
  form: null
  container: null
  last_photo: null
  params:
    limit: 3
    from: null
    direction: null

  constructor: (@form)->
    @form.on 'submit', @events.submit.bind(@)
    @token = $('#users_token')
    if $('#photos').length
      @preload_photos( $('#photos') )

  preload_photos: (@container) ->
    # init
    @container_more = $('#photo_more')
    @container_more.on 'click', 'a.load_more', @events.click_load_more.bind(@)
    @template.photo ||= Handlebars.compile $('#tpl_photo').html()
    @template.photo_more ||= Handlebars.compile $('#tpl_photo_more').html()
    @url ||= @container.data('preload-url')
    # load
    @load_photos @events.first_loaded.bind(@)

  load_photos: (callback)->
    $.ajax
      url: @url
      type: 'GET'
      dataType: 'json'
      success: callback
      data: @params
      error: (xhr, status, err)->
        if xhr.responseJSON? and xhr.responseJSON.error
          Message.show("Critical error #{xhr.responseJSON.error}", 'danger', '#message')

  events:
    first_loaded: (resp)->
      @container.html('')
      if resp.status? && resp.status.code == 200
        for photo in resp.photos
          @container.append @template.photo({photo: photo})
        @last_photo = photo
        @container_more.html @template.photo_more()
        @wait_images_and_start_masonry(true)
    more_loaded: (resp)->
      if resp.status? && resp.status.code == 200 && resp.photos.length > 0
        for photo in resp.photos
          @container.append @template.photo({photo: photo})
        @last_photo = photo
        @wait_images_and_start_masonry(false)
      else
        @container_more.html('') # have nothing to loa more
    click_load_more: ->
      @params.from = @last_photo.id
      @params.direction = 'down'
      @load_photos(@events.more_loaded.bind(@))
      false
    submit: ->
      if @token.val() == ''
        Message.show('Error, you need to get token from the server first', 'danger', '#photos_message')
        return false
      true

  wait_images_and_start_masonry: (first_time=true)->
    loaded = 0
    images_total = $("#photos img.loading").length
    console.log loaded, images_total
    container = @container
    $("#photos img.loading").load ->
      ++loaded
      $(@).removeClass('loading')
      if loaded == images_total
        if first_time
          console.log 'call masonry first time'
          container.masonry({gutter: 0, columnWidth:  '.item', itemSelector: '.item'})
        else
          console.log 'call masonry on addon'
          mas = container.data('masonry')
          mas.reloadItems()
          mas.layout()
#          isInitLayout: false
