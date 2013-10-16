
require.config({
    baseUrl: './js',
    urlArgs: "bust=" + (new Date()).getTime(),
    paths: {
        sanitize: 'lib/html-sanitizer',
        depend: 'lib/require-depend',
        text: 'vendor/requirehogan/text',
        hgn: 'vendor/requirehogan/hgn',
        cs: 'vendor/requirecs/cs',
        css: 'vendor/requirecss/css',
        less: 'vendor/requireless/less',
        lessc: 'vendor/requireless/lessc',
        'lessc-server': 'vendor/requireless/lessc-server',
        'less-builder': 'vendor/requireless/less-builder',
        'css/css-builder': 'vendor/requirecss/css-builder',
        'css/normalize': 'vendor/requirecss/normalize',
        normalize: 'vendor/requirecss/normalize',
        'coffee-script': 'vendor/requirecs/coffee-script',
        hogan: 'vendor/requirehogan/hogan',
        mustache: 'vendor/mustache/mustache',
        chaplin: 'vendor/chaplin/chaplin',
        moment: 'vendor/moment/moment',
        underscore: 'vendor/underscore/underscore',
        jquery: 'vendor/jquery/jquery',
        'jquery-ui': 'vendor/jquery-ui/jquery-ui',
        backbone: 'vendor/backbone/backbone',
        loglevel: 'vendor/loglevel/loglevel',
        'keymaster': 'vendor/keymaster/keymaster.min',

        // jquery plugins
        'bootstrap.collapse': 'vendor/bootstrap/bootstrap-collapse',

        // have a customized dropdown file here
        'bootstrap.dropdown': 'vendor/bootstrap/bootstrap-dropdown',
        'bootstrap.modal': 'vendor/bootstrap/bootstrap-modal',
        'bootstrap.tooltip': 'vendor/bootstrap/bootstrap-tooltip',
        'bootstrap.button': 'vendor/bootstrap/bootstrap-button',
        'bootstrap.switch': 'vendor/bootstrap-switch/bootstrap-switch',

        // backbone plugins
        'backbone.localstorage': 'vendor/backbone.localstorage/backbone.localStorage',
        'backbone.stickit': 'vendor/backbone.stickit/backbone.stickit',
        'backbone.relational': 'vendor/backbone.relational/backbone-relational',
        'backbone.gocourse.sync': 'lib/backbone.gocourse.sync',

        'redactor': 'vendor/redactor/redactor',
        'redactorcss': '../css/vendor/redactor/redactor',
        'redactor-fontsize': 'lib/redactor-fontsize',

        'html2canvas': 'vendor/html2canvas/index',
        'jquery-minicolors': 'vendor/jquery-minicolors/jquery.minicolors',

        'thumbnailer': 'lib/thumbnailer'

    },
    shim: {
        mustache: {
            exports: 'Mustache'
        },
        jquery: {
            exports: '$'
        },
        'jquery-ui': {
            deps: ['jquery']
        },
        underscore: {
            exports: '_'
        },
        keymaster: {
            exports: 'key'
        },
        'bootstrap.collapse': {
            deps: ['jquery']
        },
        'bootstrap.dropdown': {
            deps: ['jquery']
        },
        'bootstrap.tooltip': {
            deps: ['jquery']
        },
        'bootstrap.button': {
            deps: ['jquery']
        },
        'bootstrap.modal': {
            deps: ['jquery']
        },
        'bootstrap.switch': {
            deps: ['jquery']
        },
        'html2canvas': {
            deps: ['jquery'],
            exports: 'html2canvas'
        },
        'jquery-minicolors': {
            deps: ['jquery']
        },
        'thumbnailer': {
            exports: 'thumbnailer'
        }
    }
});

require([
    'cs!editor/editor.coffee',
    'jquery',
    'loglevel',
    'jquery-ui',
    'bootstrap.dropdown',
    'bootstrap.modal'

    ], function (Editor, $, log) {
  'use strict';


  try {
    // use 'silent' to supress log messages
    // never use console.log directly PLZ
    log.setLevel('trace');
  } catch (e) {
    // no console.log available
  }

  window.editor = new Editor()

});
