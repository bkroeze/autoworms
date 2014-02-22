'use strict';
var gulp = require('gulp'),
  autoprefixer = require('gulp-autoprefixer'),
  coffee = require('gulp-coffee'),
  concat = require('gulp-concat'),
  connect = require('gulp-connect'),
  jade = require('gulp-jade'),
  uglify = require('gulp-uglify'),
  coffeelint = require('gulp-coffeelint'),
  clean = require('gulp-clean'),
  util = require('gulp-util'),
  maybe = require('gulp-if'),
  ngmin = require('gulp-ngmin'),
  sass = require('gulp-sass'),
  production = util.env.production || util.env.prod,
  paths = {
    build: 'build',
    scripts: {
      src: 'app/scripts/**/*.coffee',
      dest: 'build/scripts'
    },
    vendor: {
      src: 'app/scripts/**/*.js',
      dest: 'build/scripts'
    },
    styles: {
      src: 'app/styles/**/*scss',
      dest: 'build/styles'
    },
    templates: {
      src: 'app/templates/**/*.jade',
      dest: 'build'
    }
  };

gulp.task('clean', function() {
  return gulp.src(paths.build)
    .pipe(clean());
});



gulp.task('scripts', function() {
  return gulp.src(paths.scripts.src)
    .pipe(coffee())
    .pipe(ngmin())
    .pipe(maybe(production, uglify()))
    .pipe(maybe(production, concat('app.min.js')))
    .pipe(gulp.dest(paths.scripts.dest));
});

gulp.task('vendor', function() {
  return gulp.src(paths.vendor.src)
    .pipe(maybe(production, uglify()))
    .pipe(maybe(production, concat('vendor.min.js')))
    .pipe(gulp.dest(paths.scripts.dest));
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
  gulp.watch(['./app/*.jade'], ['templates']);
  gulp.watch(['./app/styles/*.scss'], ['styles']);
  gulp.watch(['./app/scripts/*.coffee'], ['scripts']);
});

// gulp.task('default', ['lint', 'clean', 'styles', 'templates', 'scripts', 'server', 'watch']);
gulp.task('default', ['clean', 'styles', 'templates', 'scripts', 'vendor', 'watch']);
