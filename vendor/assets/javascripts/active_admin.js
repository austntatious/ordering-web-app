//= require active_admin/base

$(document).ready(function () {
  var latlng = null,
    marker = null,
    map = null,
    myOptions = {
        zoom: 5,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };

  var setupMarker = function (latlng) {
    marker = new google.maps.Marker({
        position: latlng,
        draggable: true,
        map: map
      });
      $('#location_latitude').val(latlng.lat());
      $('#location_longitude').val(latlng.lng());
      google.maps.event.addListener(marker, 'dragend', function (event) {
        $('#location_latitude').val(event.latLng.lat());
        $('#location_longitude').val(event.latLng.lng());
      });
  };

  if ($('#location_latitude').val() != '0.0') {
    latlng = new google.maps.LatLng(
      parseFloat($('#location_latitude').val()),
      parseFloat($('#location_longitude').val())
    );
    myOptions.center = latlng;
    map = new google.maps.Map(document.getElementById("place-map-holder"), myOptions);
    setupMarker(latlng);
  }
  else {
    latlng = new google.maps.LatLng(37.6, -95.655);
    myOptions.center = latlng;
    map = new google.maps.Map(document.getElementById("place-map-holder"), myOptions);
  }

    google.maps.event.addListener(map, 'click', function (event) {
      if (!marker) {
        setupMarker(event.latLng);
      }
    });
});
