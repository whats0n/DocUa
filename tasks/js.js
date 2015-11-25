var gulp   = require('gulp'),
    coffee = require('gulp-coffee'),
    gutil = require('gulp-util'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    browserSync = require('browser-sync'),
    sourcemaps = require('gulp-sourcemaps'),
    config = require('./config').js

gulp.task('coffee', function() {
  gulp.src(config.coffeList)
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(concat('_coffee.js'))
    .pipe(gulp.dest('./src/assets/js'))
});

gulp.task('js', function(){
  gulp.src(config.jsList)
    //.pipe(sourcemaps.init())
    .pipe(concat('doc.min.js'))
        //.pipe(uglify({mangle: {toplevel: false}}))
    //.pipe(sourcemaps.write())
    .pipe(gulp.dest('./build'))
        .on('finish', function() {
            gutil.log(gutil.colors.cyan('Js copying finished'));
            browserSync.reload();
        })
});

gulp.task('js_checker', function(){
  gulp.src(config.checkerList)
    .pipe(concat('checker-deps.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest('./build'))
        .on('finish', function() {
            gutil.log(gutil.colors.cyan('Checker JS copying finished'));
            browserSync.reload();
        })
});
