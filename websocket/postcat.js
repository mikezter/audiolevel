var request = require('request');

process.stdin.resume();
process.stdin.setEncoding('ascii');

function parseLine(line) {
  var data = line.trim().split(" ");
  return {
    timestamp: parseInt(data[0], 10),
    db: 80 + parseInt(data[1], 10)/2,
    machine: "mokbox"
  };

}

process.stdin.on('data', function(chunk) {
  var object = parseLine(chunk);
  console.log(object);
  postToES(object);
});

function postToES(object) {
  var r = request.post({
        uri: 'http://192.168.60.77:9200/sound/db',
        json: object
      },
      function(error, response, body) {
        console.log(body);
      });
}
