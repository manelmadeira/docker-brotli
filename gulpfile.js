const gulp   = require('gulp');
const brotli = require('gulp-brotli');
const gzip = require('gulp-gzip');

gulp.task('brotli', () => {
  return gulp.src('*.html')
    .pipe(brotli.compress())
    .pipe(gulp.dest('./'));
});

gulp.task('gzip', () => {
  return gulp.src('*.html')
    .pipe(gzip({ append: true }))
    .pipe(gulp.dest('./'));
});

gulp.task('default', () => {
  gulp.start('gzip', 'brotli');
})