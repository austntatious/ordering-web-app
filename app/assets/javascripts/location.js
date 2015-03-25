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

  if ($('.js-location-pick').length) {
    var autocomplete = new google.maps.places.Autocomplete($('.js-location-pick')[0], {}),
      map = null,
      marker = null,
      applyLocation = function (lat, lng, detectAddress) {
        if (detectAddress) {
          geocoder = new google.maps.Geocoder();
          geocoder.geocode({
            latLng: new google.maps.LatLng(lat, lng)
          }, function(results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
              $(".js-location-pick").val(results[0].formatted_address);
            }
          });
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
        map = new google.maps.Map(document.getElementById('map'), {
          zoom: 12,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          center: new google.maps.LatLng(59.9174455, 30.3250575)
        }),
        marker = new google.maps.Marker({
          position: new google.maps.LatLng(59.9174455, 30.3250575),
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
  };
};

$(document).ready(lready);
$(document).on('page:load', lready);
