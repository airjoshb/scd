# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Rails creates this event, when the link_to(remote: true)
# successfully executes
jQuery ->
  $(document).on 'ajax:success', 'a.vote', (status,data,xhr)->
    # the `data` parameter is the decoded JSON object
    $(".recommend-count").text data.count

    $("a.vote").each ->
      $a = $(this)
      href = $a.attr 'href'
      c = $a.attr 'class'
      allclass = c.split('')[0]
      $a.attr 'href', $a.data('toggle-href')
      $a.toggleClass($a.data('toggle-class'))

      $a.data 'toggle-href', href
      return


    return

  $(document).on 'ajax:success', '.add a', (status,data,xhr)->
    i = $(this).attr 'id'
    $("#"+i).each ->
      $a = $(this)
      href = $a.attr 'href'
      c = $a.attr 'class'
      j = $a.data('toggle-value')
      allclass = c.split('')[0]
      $a.attr 'href', $a.data('toggle-href')
      $a.removeClass(c).addClass($a.data('toggle-class'))
      $('#user_tag_list').val (i, origText) ->
        if c=="follow"
          $a.data('toggle-value') + origText
        else
          origText.replace(j,'')
      $a.data 'toggle-href', href
      $a.data 'toggle-class', c

      return



  return