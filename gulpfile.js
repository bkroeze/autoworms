'use strict';
var gulp = require('gulp'),
  autoprefixer = require('gulp-autoprefixer'),
  clean = require('gulp-clean'),
  coffee = require('gulp-coffee'),
  coffeelint = require('gulp-coffeelint'),
  concat = require('gulp-concat'),
  connect = require('gulp-connect'),
  jade = require('gulp-jade'),
  livereload = require('gulp-livereload'),
  maybe = require('gulp-if'),
  ngmin = require('gulp-ngmin'),
  reloader = require('connect-livereload'),
  sass = require('gulp-sass'),
  uglify = require('gulp-uglify'),
  util = require('gulp-util'),
  production = util.env.production || util.env.prod,
  spawn = require('gulp-spawn'),
  paths = {
    build: 'build',
    scripts: {
      src: 'app/scripts/**/*.coffee',
      dest: 'build/scripts'
    },
    js: {
      src: 'app/scripts/**/*.js',
      dest: 'build/scripts'
    },
    styles: {
      src: 'app/styles/**/*.scss',
      dest: 'build/styles'
    },
    templates: {
      src: 'app/templates/**/*.jade',
      dest: 'build'
    }
  };

var EXPRESS_PORT = 9000;
var EXPRESS_ROOT = 'build';
var LIVERELOAD_PORT = 35729;

gulp.task('server', function() {
  var express = require('express');
  var app = express();
  app.use(reloader({
    port: LIVERELOAD_PORT
  }));
  app.use(express.static(EXPRESS_ROOT));
  app.listen(EXPRESS_PORT);
});

gulp.task('clean', function() {
  return gulp.src(paths.build)
    .pipe(spawn({
          cmd: 'rm',
          args: [
              '-rf',
              'build'
          ]
      }));
});

gulp.task('scripts', function() {
  return gulp.src(paths.scripts.src)
    .pipe(coffee())
    .pipe(ngmin())
    .pipe(maybe(production, uglify()))
    .pipe(maybe(production, concat('app.min.js')))
    .pipe(gulp.dest(paths.scripts.dest));
});

gulp.task('js', function() {
  return gulp.src(paths.js.src)
    .pipe(maybe(production, uglify()))
    .pipe(maybe(production, concat('js.min.js')))
    .pipe(gulp.dest(paths.js.dest));
});

gulp.task('styles', function() {
  return gulp.src(paths.styles.src)
    .pipe(sass())
    .pipe(autoprefixer())
    .pipe(gulp.dest(paths.styles.dest));
});

gulp.task('lint', function() {
  return gulp.src(paths.scripts.src)
    .pipe(coffeelint())
    .pipe(coffeelint.reporter());
});

gulp.task('templates', function() {
  return gulp.src(paths.templates.src)
    .pipe(
      jade({
        pretty: true,
        locals: {
          debug: true
        }
      }))
    .pipe(gulp.dest(paths.templates.dest));
});

gulp.task('watch', function () {
  setTimeout(function() {
    util.log('Starting the watches');
    var server = livereload(LIVERELOAD_PORT);
    gulp.watch('build/**/*').on('change', function(file) {
      server.changed(file.path);
    });
    gulp.watch(paths.templates.src, ['templates']);
    gulp.watch(paths.styles.src, ['styles']);
    gulp.watch(paths.scripts.src, ['scripts']);
  }, 2000);
});

// gulp.task('default', ['lint', 'clean', 'styles', 'templates', 'scripts', 'server', 'watch']);
gulp.task('default', ['clean', 'styles', 'templates', 'scripts', 'js', 'server', 'watch']);
