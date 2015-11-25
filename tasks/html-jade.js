var gulp = require('gulp'),
    html2jade = require('gulp-html2jade');

gulp.task('html-jade', function(){
  gulp.src('./src/plain-html/**/*.html')
    .pipe(html2jade({nspaces: 2, donotencode: true}))
    .pipe(gulp.dest('./src/jade'));
});