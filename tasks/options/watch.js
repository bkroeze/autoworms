module.exports = {
  stylesheets: {
    files: 'app/**/*.scss',
        tasks: [ 'stylesheets' ]
  },
  scripts: {
    files: 'app/**/*.coffee',
        tasks: [ 'scripts' ]
  },
  jade: {
    files: 'app/**/*.jade',
        tasks: [ 'jade' ]
  },
  copy: {
    files: [ 'app/**', '!app/**/*.scss', '!app/**/*.coffee', '!app/**/*.jade' ],
        tasks: [ 'copy' ]
  }
};