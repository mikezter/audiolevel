var app = require('http').createServer(handler),
    io = require('socket.io').listen(app),
    fs = require('fs'),
    //rl = require('readline'),
    url = require('url'),
    path = require('path');

process.stdin.resume(); // needed if not using readline
process.stdin.setEncoding('ascii');
app.listen(3000);

var mimeTypes = {
  "html": "text/html",
  "js": "text/javascript",
  "css": "text/css"
};

function handler (req, res) {
  var uri = url.parse(req.url).pathname;
  var filename = path.join(process.cwd(), uri);
  fs.readFile(filename, function (err,data) {
    if (err) {
      res.writeHead(301, {'Location': '/index.html'});
      return res.end('redirecting...');
    }
    var mimeType = mimeTypes[path.extname(filename).split('.')[1]];
    res.writeHead(200, {'Content-Type':mimeType});
    res.end(data);
  });
}

function parseLine(line) {
  var data = line.trim().split(" ");
  return {
    time: parseInt(data[0], 10),
     avg: parseFloat(data[1], 10),
    peak: parseFloat(data[2], 10)
  }

}

io.sockets.on('connection', function (socket) {
  process.stdin.on('data', function(chunk) {
    socket.volatile.emit('data', parseLine(chunk));
  });
});
