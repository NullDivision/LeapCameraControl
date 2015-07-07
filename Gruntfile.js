module.exports = function (grunt) {
    'use strict';

    grunt.initConfig({
        jshint: {
            options: {
                reporter: require('jshint-stylish')
            },
            all: ['Gruntfile.js', 'assets/js/**/*.js']
        },
        watch: {
            scripts: {
                files: ['assets/**/*.js'],
                tasks: ['jshint'],
                options: {
                    spawn: false
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
};
