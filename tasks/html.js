var gulp = require('gulp'),
    jade = require('gulp-jade'),
    gutil = require('gulp-util'),
    prettify = require('gulp-html-prettify'),
    browserSync = require('browser-sync'),
    dataParser = require('doc-data-parser'),
    rebuildPages = require('doc-data-parser/rebuild_pages.js'),
    // pagesCollector = require('doc-data-parser/pages_collector.js'),
    insert = require('gulp-insert'), //insert to file
    changed = require('gulp-changed'),
    config = require('./config').html,
    replace = require('gulp-replace');

gulp.task('jade', function(){
    gulp.src(config.jadeList)
        .pipe(changed('./build', {extension: '.html'}))
        .pipe(dataParser())
        // .pipe(pagesCollector())
        // .pipe(rebuildPages())
        .pipe(jade({
            pretty: true
        }))
        .pipe(replace('/i/', 'i/'))
        .pipe(gulp.dest('./build/')
            .on('finish', function() {
                gutil.log(gutil.colors.cyan('Templates copying finished'));
                browserSync.reload();
            })
        )
});

gulp.task('rebuld_layout_relative_pages', function(){ //rebuild relative pages on layouts save
    gulp.src(config.layoutsList)
        .pipe(changed('./build/.tmp', {extension: '.jade'}))
        .pipe(rebuildPages('layout'))
        .pipe(gulp.dest('./build/.tmp')
            .on('finish', function() {
                gutil.log(gutil.colors.cyan('Templates copying finished'));
                browserSync.reload();
            })
        )
});

gulp.task('html', function(){
    gulp.src(config.htmlList)
        .pipe(changed('./build', {extension: '.html'}))
        .pipe(prettify({indent_char: ' ', indent_size: 2}))
        .pipe(gulp.dest('./build/')
            .on('finish', function() {
                gutil.log(gutil.colors.cyan('Templates copying finished'));
                browserSync.reload();
            })
        )
});
