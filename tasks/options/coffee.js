module.exports = {
  build: {
    expand: true,
    cwd: 'app',
    src: [ '**/*.coffee' ],
    dest: 'build',
    ext: '.js'
  },
  dev: {
    options: {
      sourceMap: true
    },
    expand: true,
    cwd: 'app',
    src: [ '**/*.coffee' ],
    dest: 'build',
    ext: '.js'
  },
  server: {
    expand: true,
    cwd: 'server',
    src: [ '**/*.coffee' ],
    dest: 'build/server',
    ext: '.js'
  }
};