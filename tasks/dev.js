"use strict";

var gulp   = require('gulp'),
    config = require('./config'); 

gulp.task('default', ['browser-sync'], function (){
// gulp.task('dev', function (){
    gulp.watch(config.html.jadeListAll, ['jade']);
    gulp.watch(config.html.htmlList, ['html']);
    // gulp.watch(config.html.layoutsList, ['rebuld_layout_relative_pages']);
    
    gulp.watch(config.js.coffeList, ['coffee']);
    gulp.watch(config.js.jsList, ['js']);
    gulp.watch(config.js.checkerList, ['js_checker']);

    gulp.watch(['./src/assets/img/**/*.*'], ['images']);
    gulp.watch(['./src/assets/sprite-png/*.png'], ['sprite:watch']);
    gulp.watch(config.css.stylusList, ['stylus']);
    gulp.watch(config.css.lessList, ['less']);
    gulp.watch(config.css.cssList, ['css']);
    gulp.watch(config.css.partnersCssList, ['partners_css']);

    gulp.watch(config.css_cabinet.stylusList, ['stylus_cabinet']);
    gulp.watch(config.css_cabinet.lessList, ['less_cabinet']);
    gulp.watch(config.css_cabinet.cssList, ['css_cabinet']);
});