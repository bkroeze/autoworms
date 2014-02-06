module.exports = {
  dev: {
    options: {
      pretty: true,
      data: {
        debug: true
      }
    },
    files: [{
      expand: true,
      cwd: 'app',
      src: [ '**/*.jade' ],
      dest: 'build',
      ext: '.html'
    }]
  },
  prod: {
    options: {
      data: {
        debug: false
      }
    },
    files: [{
      expand: true,
      cwd: 'app',
      src: [ '**/*.jade' ],
      dest: 'build',
      ext: '.html'
    }]
  }
};