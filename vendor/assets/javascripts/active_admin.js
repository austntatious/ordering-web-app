//= require active_admin/base
//= require ckeditor/init

$(document).ready(function () {
  if (google !== undefined) {
    var latlng = null,
      marker = null,
      map = null,
      myOptions = {
          zoom: 5,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };

    // var setupMarker = function (latlng) {
    //   marker = new google.maps.Marker({
    //       position: latlng,
    //       draggable: true,
    //       map: map
    //     });
    //     $('#location_latitude').val(latlng.lat());
    //     $('#location_longitude').val(latlng.lng());
    //     google.maps.event.addListener(marker, 'dragend', function (event) {
    //       $('#location_latitude').val(event.latLng.lat());
    //       $('#location_longitude').val(event.latLng.lng());
    //     });
    // };

    // if ($('#location_latitude').val() != '0.0') {
    //   latlng = new google.maps.LatLng(
    //     parseFloat($('#location_latitude').val()),
    //     parseFloat($('#location_longitude').val())
    //   );
    //   myOptions.center = latlng;
    //   map = new google.maps.Map(document.getElementById("place-map-holder"), myOptions);
    //   setupMarker(latlng);
    // }
    // else {

    // }
    latlng = new google.maps.LatLng(37.6, -95.655);
    myOptions.center = latlng;
    map = new google.maps.Map(document.getElementById("place-map-holder"), myOptions);

    var initDrawManager = true;

    if ($('#location_coords').val() != '') {
      var points = $.parseJSON($('#location_coords').val()),
        ll_points = [];
      for (var i = 0; i < points.length; i++) {
        ll_points.push(
          new google.maps.LatLng(points[i].lat, points[i].lng)
        );
      }
      var l_polygon = new google.maps.Polygon({
        paths: [ll_points],
        map: map,
        editable: true,
        draggable: true
      });
      initDrawManager = false;
      console.log(points);
    }

    var drawn_polygon = null,
      coordsStr = '',
      setCoordsStr = function (path) {
        var data = [],
          points = path.getPath().getArray();
        for (var i = 0; i < points.length; i++) {
          data.push({
            lat: points[i].lat(),
            lng: points[i].lng()
          });
        }
        coordsStr = JSON.stringify(data);
        $('#location_coords').val(coordsStr);
        return data;
      };

    if (initDrawManager) {
      var drawingManager = new google.maps.drawing.DrawingManager({
        drawingMode: google.maps.drawing.OverlayType.POLYGON,
        drawingControl: false,
        polygonOptions: {
          editable: true,
          draggable: true
        },
        drawingControlOptions: {
          position: google.maps.ControlPosition.TOP_CENTER,
          drawingModes: [google.maps.drawing.OverlayType.POLYGON]
        }
      });
      drawingManager.setMap(map);

      google.maps.event.addListener(drawingManager, 'overlaycomplete', function(e) {
        drawingManager.setDrawingMode(null);
      });

      google.maps.event.addListener(drawingManager, 'polygoncomplete', function (polygon) {
        drawn_polygon = polygon;
        setCoordsStr(polygon);
        google.maps.event.addListener(polygon.getPath(), 'set_at', function() {
          setCoordsStr(polygon);
        });
        google.maps.event.addListener(polygon.getPath(), 'insert_at', function() {
          setCoordsStr(polygon);
        });
        google.maps.event.addListener(polygon.getPath(), 'remove_at', function() {
          setCoordsStr(polygon);
        });
        google.maps.event.addListener(polygon, 'dragend', function () {
          setCoordsStr(polygon);
        });
      });
    }
    else {
      drawn_polygon = l_polygon;
      polygon = l_polygon;
      google.maps.event.addListener(polygon.getPath(), 'set_at', function() {
        setCoordsStr(polygon);
      });
      google.maps.event.addListener(polygon.getPath(), 'insert_at', function() {
        setCoordsStr(polygon);
      });
      google.maps.event.addListener(polygon.getPath(), 'remove_at', function() {
        setCoordsStr(polygon);
      });
      google.maps.event.addListener(polygon, 'dragend', function () {
        setCoordsStr(polygon);
      });
    }
  }
});
