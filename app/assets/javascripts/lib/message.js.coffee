class @Message
  @show: (message, type, container='#message')->
    $(container).html "<div class='alert alert-#{type}'><span class='close' onClick='$(this).parent().fadeOut(300)'>&times;</span>#{message}</div><script type='text/javascript'>$('.alert').fadeIn(300);</script>"
  @clean: ->
    $('#message').find('.alert').fadeOut(300)
  @clear: -> @clean()
