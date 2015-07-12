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
            tests: {
                files: ['src/client/**/*.js', 'spec/**/*.js'],
                tasks: ['jshint', 'jslint', 'jasmine']
            },
            scripts: {
                files: ['src/client/**/*.js', 'assets/**/*.js', 'index.js'],
                tasks: ['jshint', 'jslint', 'uglify']
            },
            styles: {
                files: ['src/**/*.scss'],
                tasks: ['sass']
            },
            views: {
                files: ['index.jade'],
                tasks: ['jade']
            }
        },
        jasmine: {
            tests: {
                src: 'assets/js/**/*.js, src/client/**/*.js',
                options: {
                    specs: 'spec/*Spec.js',
                    template: require('grunt-template-jasmine-requirejs'),
                    templateOptions: {
                        requireConfig: {
                            baseUrl: 'dist/assets/js'
                        }
                    }
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
                    'dist/assets/css/main.css': 'src/client/main.scss',
                    'dist/assets/css/registry.css': 'src/client/registry.scss'
                },
                options: {
                    loadPath: ['node_modules/bootstrap-sass/assets/stylesheets'],
                    style: 'compressed',
                    compass: true
                }
            }
        },
        uglify: {
            vendors: {
                files: {
                    'dist/assets/js/vendor/require.js': 'node_modules/requirejs/require.js'
                }
            },
            scripts: {
                files: grunt.file.expandMapping('src/client/**/*.js', 'dist/assets/js/', {flatten: true})
            }
        },
        lodash: {
            build: {
                dest: 'dist/assets/js/vendor/lodash.js',
                options: {
                    modifier: 'modern',
                    exports: ['amd'],
                    include: ['isEmpty', 'has', 'includes']
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-jasmine');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-jslint');
    grunt.loadNpmTasks('grunt-lodash');
    grunt.loadNpmTasks('grunt-notify');

    grunt.registerTask('default', ['jade', 'sass', 'lodash', 'uglify']);
};
