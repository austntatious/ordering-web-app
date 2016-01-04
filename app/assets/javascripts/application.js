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
//= require bootstrap-sprockets
//= require jquery.maskedinput
//= require location
//= require facebook
//= require ZeroClipboard

var ready = function () {
  for (var i = 0; i < window.commonData.locations.length; i++) {
    window.commonData.locations[i].coords = $.parseJSON(window.commonData.locations[i].coords);
  }

  // masked input for credit cards
  window.setCCMasks = function () {
    $('#credit_card_number').mask('9999 9999 9999 999?9');
    $('#credit_card_exp_month').mask('99');
    $('#credit_card_exp_year').mask('9999');
    $('#credit_card_cvc').mask('999?9');
  };

  // tabs
  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    $('.js-tab').removeClass('active');
    $(this).parent().addClass('active');
  });

  // add product to cart button
  $('.js-add-product').click(function (e) {
    e.preventDefault();
    $('.js-line-item-form').submit();
  });

  // add credit card
  $('.js-add-card').click(function (e) {
    e.preventDefault();
    $('#new-card-modal #error_explanation').remove();
    $('.js-add-card').addClass('disabled');
    $('.js-add-card-form').submit();
  });

  // animate to 'pick your location form'
  $('.js-restaurants-index .js-restaurant').click(function (ev) {
    ev.preventDefault();
    $('html,body').animate({ scrollTop: 0 }, 'slow', function (argument) {
      $('.js-location-pick').focus();
    });
  });

  var restaurant_holders = $('.js-restaurant-holder');

  // filter restaurants with search
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

  // validate addons count
  $(document).on('change', '.js-product-addon', function (ev) {
    var addons = $('.js-product-addon:checked'),
      maxToppings = $('.js-product-count').data('max');
    if (addons.length > maxToppings) {
      var disabled = false,
        me = this;
      addons.each(function (ind, itm) {
        if (!disabled) {
          if (itm.id != me.id) {
            disabled = true;
            itm.checked = false;
          }
        }
      });
    }
  });

  // validate entered coupon and update data in form if required
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

  // spent money from account, recalculate prices
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

  // show "referral email form" on click
  $('.js-email-share').click(function (ev) {
    ev.preventDefault();
    $('.js-email-share-form').toggleClass('hidden');
  });

  // back button
  $('.js-back').click(function (ev) {
    ev.preventDefault();
    history.back();
  });

  // automatically copy referral link to clipboard
  ZeroClipboard.config( { swfPath: "/ZeroClipboard.swf" } );
  var client = new ZeroClipboard( document.getElementById("copy-button") );

  client.on( "ready", function( readyEvent ) {
    client.on( "copy", function (event) {
      var clipboard = event.clipboardData;
      clipboard.setData( "text/plain", $('.js-ref-link-value').val());
    });
    client.on( "aftercopy", function( event ) {
      $('.js-copied').removeClass('hidden');
    });
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
