$(document).ready(function() {

    /* initialize the external events
    -----------------------------------------------------------------*/

    $('#external-events div.external-event').each(function() {

      // create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
      // it doesn't need to have a start or end
      var eventObject = {
        title: $.trim($(this).text()) // use the element's text as the event title
      };

      // store the Event Object in the DOM element so we can get to it later
      $(this).data('eventObject', eventObject);

      // make the event draggable using jQuery UI
      $(this).draggable({
        zIndex: 999,
        revert: true,      // will cause the event to go back to its
        revertDuration: 0  //  original position after the drag
      });

    });


    /* initialize the calendar
    -----------------------------------------------------------------*/

    var date = new Date();
    var d = date.getDate();
    var m = date.getMonth();
    var y = date.getFullYear();

    var calendar = $('#calendar').fullCalendar({
      header: {
        left: '',
        center: 'title',
        right: 'prev,next'
      },
      selectable: true,
      selectHelper: true,
      select: function(start, end, allDay) {
        var title = prompt('Event Title:');
        if (title) {
          calendar.fullCalendar('renderEvent',
            {
              title: title,
              start: start,
              end: end,
              allDay: allDay
            },
            true // make the event "stick"
          );
        }
        calendar.fullCalendar('unselect');
      },
      editable: true,
      droppable: true, // this allows things to be dropped onto the calendar !!!
      drop: function(date, allDay) { // this function is called when something is dropped

        // retrieve the dropped element's stored Event Object
        var originalEventObject = $(this).data('eventObject');

        // we need to copy it, so that multiple events don't have a reference to the same object
        var copiedEventObject = $.extend({}, originalEventObject);

        // assign it the date that was reported
        copiedEventObject.start = date;
        copiedEventObject.allDay = allDay;

        // copy label class from the event object
        var labelClass = $(this).data('eventclass');

        if (labelClass) {
          copiedEventObject.className = labelClass;
        }

        // render the event on the calendar
        // the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
        $('#calendar').fullCalendar('renderEvent', copiedEventObject, true);

        // is the "remove after drop" checkbox checked?
        if ($('#drop-remove').is(':checked')) {
          // if so, remove the element from the "Draggable Events" list
          $(this).remove();
        }

      },
      buttonText: {
        prev: '<i class="fa fa-chevron-left"></i>',
        next: '<i class="fa fa-chevron-right"></i>'
      },
      events: [
        {
          title: 'All Day Event',
          start: new Date(y, m, 1),
          className: 'label-success'
        },
        {
          title: 'Long Event',
          start: new Date(y, m, d-5),
          end: new Date(y, m, d-2)
        },
        {
          id: 999,
          title: 'Repeating Event',
          start: new Date(y, m, d-3, 16, 0),
          allDay: false,
          className: 'label-danger'
        },
        {
          id: 999,
          title: 'Repeating Event',
          start: new Date(y, m, d+4, 16, 0),
          allDay: false
        },
        {
          title: 'Meeting',
          start: new Date(y, m, d, 10, 30),
          allDay: false,
          className: 'label-info'
        },
        {
          title: 'Lunch',
          start: new Date(y, m, d, 12, 0),
          end: new Date(y, m, d, 14, 0),
          allDay: false,
          className: 'label-success'
        },
        {
          title: 'Birthday Party',
          start: new Date(y, m, d+1, 19, 0),
          end: new Date(y, m, d+1, 22, 30),
          allDay: false,
          className: 'label-info'
        },
        {
          title: 'Click for Google',
          start: new Date(y, m, 28),
          end: new Date(y, m, 29),
          url: 'http://google.com/',
          className: 'label-danger'
        }
      ]
    });

      $('.conversation-inner').slimScroll({
          height: '340px',
          alwaysVisible: false,
          railVisible: true,
          wheelStep: 5,
          allowPageScroll: false
      });


      //CHARTS
    // graphLine = Morris.Area({
    //   element: 'graph-line',
    //   data: [
    //     {period: '2014-01-01', iphone: 2666, ipad: null, itouch: 2647},
    //     {period: '2014-01-02', iphone: 9778, ipad: 2294, itouch: 2441},
    //     {period: '2014-01-03', iphone: 4912, ipad: 1969, itouch: 2501},
    //     {period: '2014-01-04', iphone: 3767, ipad: 3597, itouch: 5689},
    //     {period: '2014-01-05', iphone: 6810, ipad: 1914, itouch: 2293},
    //     {period: '2014-01-06', iphone: 5670, ipad: 4293, itouch: 1881},
    //     {period: '2014-01-07', iphone: 4820, ipad: 3795, itouch: 1588},
    //     {period: '2014-01-08', iphone: 15073, ipad: 5967, itouch: 5175},
    //     {period: '2014-01-09', iphone: 10687, ipad: 4460, itouch: 2028},
    //     {period: '2014-01-10', iphone: 8432, ipad: 5713, itouch: 1791}
    //   ],
    //   //lineColors: ['#77ab49', '#d5ac08', '#dd504c', '#3fcfbb', '#626f70', '#8f44ad'],
    //   lineColors: ['#3fcfbb', '#f1c40f', '#8f44ad', '#3fcfbb', '#626f70', '#8f44ad'],
    //   xkey: 'period',
    //   ykeys: ['iphone', 'ipad', 'itouch'],
    //   labels: ['iPhone', 'iPad', 'iPod Touch'],
    //   pointSize: 3,
    //   hideHover: 'auto'
    // });

    // bar charts
    var db1 = db2 = db3 = db4 = [];
    for (var i = 0; i <= 20; i += 1) {
      db1.push([i, parseInt(Math.random() * 30)]);
    }
    var db2 = [];
    for (var i = 0; i <= 20; i += 1) {
      db2.push([i, parseInt(Math.random() * 30)]);
    }
    var db3 = [];
    for (var i = 0; i <= 20; i += 1) {
      db3.push([i, parseInt(Math.random() * 30)]);
    }
    var db4 = [];
    for (var i = 0; i <= 20; i += 1) {
      db4.push([i, parseInt(Math.random() * 30)]);
    }

    var series = new Array();
    series.push({
      data : db1,
      bars : {
        show : true,
        barWidth : 0.6,
        order : 1,
        fill: 1
      },
      threshold: { below: 0, color: '#fe635f' },
    });

    var series2 = new Array();
    series2.push({
      data : db2,
      bars : {
        show : true,
        barWidth : 0.6,
        order : 1,
        fill: 1
      },
      threshold: { below: 0, color: '#fe635f' },
    });

    var series3 = new Array();
    series3.push({
      data : db3,
      bars : {
        show : true,
        barWidth : 0.6,
        order : 1,
        fill: 1
      },
      threshold: { below: 0, color: '#fe635f' },
    });

    var series4 = new Array();
    series4.push({
      data : db4,
      bars : {
        show : true,
        barWidth : 0.6,
        order : 1,
        fill: 1
      },
      threshold: { below: 0, color: '#fe635f' },
    });

    // $.plot("#graph-line-pageviews", series, {
    //   colors: ['#77ab49', '#f1c40f', '#8dc859', '#3fcfbb', '#8f44ad', '#7e8c8d'],
    //   grid: {
    //     tickColor: "#ddd",
    //     borderWidth: 0,
    //     show: false
    //   },
    //   shadowSize: 0
    // });

    // $.plot("#graph-line-visits", series2, {
    //   colors: ['#77ab49', '#f1c40f', '#8dc859', '#3fcfbb', '#8f44ad', '#7e8c8d'],
    //   grid: {
    //     tickColor: "#ddd",
    //     borderWidth: 0,
    //     show: false
    //   },
    //   shadowSize: 0
    // });

    // $.plot("#graph-line-avg-time", series3, {
    //   colors: ['#77ab49', '#f1c40f', '#8dc859', '#3fcfbb', '#8f44ad', '#7e8c8d'],
    //   grid: {
    //     tickColor: "#ddd",
    //     borderWidth: 0,
    //     show: false
    //   },
    //   shadowSize: 0
    // });

    // $.plot("#graph-line-bounce", series4, {
    //   colors: ['#77ab49', '#f1c40f', '#8dc859', '#3fcfbb', '#8f44ad', '#7e8c8d'],
    //   grid: {
    //     tickColor: "#ddd",
    //     borderWidth: 0,
    //     show: false
    //   },
    //   shadowSize: 0
    // });

    // graphDonut = Morris.Donut({
    //   element: 'hero-donut',
    //   data: [
    //     {label: 'Chrome', value: 45 },
    //     {label: 'Firefox', value: 30 },
    //     {label: 'IE 10', value: 25 }
    //   ],
    //   colors: ['#fe635f', '#8dc859', '#f1c40f', '#8f44ad', '#626f70', '#8f44ad'],
    //   formatter: function (y) { return y + "%" }
    // });

    // $(window).smartresize(function(){
    //   graphLine.redraw();
    //   graphDonut.redraw();
    // });

    //DateRange
    $('#reportrange').daterangepicker({
        startDate: moment().subtract('days', 29),
        endDate: moment(),
        minDate: '01/01/2012',
        maxDate: '12/31/2014',
        dateLimit: { days: 60 },
        showDropdowns: true,
        showWeekNumbers: true,
        timePicker: false,
        timePickerIncrement: 1,
        timePicker12Hour: true,
        ranges: {
          'Today': [moment(), moment()],
          'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
          'Last 7 Days': [moment().subtract('days', 6), moment()],
          'Last 30 Days': [moment().subtract('days', 29), moment()],
          'This Month': [moment().startOf('month'), moment().endOf('month')],
          'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
        },
        opens: 'left',
        buttonClasses: ['btn btn-default'],
        applyClass: 'btn-small btn-primary',
        cancelClass: 'btn-small',
        format: 'MM/DD/YYYY',
        separator: ' to ',
        locale: {
          applyLabel: 'Submit',
          fromLabel: 'From',
          toLabel: 'To',
          customRangeLabel: 'Custom Range',
          daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr','Sa'],
          monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
          firstDay: 1
        }
      },
      function(start, end) {
        console.log("Callback has been called!");
        $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
      }
    );
    //Set the initial state of the picker label
    $('#reportrange span').html(moment().subtract('days', 29).format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));

    //WORLD MAP
    $('#world-map').vectorMap({
      map: 'world_merc_en',
      backgroundColor: '#ffffff',
      zoomOnScroll: false,
      regionStyle: {
        initial: {
          fill: '#e1e1e1',
          stroke: 'none',
          "stroke-width": 0,
          "stroke-opacity": 1
        },
        hover: {
          "fill-opacity": 0.8
        },
        selected: {
          fill: '#8dc859'
        },
        selectedHover: {
        }
      },
      series: {
        regions: [{
          values: gdpData,
          scale: ['#b1fff6', '#02a794'],
          normalizeFunction: 'polynomial'
        }]
      },
      onRegionLabelShow: function(e, el, code){
        el.html(el.html()+' ('+gdpData[code]+')');
      }
    });
  });
