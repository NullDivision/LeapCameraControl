var express=require("express");
var app=express();

app.use(express.static(__dirname + '/uploads'));
app.listen(8080);