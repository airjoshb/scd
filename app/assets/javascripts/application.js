// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

$(document).ready(function () {
    // use UI arrows in page content to control scrolling
    var scrolling = false;

    $('.scroll-arrows').on('mousedown', 'div', function (evt) {
        scrolling = true;
        startScrolling($('.flex'), 40, evt.target.id);
    }).on('mouseup', function () {
        scrolling = false;
    });

    function startScrolling(obj, spd, btn) {
        var travel = (btn.indexOf('left') > -1) ? '-=' + spd + 'px' : '+=' + spd + 'px';
        if (!scrolling) {
            obj.stop();
        } else {
            // recursively call startScrolling while mouse is pressed
            obj.animate({
                "scrollRight": travel
            }, "fast", function () {
                if (scrolling) {
                    startScrolling(obj, spd, btn);
                }
            });
        }
    }
});