config = require './config.coffee'
gulp = require 'gulp'
plugins = (require 'gulp-load-plugins')()
nib = require 'nib'
rupture = require 'rupture'
del = require 'del'
lost = require 'lost-grid'
typographic = require 'typographic'

stylusLibs = [
  typographic()
  lost()
  nib()
  rupture()
]

# build styles
gulp.task 'styles', ->
  gulp.src 'app/assets/styles/style.styl'
    .pipe plugins.plumber()
    .pipe plugins.sourcemaps.init()
    .pipe plugins.stylus(
      use: stylusLibs
      compress: true
    )
    .pipe plugins.rename('style.min.css')
    .pipe plugins.sourcemaps.write()
    .pipe gulp.dest('dist')
    .pipe plugins.size(title: 'styles')

gulp.task 'images', ->
  gulp.src('app/assets/images/**.*')
    .pipe plugins.imagemin({
      progressive: true
    })
    .pipe gulp.dest('dist/images')
    .pipe plugins.size(title: 'images')

gulp.task 'serve', ->
  gulp.src 'dist'
    .pipe plugins.webserver
      livereload: true
      open: true

gulp.task 'content', ->
  gulp.src 'views/**/*.jade'
    .pipe plugins.jade(config.locals)
    .pipe gulp.dest('dist')

gulp.task 'watch', ->
  gulp.watch 'app/assets/styles/**/*.styl', ['styles']
  gulp.watch 'app/assets/scripts/**/*.coffee', ['scripts']

  gulp.watch('dist/**/*.css').on 'change', plugins.livereload.changed
  gulp.watch('dist/**/*.js').on 'change', plugins.livereload.changed
  gulp.watch('app/views/**/*').on 'change', plugins.livereload.changed

gulp.task 'assets', ['styles', 'images']

gulp.task 'build', ['assets', 'content']

gulp.task 'develop', ['serve', 'watch']

gulp.task 'default', ['build', 'serve', 'watch']
