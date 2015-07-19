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
                    predef: ['module', 'require', 'console']
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
                files: ['spec/**/*.js'],
                tasks: ['jshint', 'jslint', 'jasmine']
            },
            scripts: {
                files: ['src/client/**/*.js', 'assets/**/*.js', 'index.js'],
                tasks: ['jshint', 'jslint', 'uglify:scripts', 'jasmine']
            },
            legacy: {
                files: ['assets/**/*.js'],
                tasks: ['jshint', 'jslint', 'jasmine']
            },
            entry: {
                files: ['index.js'],
                tasks: ['jshint', 'jslint']
            },
            styles: {
                files: ['src/**/*.scss'],
                tasks: ['sass']
            },
            jsx: {
                files: ['src/client/ComponentProvider.jsx'],
                tasks: ['react']
            },
            jsxDist: {
                files: ['dist/assets/js/ComponentProvider.js'],
                tasks: ['jshint', 'jslint', 'uglify:jsx', 'jasmine']
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
                            baseUrl: 'dist/assets/js',
                            paths: {
                                React: 'https://fbcdn-dragon-a.akamaihd.net/hphotos-ak-xap1/t39.3284-6/' +
                                       '11057094_1387833628212425_492117912_n'
                            }
                        }
                    }
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
            options: {sourceMap: true, sourceMapIncludeSources: true},
            vendors: {files: {'dist/assets/js/vendor/require.js': 'node_modules/requirejs/require.js'}},
            scripts: {files: grunt.file.expandMapping('src/client/**/*.js', 'dist/assets/js/', {flatten: true})},
            jsx:     {files: {'dist/assets/js/ComponentProvider.js': 'dist/assets/js/ComponentProvider.js'}}
        },
        lodash: {
            build: {
                dest: 'dist/assets/js/vendor/lodash.js',
                options: {
                    modifier: 'modern',
                    exports: ['amd'],
                    include: ['isEmpty', 'has', 'includes', 'assign', 'forEach', 'map']
                }
            }
        },
        react: {
            build: { files: { 'dist/assets/js/ComponentProvider.js': 'src/client/ComponentProvider.jsx' } }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jasmine');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-jslint');
    grunt.loadNpmTasks('grunt-lodash');
    grunt.loadNpmTasks('grunt-notify');
    grunt.loadNpmTasks('grunt-react');

    grunt.registerTask('default', ['sass', 'react', 'lodash', 'uglify']);
};
