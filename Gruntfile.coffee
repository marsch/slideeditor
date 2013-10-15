'use strict'

lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet
mountFolder = (connect, dir) ->
  return connect.static(require('path').resolve(dir));

module.exports = (grunt) ->
  _ = grunt.util._
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
  pkg = require './package.json'
  coffelintoptions = require './coffeelint.json'

  SRC_DIR = 'src'
  OUT_DIR = 'build'
  BOWER_DIRECTORY = SRC_DIR

  grunt.initConfig

    watch:
      livereload:
        files: [
          SRC_DIR + '/**/*.{mustache,html,css,less,js,coffee,png,jpg,jpeg,gif,webp}'
          '!' + SRC_DIR + '/**/main.css'
        ]
        tasks: ['less', 'livereload']

    connect:
      options:
        port: 9001
        hostname: 'localhost'

      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, '../')]

      production:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, OUT_DIR + '/')]

    open:
      server:
        path: 'http://localhost:<%= connect.options.port %>/slideeditor/src'

    clean:
      bower: 'components'

    bower:
      install:
        options:
          targetDir: BOWER_DIRECTORY
          verbose: true
          cleanup: false
          install: true

    copy:
      production:
        files: [
          {
            cwd: SRC_DIR + '/images'
            dest: OUT_DIR + '/images'
            expand: true
            src: [
              '**/*.{png,gif,jpg}'
            ]
          }
          {
            cwd: SRC_DIR
            dest: OUT_DIR
            expand: true
            src: [
              'index.build.html'
            ]
            rename: (dest) ->
              dest + '/index.html'
          }
          {
            cwd: SRC_DIR + '/css'
            dest: OUT_DIR + '/css'
            expand: true
            src: [
              '**/*.css'
            ]
          }
          {
            cwd: SRC_DIR + '/font'
            dest: OUT_DIR + '/font'
            expand: true
            src: [
              '**/*.*'
            ]
          }
        ]


    less:
      production:
        options:
          paths: ['src/css/']
          syncImport: true
          compress: true
        files: {
          'build/css/main.css': 'src/css/main.less'
        }
      development:
        options:
          paths: ['src/css/']
          syncImport: true
          compress: true
        files: {
          'src/css/main.css': 'src/css/main.less'
        }


    requirejs:
      production:
        options:
          name: 'main.build'
          out: OUT_DIR + '/js/main.min.js'
          mainConfigFile: SRC_DIR + '/js/main.build.js'
          baseUrl: './' + SRC_DIR + '/js'
          keepBuildDir: true
          almond: true
          insertRequire: ['main.build']
          optimize: 'uglify2'


    mocha:
      all:
       src: [SRC_DIR + '/test/**/*TestRunner.html']
       options:
         mocha:
           ignoreLeaks: true
         reporter: 'Spec'
         run: true

    coffeelint:
      src:
        files:
          src: [SRC_DIR + '/**/*.coffee']
        options: coffelintoptions

  grunt.renameTask('regarde', 'watch')

  grunt.registerTask 'server', (target) ->
    grunt.task.run [
      'less'
      'livereload-start'
      'connect:livereload'
      'open:server'
      'watch:livereload'
    ]

  grunt.registerTask 'productionserver', (target) ->
    grunt.task.run [
      'livereload-start'
      'connect:production'
      'open:server'
      'watch:livereload'
    ]

  grunt.registerTask 'prepare', [
    'bower:install'
    'clean'
  ]

  # TODO: need to copy images and html and other assets to OUT_DIR
  grunt.registerTask 'build', [
    'lint'
    'requirejs:production'
    'less'
    'copy:production'
  ]

  grunt.registerTask 'all', [
    'prepare'
    'build'
    'server'
  ]

  grunt.registerTask 'allproduction', [
    'prepare'
    'build'
    'productionserver'
  ]

  grunt.registerTask 'test', [
    'lint'
    'mocha:all'
  ]

  grunt.registerTask 'lint', [
    'coffeelint:src'
  ]
