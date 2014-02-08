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
    src: [ '**', '**/*.coffee', '**/*js', '!**/*.scss', '!**/*.jade' ],
    dest: 'build',
    expand: true
  },
  devfix: {
    expand: true,
    cwd: 'app',
    src: ['**/*.coffee'],
    dest: 'build/app'
  }
};
