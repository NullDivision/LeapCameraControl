module.exports = function (grunt) {
    'use strict';

    grunt.initConfig({
        jshint: {
            options: {
                reporter: require('jshint-stylish')
            },
            all: ['Gruntfile.js', 'assets/js/**/*.js']
        },
        jslint: {
            builder: {
                src: ['Gruntfile.js'],
                directives: {
                    predef: ['module', 'require']
                }
            },
            all: {
                src: ['assets/js/**/*.js'],
                directives: {
                    browser: true,
                    plusplus: true,
                    devel: true,
                    predef: ['define', 'require']
                }
            }
        },
        watch: {
            scripts: {
                files: ['assets/**/*.js', 'spec/**/*.js'],
                tasks: ['jshint', 'jslint', 'jasmine'],
                options: {
                    spawn: false
                }
            }
        },
        jasmine: {
            tests: {
                src: 'assets/js/**/*.js',
                options: {
                    specs: 'spec/*Spec.js'
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jasmine');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-jslint');
};
