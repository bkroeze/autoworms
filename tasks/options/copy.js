module.exports = {
  build: {
    cwd: 'app',
    src: [ '**', '!**/*.scss', '!**/*.coffee', '!**/*.jade' ],
    dest: 'build',
    expand: true
  }
};
