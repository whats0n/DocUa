module.exports = {

  html: {
    jadeList: [
        // './src/templates/pages/cabinet/clinic/personal.jade',
        // './src/_jade/**/*.jade',
        // '!./src/_jade/**/_*.jade',
        './src/templates/pages/**/*.jade',
        // './src/templates/layouts/main.jade',
        // './src/templates/pages/services.jade',
        // './src/templates/pages/pages.jade',
        // './src/templates/pages/503/503.jade',
        // './src/templates/pages/partners.jade'
        // '!./src/templates/pages/modals.jade'
    ],
    htmlList: [
        './src/templates/pages/**/*.html',
    ],
    layoutsList: [
        './src/templates/layouts/*.jade',
    ]
  },

  css: {
    stylusList: [
        './src/stylus/1_doc.styl',
        './src/stylus/partners-branding/index.styl',
        './src/templates/blocks/**/*.styl',
        // '!./src/templates/blocks/cabinet/cabinet.styl',
        // '!./src/templates/blocks/doctor-profile/doctor-profile.styl',
        // '!./src/templates/blocks/issue/issue.styl',
        // '!./src/templates/blocks/profile/profile.styl',
        // '!./src/templates/blocks/requests-item/requests-item.styl',
        // '!./src/templates/blocks/statistics-timeline/statistics-timeline.styl',
        // '!./src/templates/blocks/user-list/user-list.styl'
    ],
    lessList: [
        './src/assets/vendor/twitter-bootstrap/less/bootstrap.less'
    ],
    cssList: [
        //'./src/assets/css/fonts/fonts.css',
        './src/assets/css/_less.css',
        './src/assets/vendor/owl-carousel/owl.carousel.css',
        './src/assets/vendor/select2/select2.css',
        './src/assets/vendor/pickadate/themes/classic.css',
        './src/assets/vendor/pickadate/themes/classic.date.css',
        './src/assets/vendor/pickadate/themes/classic.time.css',
        './src/assets/vendor/jscrollpane/jquery.jscrollpane.css',
        './src/assets/css/_stylus.css',
        './src/assets/vendor/popups/main.css', 
        './src/assets/vendor/popups/media-queries.css', 
    ],
    partnersCssList: [
        './src/assets/css/partners-branding/*.css',
    ]
  },

  css_cabinet: {
    stylusList: [
        './src/stylus/cabinet.styl',
        './src/templates/blocks/cabinet/cabinet.styl',
        './src/templates/blocks/doctor-profile/doctor-profile.styl',
        './src/templates/blocks/profile/profile.styl',
        './src/templates/blocks/issue/issue.styl',
        './src/templates/blocks/requests-item/requests-item.styl',
        './src/templates/blocks/statistics-timeline/statistics-timeline.styl',
        './src/templates/blocks/user-list/user-list.styl'
    ],
    lessList: [
        './src/assets/vendor/twitter-bootstrap/less/cabinet.less'
    ],
    cssList: [
        './src/assets/css/_stylus_cabinet.css',
        './src/assets/css/_less_cabinet.css'
    ],
  },

  js: {
    jsList: [
        "./src/assets/vendor/jquery/jquery-1.12.0.min.js",
        "./src/assets/vendor/jqueryui/jquery-ui.min.js",
        "./src/assets/vendor/owl-carousel/owl.carousel.js",
        "./src/assets/vendor/twitter-bootstrap/js/tab.js",
        "./src/assets/vendor/twitter-bootstrap/js/dropdown.js",
        "./src/assets/vendor/twitter-bootstrap/js/tooltip.js",
        "./src/assets/vendor/twitter-bootstrap/js/transition.js",
        "./src/assets/vendor/twitter-bootstrap/js/modal.js",
        "./src/assets/vendor/twitter-bootstrap/js/collapse.js",
        "./src/assets/vendor/twitter-bootstrap/js/scrollspy.js",
        "./src/assets/vendor/select2/select2.js",
        "./src/assets/vendor/select2/select2_locale_ru.js",
        "./src/assets/vendor/select2/select2_locale_uk.js",
        "./src/assets/vendor/pickadate/picker.js",
        "./src/assets/vendor/pickadate/picker.date.js",
        "./src/assets/vendor/pickadate/picker.time.js",
        "./src/assets/vendor/jscrollpane/jquery.mousewheel.js",
        "./src/assets/vendor/jscrollpane/mwheelIntent.js",
        "./src/assets/vendor/jscrollpane/jquery.jscrollpane.js",
        "./src/assets/vendor/jquery.inputmask/inputmask/jquery.inputmask.js",
        "./src/assets/vendor/moment/moment.js",
        "./src/assets/vendor/daterangepicker/daterangepicker.js",
        "./src/assets/vendor/dotdotdot/jquery.dotdotdot.min.js",
        // './src/assets/vendor/popups/main.js',
        './src/assets/vendor/popups/plugins.js',
        "./src/assets/js/_coffee.js"
    ],
    checkerList: [
        "./src/assets/vendor/raphael/raphael.min.js",
        "./src/assets/js/SVG_FILES.js"
    ],
    coffeList: [
        './src/coffee/jquery-panElement.coffee',
        './src/coffee/jquery-columnagram.coffee',
        './src/coffee/jquery-owlbox.coffee',
        './src/coffee/jquery-badyl.coffee',
        './src/coffee/jquery-select7.coffee',
        './src/coffee/jquery-srcset.coffee',
        './src/coffee/jquery.scrollTo.coffee',
        './src/coffee/wait-for-web-fonts.coffee',
        './src/templates/blocks/**/*.coffee',
        './src/coffee/doc-markup.coffee',
        './src/coffee/maps.coffee'
    ]
  }

}
