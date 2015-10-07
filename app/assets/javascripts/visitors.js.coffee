# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ajax:success', 'form#sign_up_user', (e, data, status, xhr) ->
    if data.success
      $('#modal').hide()
      $('.btn').hide()

    else
      $('#modal').hide()
      $('#simplemodal-container').hide()
      $('#simplemodal-overlay').hide()
      $('.btn').hide()
      $('h1').text("Thanks, we'll be in touch!")
