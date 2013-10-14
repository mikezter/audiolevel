$(function() {

	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});

	// Create the chart
	$('#container').highcharts('StockChart', {
		chart : {
			events : {
				load : function() {
          var series = this.series[0];
          window.series = series;
          var socket = io.connect("http://localhost:3000");
          socket.on('data', function (data) {
            // $('#data').append(JSON.stringify(data)).append("\n");
            series.addPoint(data, true, true);
          });
        }
      }
    },

		rangeSelector: {
			buttons: [{
				count: 1,
				type: 'minute',
				text: '1M'
			}, {
				count: 5,
				type: 'minute',
				text: '5M'
			}, {
				type: 'all',
				text: 'All'
			}],
			inputEnabled: false,
			selected: 0
		},

		title : {
			text : 'Live random data'
		},

		exporting: {
			enabled: false
		},

		series : [{
			name : 'Random data',
			data : (function() {
				// generate an array of 100 data points
				var data = [], time = (new Date()).getTime(), i;

				for( i = -999; i <= 0; i++) {
					data.push([
						time + i * 1000,
            0
					]);
				}
				return data;
			}())
    }]
	});

});
