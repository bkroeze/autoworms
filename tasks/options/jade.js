module.exports = {
  compile: {
    options: {
      data: {}
    },
    files: [{
      expand: true,
      cwd: 'source',
      src: [ '**/*.jade' ],
      dest: 'build',
      ext: '.html'
    }]
  }
};