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
//= require turbolinks
//= require bootstrap-sprockets
//= require location

var ready = function () {
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $('.js-tab').removeClass('active');
    $(this).parent().addClass('active');
  });

  $('.js-add-product').click(function (e) {
    $('.js-line-item-form').submit();
  });

  $('.js-restaurant-index').click(function (ev) {
    $('html,body').animate({ scrollTop: 0 }, 'slow', function (argument) {
      $('.js-location-pick').focus();
    });
  });

  window.prepareRelatedCheckboxes = function () {
    $('.js-related-checkbox').change(function () {
      $(this).parents('.js-related').find('.js-related-count').attr('disabled', !this.checked);
    });
  };
};

$(document).ready(ready);
$(document).on('page:load', ready);
