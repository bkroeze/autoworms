module.exports = {
  build: {
    expand: true,
        cwd: 'app',
        src: [ '**/*.coffee' ],
        dest: 'build',
        ext: '.js'
  }
};