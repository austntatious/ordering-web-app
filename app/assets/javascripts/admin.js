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
//= require kingadmin/bootstrap/bootstrap.js
//= require kingadmin/plugins/modernizr/modernizr.js
//= require kingadmin/plugins/bootstrap-tour/bootstrap-tour.custom.js
//= require kingadmin/king-common.js
//= require kingadmin/plugins/stat/jquery.easypiechart.min.js
//= require kingadmin/plugins/raphael/raphael-2.1.0.min.js
//= require kingadmin/plugins/stat/flot/jquery.flot.min.js
//= require kingadmin/plugins/stat/flot/jquery.flot.resize.min.js
//= require kingadmin/plugins/stat/flot/jquery.flot.time.min.js
//= require kingadmin/plugins/stat/flot/jquery.flot.pie.min.js
//= require kingadmin/plugins/stat/flot/jquery.flot.tooltip.min.js
//= require kingadmin/plugins/jquery-sparkline/jquery.sparkline.min.js
//= require kingadmin/plugins/datatable/jquery.dataTables.min.js
//= require kingadmin/plugins/datatable/dataTables.bootstrap.js
//= require kingadmin/plugins/jquery-mapael/jquery.mapael.js
//= require kingadmin/king-chart-stat.js
//= require kingadmin/king-table.js
//= require kingadmin/king-components.js
//= require ckeditor/init
//= require location_editor
//= require cocoon
//= require jquery-ui/datepicker
//= require_self

$(document).ready(function () {
  $('.js-filters').change(function (ev) {
    $(this).parents('form').submit();
  });

  $.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd'
  });
  $('.js-datepicker').datepicker({
    // onSelect: function () {
    //   alert(22);
    // }
  });
});
