#= require jquery
#= require jquery_ujs
#= require nprogress
#= require nprogress-turbolinks
#= require twitter/bootstrap
#= require lib/handlebars
#= require lib/masonry.min
#= require lib/message
#= require lib/underscore.min
#= require lib/backbone.min
#= require controllers/users
#= require controllers/photos
#= require turbolinks

class Imagenary
  constructor: ->
    $('#load_more, #refresh').unbind()
    @users  = new Users($('#users_auth_form'))
    @photos = new Photos($('#create_photos_form'))
    @setup_routes()
  setup_routes: ->
    Routes = Backbone.Router.extend
      routes:
        "photos/:id.html":  "photos_show"
    @routes = new Routes
    @routes.on 'route:photos_show', @photos.show
    Backbone.history.start({pushState: false, silent: false})

ready = ->
  window.app = new Imagenary
  window.app.photos.run() if window.app.photos?
  $('.dropdown-toggle').dropdown()

$(document).on 'page:load', ->
  window.app.photos.run() if window.app.photos?

$(document).ready ready

