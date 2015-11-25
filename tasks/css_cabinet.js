var gulp     = require('gulp'),
    gstylus  = require('gulp-stylus'),
    stylus = require('stylus'),
    concat = require('gulp-concat'),
    minifyCss = require('gulp-minify-css'),
    less = require('gulp-less'),
    combineMq = require('gulp-combine-mq'),
    autoprefixer = require('gulp-autoprefixer'),
    nib = require('nib'), //stylus mixins
    insert = require('gulp-insert'), //insert to file
    browserSync = require('browser-sync'),
    gutil = require('gulp-util'),
    replace = require('gulp-replace'),
    config     = require('./config').css_cabinet;
 
gulp.task('stylus_cabinet', function(){
  var stylusDir = __dirname.split('tasks')[0] + 'src/stylus/mixins'
  gulp.src(config.stylusList)
    .pipe(concat('_all-stylus_cabinet.styl'))
    .pipe(insert.prepend("@import 'nib'\n@import '"+ stylusDir+  "'\n\n"))
    .pipe(gstylus({
        use: nib(), 
        compress: true,
        set: ['resolve url'],
        define: {'url': stylus.resolver()}
    }))
    .pipe(concat('_stylus_cabinet.css'))
    .pipe(gulp.dest('./src/assets/css'))
});

gulp.task('less_cabinet', function(){
  gulp.src(config.lessList)
    .pipe(less({compress: false}))
    .pipe(concat('_less_cabinet.css'))
    .pipe(autoprefixer({
        browsers: ['last 4 versions'],
        cascade: false
    }))
    .pipe(gulp.dest('./src/assets/css'))
});

gulp.task('css_cabinet', function(){
  gulp.src(config.cssList)
    .pipe(concat('doc-cabinet.min.css'))
    .pipe(autoprefixer({
        browsers: ['last 4 versions'],
        cascade: false
    }))
    .pipe(combineMq({
        beautify: false
    }))
    .pipe(minifyCss({compatibility: 'ie8'}))
    .pipe(replace('src/assets/css/i', 'i'))
    .pipe(gulp.dest('./build'))
        .on('finish', function() {
            gutil.log(gutil.colors.cyan('Cabinet styles copying finished'));
            browserSync.reload();
        })
});
