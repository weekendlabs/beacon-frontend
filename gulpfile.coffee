gulp = require 'gulp'
browserify = require 'browserify'
watchify = require 'watchify'
coffeeReactify = require 'coffee-reactify'
source = require 'vinyl-source-stream'
rimraf = require 'rimraf'
less = require 'gulp-less'
LessPluginAutoPrefix = require 'less-plugin-autoprefix'
autoPrefixCSS = new LessPluginAutoPrefix {browsers: ['last 2 versions']}
rename = require 'gulp-rename'
streamify = require 'gulp-streamify'
connect = require 'gulp-connect'

argv = require("minimist")(process.argv.slice(2))

targetDirectory = -> './public'

errorHandler = (error) ->
  console.error error.toString()
  @emit 'end' # End the stream

# Copy index.html from app/index.html to pubilc/html
gulp.task('html', ->
  gulp
    .src './app/index.html'
    .pipe gulp.dest targetDirectory()
    .pipe connect.reload()
)

gulp.task('browserify', ->
  options =
    extensions: ['.coffee', '.cjsx']
    debug: true
    cache: {}
    packageCache: {}
    fullPaths: true

  bundler = browserify options
  bundler = watchify bundler
  bundler
    .add './app/app.cjsx'
    .transform coffeeReactify, {global: true}

  makeBundle = ->
    console.log 'Running Browserify...'
    bundler
      .bundle()
      .on 'error', errorHandler
      .pipe source (argv.outname or 'app.js') # Convert from browserify stream to gulp stream
      .pipe gulp.dest (argv.outdir or targetDirectory() + '/js')
      .pipe connect.reload()

  bundler.on 'update', makeBundle
  makeBundle()
)

gulp.task('less', ->
  gulp
    .src './app/less/app.less'
    .pipe less {plugins: [autoPrefixCSS]}
    .on 'error', errorHandler
    .pipe rename 'app.css'
    .pipe gulp.dest targetDirectory() + '/css'
    .pipe connect.reload()
)

gulp.task('vendor', ->
  gulp
    .src './app/vendor/**'
    .pipe gulp.dest targetDirectory() + '/vendor'
)

gulp.task('images', ->
  gulp
    .src './app/images/**'
    .pipe gulp.dest targetDirectory() + '/images'
)

gulp.task('serve', ->
  connect.server(
    root: "#{__dirname}/#{targetDirectory()}"
    port: if argv.port? then argv.port else 8080
    livereload: true
  )
)

gulp.task('watch', ->
  gulp.watch './app/index.html', ['build']
  gulp.watch './app/**/*.less', ['less']
)

gulp.task('clean', (done) ->
  rimraf './build', (-> rimraf './public', done)
)

gulp.task('assets', ['html', 'browserify', 'less', 'vendor', 'images'])

gulp.task('prod', -> PROD_MODE = true)
gulp.task('dev', -> PROD_MODE = false)

gulp.task('build', ['assets'])

# development mode is the default
gulp.task('default', ['build', 'watch'])
