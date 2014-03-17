class @Photos
  token: null
  template:
    photo: null
    photo_more: null
  form: null
  container: null
  first_photo: null
  last_photo: null
  params:
    limit: 8
    from: null
    direction: null

  constructor: (@form)->
    console.log "Photos::constructor"
    @form.on 'submit', @events.submit.bind(@)
    @token             = $('#users_token')
    @container         = $('#photos')
    @preload_container = $('#preload_photos')
    @container_more    = $('#photo_more')
    @photo_modal_win   = $('#modal_photos_show')

    # BB routing
    # proceed photo links
    @container.on 'click', 'a.to-photo', (e)->
      e.preventDefault()
      Backbone.history.navigate($(@).attr('href'), true)
    # proceed BS event when modal window closed
    @photo_modal_win.on 'hidden.bs.modal', ->
      Backbone.history.navigate('/', false)

    if $('#photos').length > 0
      @template.photo    = Handlebars.compile $('#tpl_photo').html()
      @url               = @container.data('preload-url')
      # Load a new photos and more buttons
      $('#load_more').off('click').unbind().click(@events.click_load_more.bind(@))
      $('#refresh').off('click').unbind().click(@events.click_refresh.bind(@))

  run: ->
    if @container? and @container.length
      @load_photos @events.first_loaded.bind(@)

  show: (id)->
    $.ajax
      url: "/photos/#{id}.html?ajax=1"
      type: 'GET'
      dataType: 'html'
      success: (html)=>
        tpl = @photo_modal_win
        tpl.html(html)
        tpl.modal('show')
      data: @params
      error: (xhr, status, err)->
        if xhr.responseJSON? and xhr.responseJSON.error
          Message.show("Critical error #{xhr.responseJSON.error}", 'danger', '#message')

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

  wait_images_and_start_masonry: (first_time=true, prepend=false)->
    loaded = 0
    images_total      = @preload_container.find("img.loading").length
    container         = @container
    preload_container = @preload_container
    @preload_container.find("img.loading").load ->
      ++loaded
      $(@).removeClass('loading')
      if loaded == images_total
        $('#load_more').show().parent().find('.bar').hide()
        if prepend
          container.prepend(preload_container.html())
        else
          container.append(preload_container.html())
        preload_container.empty()
        if first_time
          container.masonry({gutter: 20, columnWidth:  '.item', itemSelector: '.item'})
        else
          mas = container.data('masonry')
          mas.reloadItems()
          mas.layout()

  events:
    click_refresh: (e)->
      @params.from      = @first_photo.id
      @params.direction = 'up'
      $('#refresh').addClass('rotate')
      @load_photos(@events.refresh_loaded.bind(@))
      e.stopImmediatePropagation()
      e.preventDefault()
      e.stopPropagation()
    refresh_loaded: (resp)->
      $('#refresh').removeClass('rotate')
      if resp.status? && resp.status.code == 200 && resp.photos.length > 0
        @first_photo = resp.photos[0]
        for photo in resp.photos
          @preload_container.prepend @template.photo({photo: photo})
        @wait_images_and_start_masonry(false, true)
    first_loaded: (resp)->
      @container.html('')
      if resp.status? && resp.status.code == 200
        @first_photo = resp.photos[0] if resp.photos.length > 0
        for photo in resp.photos
          @preload_container.append @template.photo({photo: photo})
        @last_photo = photo
        @wait_images_and_start_masonry(true)
    click_load_more: (e)->
      $('#load_more').hide().parent().find('.bar').show()
      @params.from      = @last_photo.id
      @params.direction = 'down'
      @load_photos(@events.more_loaded.bind(@))
      e.stopImmediatePropagation()
      e.preventDefault()
      e.stopPropagation()
    more_loaded: (resp)->
      if resp.status? && resp.status.code == 200 && resp.photos.length > 0
        for photo in resp.photos
          @preload_container.append @template.photo({photo: photo})
        @last_photo = photo
        @wait_images_and_start_masonry(false)
      else
        @container_more.html('') # have nothing to loa more
    submit: ->
      if @token.val() == ''
        Message.show('Error, you need to get token from the server first', 'danger', '#photos_message')
        return false
      true