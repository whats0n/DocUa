var gulp     = require('gulp'),
    gstylus  = require('gulp-stylus'),
    stylus = require('stylus'),
    concat = require('gulp-concat'),
    minifyCss = require('gulp-minify-css'),
    config     = require('./config').css,
    less = require('gulp-less'),
    combineMq = require('gulp-combine-mq'),
    autoprefixer = require('gulp-autoprefixer'),
    nib = require('nib'), //stylus mixins
    insert = require('gulp-insert'), //insert to file
    browserSync = require('browser-sync'),
    gutil = require('gulp-util'),
    replace = require('gulp-replace');
 
gulp.task('stylus', function(){
  var stylusDir = __dirname.split('tasks')[0] + 'src/stylus/mixins/mixins'
  gulp.src(config.stylusList)
    .pipe(concat('_all-stylus.styl'))
    .pipe(insert.prepend("@import 'nib'\n@import '"+ stylusDir+  "'\n\n"))
    .pipe(gstylus({
        use: nib(), 
        // compress: true,
        set: ['resolve url'],
        define: {'url': stylus.resolver()}
    }))
    .pipe(concat('_stylus.css'))
    // .pipe(autoprefixer({
    //     browsers: ['last 10 versions'],
    //     cascade: true
    // }))
    .pipe(gulp.dest('./src/assets/css'))
});

gulp.task('less', function(){
  gulp.src(config.lessList)
    .pipe(less({compress: false}))
    .pipe(concat('_less.css'))
    .pipe(autoprefixer({
        browsers: ['last 4 versions'],
        cascade: false
    }))
    .pipe(gulp.dest('./src/assets/css'))
});

gulp.task('css', function(){
  gulp.src(config.cssList)
    .pipe(concat('doc.min.css'))
    .pipe(autoprefixer({
        browsers: ['last 4 versions'],
        cascade: false
    }))
    .pipe(combineMq({
        beautify: false
    }))
    .pipe(minifyCss({compatibility: 'ie8'}))
    // .pipe(replace('src/assets/css/i', 'i'))
    .pipe(replace('/i/', 'i/'))
    .pipe(gulp.dest('./build'))
        //.on('finish', function() {
            //gutil.log(gutil.colors.cyan('Styles copying finished'));
            //browserSync.reload();
        //})
    .pipe(browserSync.stream());
});

gulp.task('partners_css', function(){
  gulp.src(config.partnersCssList)
    .pipe(gulp.dest('./build/partners-branding/'))
        .on('finish', function() {
            gutil.log(gutil.colors.cyan('Partners styles copying finished'));
            browserSync.reload();
        })
});

