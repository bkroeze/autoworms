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
  },
  dev: {
    cwd: 'app',
    src: [ '**', '**/*js', '!**/*.scss', '!**/*.jade' ],
    dest: 'build',
    expand: true
  },
  devfix: {
    expand: true,
    cwd: 'app',
    src: ['**/app.coffee'],
    dest: 'build/app'
  }
};
