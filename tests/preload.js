'use strict';
var glob = require('glob'),
    path = require('path')

module.exports = function(globs, base) {
  console.log(globs);
  for (var i=0; i<globs.length; i++) {
    var fp = path.join(base, globs[i]),
        files = glob.sync(fp);
    for (var j=0; j<files.length; j++) {
      var fn = files[j];
      console.log("loading: " + fn);
      require(fn);
    }
  }
};

