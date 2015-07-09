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
                files: ['assets/**/*.js', 'spec/**/*.js', 'index.jade', 'src/**/*.scss'],
                tasks: ['jade', 'sass', 'jshint', 'jslint', 'jasmine'],
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
        },
        jade: {
            compile: {
                files: {
                    'index.html': 'index.jade'
                }
            }
        },
        sass: {
            compile: {
                files: {
                    'dist/assets/css/main.css': 'src/client/main.scss'
                },
                options: {
                    loadPath: ['node_modules/bootstrap-sass/assets/stylesheets'],
                    style: 'compressed',
                    compass: true
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-jasmine');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-jslint');
};
