var gulp = require('gulp'),
    yaml = require('gulp-yaml');

gulp.task('yaml', function(){
    gulp.src(['./src/templates/data/*.yaml', '!./src/templates/data/landingConsultationsServices.yaml', '!./src/templates/data/tretmentsWorld.yaml'])
        .pipe(yaml({ space: 2 }))
        .pipe(gulp.dest('./src/templates/data/json')) 
});