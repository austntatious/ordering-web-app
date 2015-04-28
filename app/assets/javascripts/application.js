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
//= require jquery.maskedinput
//= require location
//= require facebook

var ready = function () {
  for (var i = 0; i < window.commonData.locations.length; i++) {
    window.commonData.locations[i].coords = $.parseJSON(window.commonData.locations[i].coords);
  }

  window.setCCMasks = function () {
    $('#credit_card_number').mask('9999 9999 9999 9999');
    $('#credit_card_exp_month').mask('99');
    $('#credit_card_exp_year').mask('9999');
    $('#credit_card_cvc').mask('999?9');
  };

  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $('.js-tab').removeClass('active');
    $(this).parent().addClass('active');
  });

  $('.js-add-product').click(function (e) {
    e.preventDefault();
    $('.js-line-item-form').submit();
  });

  $('.js-add-card').click(function (e) {
    e.preventDefault();
    $('#new-card-modal #error_explanation').remove();
    $('.js-add-card').addClass('disabled');
    $('.js-add-card-form').submit();
  });

  $('.js-restaurants-index .js-restaurant').click(function (ev) {
    ev.preventDefault();
    $('html,body').animate({ scrollTop: 0 }, 'slow', function (argument) {
      $('.js-location-pick').focus();
    });
  });

  var restaurant_holders = $('.js-restaurant-holder');

  $('.js-restaurant-search').keyup(function (ev) {
    var str = $(this).val();
    if (str == '') {
      restaurant_holders.removeClass('hidden');
    }
    else {
      restaurant_holders.each(function (ind, itm) {
        var name = $(itm).find('.js-restaurant').data('name');
        if (name.search(new RegExp(str, "i")) == -1) {
          $(itm).addClass('hidden');
        }
        else {
          $(itm).removeClass('hidden');
        }
      });
    }
  });

  window.prepareRelatedCheckboxes = function () {
    $('.js-related-checkbox').change(function () {
      $(this).parents('.js-related').find('.js-related-count').attr('disabled', !this.checked);
    });
  };

  $('.js-check-coupon').click(function (ev) {
    $('.js-coupon-msg').html('');
    $.get('/coupons.json?code=' + $('.js-coupon-code').val(), function (data) {
      if (data.success) {
        $('.js-coupon-msg').html(
          '<div class="alert alert-success">' + data.msg + '</div>'
        );
        if ($('.js-money-account').length) {
          data.new_sum = data.new_sum - parseFloat($('.js-money-account').val());
          data.new_sum_display = '$' + data.new_sum;
        }
        $('.js-cart-price').html(data.new_sum_display);
        $('.js-cart-price').data('price', data.new_sum);
      }
      else {
        $('.js-coupon-msg').html(
          '<div class="alert alert-danger">' + data.msg + '</div>'
        );
      }
    });
  });

  $('.js-money-account').on('change keyup', function () {
    var v = parseFloat(this.value),
      max = parseFloat($(this).attr('max')),
      cartPrice = parseFloat($('.js-cart-price').data('price'));
    if (v > max) {
      $(this).val(max);
      v = max;
    }
    cartPrice = cartPrice - v;
    $('.js-cart-price').html('$' + cartPrice);
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);
