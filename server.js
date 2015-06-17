//?
var express = require('express'),
    app = express(),
    connect = require('connect'),
    sys = require('sys'),
    tmp = require('tmp'),
    fs = require('fs'),
    exec = require('child_process').exec;

/**
 * Configuration
 */

app.use(express.bodyParser());
app.use(connect.compress());
app.use(express.methodOverride());
app.use(app.router);

app.set('views', __dirname);
app.engine('html', require('ejs').renderFile);

app.configure('development', function(){
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
    app.use(express.errorHandler());
});

app.get('/', function (req, res)
{
    res.render('index.html');
});
app.post('/', function(req, res) {

    // output format (pdf or png )

    tmp.file({postfix: '.svg'}, function _tempFileCreated(err, inputFilePath, fd) {

        if (err) {
            res.json(500, err);
        } else {
            fs.writeFile(inputFilePath, req.body.data, function(err) {
                if (err) {
                    res.json(500, err);
                } else {
                    tmp.file({postfix: '.'+req.body.output_format}, function _tempFileCreated(err, outputFilePath, fd) {
                        if (err) {
                            res.json(500, err);
                        } else {
                            var cmd = "rsvg-convert -z 5 --background-color white -a";
                            cmd += " -f "+req.body.output_format;
                            cmd += " -o "+outputFilePath;
                            cmd += " "+inputFilePath;

                            exec(cmd, function (error, stdout, stderr) {

                                if (error !== null) {
                                    res.json(500, error);
                                } else {
                                    res.attachment(outputFilePath);
                                    res.sendfile(outputFilePath);
                                }
                            });
                        }
                    });
                }
            });
        }
    });
});


var port = process.env.PORT || 5000;

app.listen(port, function() {
  console.log('Listening on http://localhost:'+ port);
});