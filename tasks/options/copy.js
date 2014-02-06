module.exports = {
  build: {
    cwd: 'app',
    src: [ '**', '!**/*.scss', '!**/*.coffee', '!**/*.jade' ],
    dest: 'build',
    expand: true
  },
  buildhtml: {
    cwd: 'build/templates',
    src: ['**/*.html'],
    dest: 'build',
    expand: true
  }
};
