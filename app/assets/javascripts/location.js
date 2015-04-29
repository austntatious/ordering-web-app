function setCookie(name,value) {
    var days = 10;
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    var expires = "; expires="+date.toGMTString();
    document.cookie = name+"="+value+expires+"; path=/";
}

function getCookie(name) {
  var cookie = " " + document.cookie;
  var search = " " + name + "=";
  var setStr = null;
  var offset = 0;
  var end = 0;
  if (cookie.length > 0) {
    offset = cookie.indexOf(search);
    if (offset != -1) {
      offset += search.length;
      end = cookie.indexOf(";", offset)
      if (end == -1) {
        end = cookie.length;
      }
      setStr = unescape(cookie.substring(offset, end));
    }
  }
  return(setStr);
}

var lready = function () {
  if (!navigator.geolocation) {
    $('.js-geolocation-holder').remove();
  }

  var findLocation = function (lat, lng) {
    var result = null;
    $.each(window.commonData.locations, function (ind, itm) {
      if (itm.coords) {
        if (itm.polygon === undefined) {
          var coords = [];
          for (var i = 0; i < itm.coords.length; i++) {
            coords.push(
              new google.maps.LatLng(itm.coords[i].lat, itm.coords[i].lng)
            );
          }
          itm.polygon = new google.maps.Polygon({
            paths: coords
          });
        }
        var latlng = new google.maps.LatLng(lat, lng);
        if (google.maps.geometry.poly.containsLocation(latlng, itm.polygon)) {
          result = itm;
        }
      }
    });
    return result;
  },
  getLocation = function (id) {
    var result = null;
    $.each(window.commonData.locations, function (ind, itm) {
      if (itm.id == id) {
        result = itm;
      }
    });
    return result;
  };

  var isOrderPage = ($('.js-order-location').length > 0);

  if ($('.js-location-pick').length) {
    var autocomplete = new google.maps.places.Autocomplete($('.js-location-pick')[0], {}),
      map = null,
      marker = null,
      applyLocation = function (lat, lng, detectAddress) {
        if (!isOrderPage) {
          setCookie('lat', lat);
          setCookie('lng', lng);
        }
        if (detectAddress) {
          geocoder = new google.maps.Geocoder();
          geocoder.geocode({
            latLng: new google.maps.LatLng(lat, lng)
          }, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
              $(".js-location-pick").val(results[0].formatted_address);
              if (!isOrderPage) {
                setCookie('address', results[0].formatted_address);
              }
            }
          });
        }
        else {
          if (!isOrderPage) {
            setCookie('address', $('.js-location-pick').val());
          }
        }
        if ($('.js-order-form').length) {
          var location = getLocation($('#location').val()),
            location_d = findLocation(lat, lng) || { id: null };
          if (location_d.id != location.id) {
            $('.js-location-error').removeClass('hidden');
            $('.js-order-submit').attr('disabled', true);
          }
          else {
            $('.js-location-error').addClass('hidden');
            $('.js-order-submit').attr('disabled', false);
          }
        }
        else {
          var location = findLocation(lat, lng),
            windowContent = '<p class="location-text">No restaurants found on this location</p>';
          if (location) {
            windowContent = '<p class="location-text">We found ' + location.restaurants + ' restaurants on this location!</p>' +
              '<a class="btn btn-success" href="' + location.link + '">Show Restaurants</a>';
          }
          if (window.currentInfoWindow) {
            window.currentInfoWindow.close();
          }
          var infowindow = new google.maps.InfoWindow({
            content: windowContent
          });
          infowindow.open(map,marker);
          window.currentInfoWindow = infowindow;
        }
      },
      initMap = function () {
        if (map != null) {
          return;
        }
        var lat = 59.9174455,
          lng = 30.3250575;
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 12,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          center: new google.maps.LatLng(lat, lng)
        }),
        marker = new google.maps.Marker({
          position: new google.maps.LatLng(lat, lng),
          map: map,
          draggable: true
        }),

        google.maps.event.addListener(marker, 'dragend', function() {
          var pos = marker.getPosition();
          applyLocation(pos.lat(), pos.lng(), true);
        });
        $('#map').addClass('-is-visible');
      };

      $('.js-geolocation').click(function (ev) {
        ev.preventDefault();
        navigator.geolocation.getCurrentPosition(function (position) {
          initMap();
          var ll = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
          applyLocation(position.coords.latitude, position.coords.longitude, true);
          marker.setPosition(ll);
          map.setCenter(ll);
          $('.js-geolocation-holder').addClass('hidden');
        });
      });

      google.maps.event.addListener(autocomplete, 'place_changed', function() {
        initMap();
        var place = autocomplete.getPlace();
        if (place.geometry.viewport) {
          map.fitBounds(place.geometry.viewport);
        } else {
          map.setCenter(place.geometry.location);
          map.setZoom(17);
        }
        var image = new google.maps.MarkerImage(
            place.icon, new google.maps.Size(71, 71),
            new google.maps.Point(0, 0), new google.maps.Point(17, 34),
            new google.maps.Size(35, 35));
        marker.setIcon(image);
        marker.setPosition(place.geometry.location);
        applyLocation(place.geometry.location.lat(), place.geometry.location.lng());
      });

      if ($('.js-order-location').length) {
        var lat = parseFloat(getCookie('lat')),
          lng = parseFloat(getCookie('lng')),
          address = getCookie('address'),
          ll = new google.maps.LatLng(lat, lng);
        $('.js-order-location').val(address);
        initMap();
        map.setCenter(ll);
        map.setZoom(17);
        marker.setPosition(ll);
        setTimeout(function () {
          applyLocation(ll.lat(), ll.lng());
        }, 1);
      }
  }

  // if ($('.js-order-location').length) {
  //   var lat = parseFloat(getCookie('lat')),
  //     lng = parseFloat(getCookie('lng')),
  //     address = getCookie('address'),
  //     ll = new google.maps.LatLng(lat, lng);
  //   window.getLocation = getLocation;
  //   if (address != '') {
  //     $('.js-order-location').val(address);
  //     hasAddress = true;
  //   }
  //   initMap();
  //   map.setCenter(ll);
  //   map.setZoom(17);
  //   marker.setPosition(ll);
  //   applyLocation(lat, lng);
  // }
};

$(document).ready(lready);
$(document).on('page:load', lready);
