module.exports = {
  options: {
    sassDir: 'app/styles',
    imagesDir: 'app/images',
    // javascriptsDir: 'app/scripts',
    fontsDir: 'app/styles/fonts',
    // importPath: 'app/bower_components',
    force: true,
    relativeAssets: true
  },
  dev: {
    options: {
      specify: 'app/styles/main.scss',
      cssDir: 'build/styles'
    }
  }
};