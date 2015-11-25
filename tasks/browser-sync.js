var gulp   = require('gulp'),
    browserSync = require('browser-sync');

// Start the server
gulp.task('browser-sync', function() {
    browserSync({
        port: 3030,
        server: {
            baseDir: './build'
        },
        reloadOnRestart: false
    });
});