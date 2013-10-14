$(function() {

  var randomData = function() {
    // generate an array of 100 data points
    var data = [], time = (new Date()).getTime(), i;

    for( i = -999; i <= 0; i++) {
      data.push([
        time + i * 1000,
        0
        ]);
    }
    return data;
  }

	Highcharts.setOptions({
		global : {
			useUTC : false
		}
	});

	// Create the chart
	$('#container').highcharts('StockChart', {
		chart : {
			events : {
				load : chartLoaded
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
			text : 'Live office noise'
		},

		exporting: {
			enabled: false
		},

		series : [{
			name : 'avg',
			data : randomData()
    }, {
      name : 'peak',
      data : randomData()
    }]
	});

});
