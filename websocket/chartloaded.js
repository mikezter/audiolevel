var chartLoaded = function() {
  var avg = this.series[0];
  var peak = this.series[1];
  var socket = io.connect("http://localhost:3000");

  socket.on('data', function (data) {
    // $('#data').append(JSON.stringify(data)).append("\n");

    avg.addPoint([data.time, data.avg], true, true);
    peak.addPoint([data.time, data.peak], true, true);
  });

}

