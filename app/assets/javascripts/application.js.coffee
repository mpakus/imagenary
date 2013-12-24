#= require jquery
#= require jquery_ujs
#= require nprogress
#= require nprogress-turbolinks
#= require turbolinks
#= require twitter/bootstrap
#= require_tree .

class Imagenary
  constructor: ->
    $('#load_more, #refresh').unbind()
    @users  = new Users($('#users_auth_form'))
    @photos = new Photos($('#create_photos_form'))

ready = ->
  @app = new Imagenary
  @app.photos.run()
  $('.dropdown-toggle').dropdown()

$(document).on 'page:load', ->
  @app.photos.run()

$(document).ready ready

