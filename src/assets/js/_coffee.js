$.fn.panElement = function(arg) {
  if (arg === "destroy") {
    return $(this).data("panElement", false).off("mousedown");
  }
  this.each(function() {
    var $el;
    $el = $(this);
    if ($el.data("panElement")) {
      return;
    }
    $el.data("panElement", true);
    return $el.on("mousedown", function(downEvent) {
      var minLeft, minTop, moveHandler, startLeft, startTop, startX, startY;
      startX = downEvent.pageX;
      startY = downEvent.pageY;
      startTop = parseFloat($el.css("top").replace("px", ""));
      startLeft = parseFloat($el.css("left").replace("px", ""));
      minTop = $el.parent().height() - $el.height();
      minLeft = $el.parent().width() - $el.width();
      downEvent.preventDefault();
      downEvent.stopPropagation();
      $el.css({
        cursor: "move"
      });
      $("body").on("mousemove", moveHandler = function(moveEvent) {
        var deltaX, deltaY;
        deltaX = moveEvent.pageX - startX;
        deltaY = moveEvent.pageY - startY;
        $el.css({
          top: (Math.min(0, Math.max(minTop, startTop + deltaY))) + "px",
          left: (Math.min(0, Math.max(minLeft, startLeft + deltaX))) + "px"
        });
        moveEvent.preventDefault();
        return moveEvent.stopPropagation();
      });
      return $("body").one("mouseup", function() {
        $("body").off("mousemove", moveHandler);
        return $el.css({
          cursor: ""
        });
      });
    });
  });
  return this;
};


/*
@name jquery-columnagram
@description Reinvent the columnizer.
@version 1.2.14
@author Se7enSky studio <info@se7ensky.com>
 */

/*! jquery-columnagram 1.2.14 http://github.com/Se7enSky/jquery-columnagram */
var plugin,
  slice = [].slice;

plugin = function($) {
  "use strict";
  var Columnagram;
  Columnagram = (function() {
    Columnagram.prototype.defaults = {
      columns: 'auto',
      balanceMethod: 'optimal',
      minWeightRepeats: 100,
      minColumnWidth: false
    };

    function Columnagram(el1, config) {
      this.el = el1;
      this.$el = $(this.el);
      this.config = $.extend({}, this.defaults, config);
      this.columnized = false;
      this.columnize();
    }

    Columnagram.prototype.destroy = function() {
      return this.decolumnize();
    };

    Columnagram.prototype.calculateWeights = function(chunks, weights) {
      var chunk, chunkWeight, i, j, k, l, len, ref, ref1, results;
      i = 0;
      results = [];
      for (k = 0, len = chunks.length; k < len; k++) {
        chunk = chunks[k];
        chunkWeight = 0;
        for (j = l = ref = i, ref1 = i + chunk.length - 1; ref <= ref1 ? l <= ref1 : l >= ref1; j = ref <= ref1 ? ++l : --l) {
          chunkWeight += weights[j];
        }
        i += chunk.length;
        results.push(chunkWeight || 0);
      }
      return results;
    };

    Columnagram.prototype.balanceItemsIntoChunksByCount = function(items, chunkCount) {
      var chunkIndex, k, perChunk, ref, result;
      result = [];
      perChunk = Math.ceil(items.length / chunkCount);
      for (chunkIndex = k = 0, ref = chunkCount - 1; 0 <= ref ? k <= ref : k >= ref; chunkIndex = 0 <= ref ? ++k : --k) {
        result.push(items.slice(chunkIndex * perChunk, (chunkIndex + 1) * perChunk));
      }
      return result;
    };

    Columnagram.prototype.balanceItemsIntoChunksByWeight = function(items, weights, chunkCount) {
      var chunkWeights, chunks, maxWeight, maxWeightChunkIndex, minWeight, minWeightRepeats;
      if (chunkCount === 1) {
        return items;
      }
      chunks = this.balanceItemsIntoChunksByCount(items, chunkCount);
      if (items.length === chunkCount) {
        return chunks;
      }
      minWeight = 10000000;
      minWeightRepeats = 0;
      while (true) {
        chunkWeights = this.calculateWeights(chunks, weights);
        maxWeight = Math.max.apply(Math, chunkWeights);
        maxWeightChunkIndex = chunkWeights.indexOf(maxWeight);
        if (maxWeightChunkIndex === -1) {
          return chunks;
        }
        if (maxWeight < minWeight) {
          minWeight = maxWeight;
          minWeightRepeats = 0;
        } else if (maxWeight === minWeight) {
          minWeightRepeats++;
          if (minWeightRepeats === this.config.minWeightRepeats) {
            return chunks;
          }
        }
        if (maxWeightChunkIndex === 0) {
          if (chunks[maxWeightChunkIndex].length > 1) {
            chunks[maxWeightChunkIndex + 1].unshift(chunks[maxWeightChunkIndex].pop());
          }
        } else if (maxWeightChunkIndex === chunkWeights.length - 1) {
          if (chunks[maxWeightChunkIndex].length > 1) {
            chunks[maxWeightChunkIndex - 1].push(chunks[maxWeightChunkIndex].shift());
          }
        } else {
          if (chunks[maxWeightChunkIndex].length > 1 && Math.random() > 0.3) {
            chunks[maxWeightChunkIndex + 1].unshift(chunks[maxWeightChunkIndex].pop());
          }
          if (chunks[maxWeightChunkIndex].length > 1 && Math.random() > 0.3) {
            chunks[maxWeightChunkIndex - 1].push(chunks[maxWeightChunkIndex].shift());
          }
        }
      }
      return chunks;
    };

    Columnagram.prototype.balanceItemsIntoChunksOptimal = function(items, weights, chunkCount) {
      var chunk, chunkWeight, chunkWeights, chunks, i, maxWeight;
      if (chunkCount === 1) {
        return items;
      }
      chunks = this.balanceItemsIntoChunksByWeight(items, weights, chunkCount);
      chunkWeights = this.calculateWeights(chunks, weights);
      maxWeight = Math.max.apply(Math, chunkWeights);
      chunks = [];
      chunk = [];
      chunkWeight = 0;
      i = 0;
      while (items.length > 0) {
        if (weights[i] + chunkWeight <= maxWeight) {
          chunk.push(items.shift());
          chunkWeight += weights[i];
          i++;
        } else {
          chunks.push(chunk);
          chunk = [];
          chunkWeight = 0;
        }
      }
      chunks.push(chunk);
      return chunks;
    };

    Columnagram.prototype.columnize = function() {
      var child, children, chunk, chunks, columnCount, cssHeight, heights, heightsAreSame, i, k, maxRepeats, newHeights, ref, ref1, repeats;
      cssHeight = function(el) {
        var cssValue;
        cssValue = function(name) {
          return parseFloat($(el).css(name).replace("px", ""));
        };
        return cssValue("height") + cssValue("margin-bottom") + cssValue("margin-top") + cssValue("border-top-width") + cssValue("border-bottom-width");
      };
      if (this.columnized) {
        return;
      }
      if (((ref = this.config.balanceMethod) === "balanceHeight" || ref === "optimal") && this.$el.innerHeight() === 0) {
        return;
      }
      columnCount = this.config.columns;
      if (this.config.minColumnWidth) {
        while (columnCount > 1 && this.$el.width() / columnCount < this.config.minColumnWidth) {
          columnCount -= 1;
        }
      }
      if (this.config.limitColumnCount) {
        columnCount = this.config.limitColumnCount(columnCount);
      }
      if (columnCount <= 1) {
        return;
      }
      children = this.$el.children().toArray();
      heightsAreSame = false;
      heights = (function() {
        var k, len, results;
        results = [];
        for (k = 0, len = children.length; k < len; k++) {
          child = children[k];
          results.push(cssHeight(child));
        }
        return results;
      })();
      maxRepeats = 4;
      repeats = 0;
      while (!heightsAreSame) {
        repeats++;
        chunks = (function() {
          switch (this.config.balanceMethod) {
            case "balanceHeight":
              return this.balanceItemsIntoChunksByWeight(children, heights, columnCount);
            case "balanceCount":
              return this.balanceItemsIntoChunksByCount(children, columnCount);
            case "optimal":
              return this.balanceItemsIntoChunksOptimal(children, heights, columnCount);
          }
        }).call(this);
        this.$el.empty().append((function() {
          var k, len, results;
          results = [];
          for (k = 0, len = chunks.length; k < len; k++) {
            chunk = chunks[k];
            results.push($("<div>").css({
              float: "left",
              width: (Math.floor(100 / chunks.length)) + "%"
            }).append(chunk));
          }
          return results;
        })());
        newHeights = (function() {
          var k, len, ref1, results;
          ref1 = this.$el.find("> div > *");
          results = [];
          for (k = 0, len = ref1.length; k < len; k++) {
            child = ref1[k];
            results.push(cssHeight(child));
          }
          return results;
        }).call(this);
        heightsAreSame = true;
        for (i = k = 0, ref1 = heights.length; 0 <= ref1 ? k <= ref1 : k >= ref1; i = 0 <= ref1 ? ++k : --k) {
          if (heights[i] !== newHeights[i]) {
            heightsAreSame = false;
            break;
          }
        }
        if (repeats > maxRepeats) {
          break;
        }
        if (!heightsAreSame) {
          heights = newHeights;
          children = this.$el.find("> div > *").toArray();
          this.$el.find("> div").remove();
        }
      }
      this.$el.trigger("columnagram.columnized", {
        columns: chunks.length
      });
      return this.columnized = true;
    };

    Columnagram.prototype.decolumnize = function() {
      var $children;
      if (!this.columnized) {
        return;
      }
      $children = this.$el.find("> div").children();
      this.$el.find("> div").remove();
      this.$el.append($children);
      return this.columnized = false;
    };

    Columnagram.prototype.recolumnize = function() {
      this.decolumnize();
      return this.columnize();
    };

    return Columnagram;

  })();
  return $.fn.columnagram = function() {
    var args, method;
    method = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    return this.each(function() {
      var columnagram;
      columnagram = $(this).data('columnagram');
      if (!columnagram) {
        columnagram = new Columnagram(this, typeof method === 'object' ? method : {});
        $(this).data('columnagram', columnagram);
      }
      if (typeof method === 'string') {
        return columnagram[method].apply(columnagram, args);
      }
    });
  };
};

if (typeof define === 'function' && define.amd) {
  define(['jquery'], plugin);
} else {
  plugin(jQuery);
}


/*
@name jquery-owlbox
@description Lightbox-like gallery for galleries, based on owlCarousel and Bootstrap 3 modals.
@version 1.0.0
@author Se7enSky studio <info@se7ensky.com>
@dependencies
 - [owlCarousel](http://owlgraphic.com/owlcarousel/)
 - [Bootstrap 3 modals](http://getbootstrap.com/javascript/#modals)
 */

/*! jquery-owlbox 1.0.0 http://github.com/Se7enSky/jquery-owlbox */
var plugin;

plugin = function($) {
  "use strict";
  return $.fn.owlbox = function() {
    return this.each(function() {
      return $(this).click(function(e) {
        var $img, $items, $popup, currentIndex, group, item, items, keysHandler;
        e.preventDefault();
        group = $(this).attr("rel");
        $items = group ? $("a[rel='" + group + "'][href]") : $(this);
        currentIndex = $items.index(this);
        items = (function() {
          var i, len, results;
          results = [];
          for (i = 0, len = $items.length; i < len; i++) {
            item = $items[i];
            $img = $(item).find("img");
            results.push({
              thumb: $(item).attr("data-thumb-src") || $img.attr("src") || $img.attr("data-src"),
              big: $(item).attr("href"),
              title: $(item).attr("title")
            });
          }
          return results;
        })();
        $popup = $("<div aria-hidden=\"true\" role=\"dialog\" class=\"gallery-popup sdfgdsf modal fade\" data-keyboard=\"true\" tabindex=\"-1\">\n \n	\n <div class=\"modal-dialog\">\n\n		 \n <div class=\"modal-content\">\n \n		 	\n <div class=\"modal-header\">\n \n		 		\n <button aria-hidden=\"true\" data-dismiss=\"modal\" type=\"button\" class=\"close close-special\"></button>\n \n <div class=\"modal-title\">Галерея</div></div>\n <div class=\"modal-body\">\n <div class=\"photo-gallery\"></div>\n\n		 	\n </div>\n\n		 \n </div>\n \n	\n </div>\n\n\n</div>");
        keysHandler = function(e) {
          switch (e.which) {
            case 37:
              $popup.find(".photo-gallery").trigger("photoGallery.prev");
              return e.preventDefault();
            case 39:
              $popup.find(".photo-gallery").trigger("photoGallery.next");
              return e.preventDefault();
          }
        };
        $("section.modals").append($popup);
        $popup.on("hidden.bs.modal", function() {
          $popup.remove();
          return $("body").off("keydown", keysHandler);
        });
        $popup.on("owl.afterInit", function(e, owl) {
          return owl.goTo(currentIndex);
        });
        $popup.on("shown.bs.modal", function() {
          return $popup.find(".photo-gallery").makeCustomPhotoGallery({
            items: items
          });
        });
        $popup.modal("show");
        return $("body").on("keydown", keysHandler);
      });
    });
  };
};

if (typeof define === 'function' && define.amd) {
  define(['jquery'], plugin);
} else {
  plugin(jQuery);
}


/*
@name jquery-badyl
@description Meet Badyl – bootstrap affix-like wheel reinvent.
@version 1.7.57
@author Se7enSky studio <info@se7ensky.com>
 */

/*! jquery-badyl 1.7.57 http://github.com/Se7enSky/jquery-badyl */
var plugin,
  slice = [].slice;

plugin = function($) {
  "use strict";
  var Badyl;
  Badyl = (function() {
    Badyl.prototype.defaults = {
      offset: 0
    };

    Badyl.prototype.cssSnippets = {
      top: {
        position: 'absolute',
        top: 0,
        bottom: ''
      },
      bottom: {
        position: 'absolute',
        top: '',
        bottom: 0
      },
      fixTop: {
        position: 'fixed',
        top: 0,
        bottom: ''
      },
      fixBottom: {
        position: 'fixed',
        top: '',
        bottom: 0
      },
      unstable: {
        position: 'absolute',
        top: '',
        bottom: ''
      }
    };

    function Badyl(el, config) {
      this.el = el;
      this.$el = $(this.el);
      this.$el.data("badyl", this);
      this.config = $.extend({}, this.defaults, config);
      this.state = null;
      this.badylized = false;
      this.$refEl = $(this.$el.attr("data-badyl-ref-el"));
      this.$originalParent = this.$el.parent();
      this.prevWindowScrollTop = 0;
      this.smartResizeTimeout = null;
      this.badylize();
    }

    Badyl.prototype.destroy = function() {
      return this.debadylize();
    };

    Badyl.prototype.badylize = function() {
      if (this.badylized) {
        return;
      }
      this.containerInnerWidth = this.measureInnerWidth(this.$originalParent);
      this.originalHeight = this.$el.height();
      this.badylInnerHeight = this.originalHeight + this.config.offset * 2;
      this.$refEl.css({
        height: ""
      });
      this.badylHeight = this.$refEl.height() + this.config.offset * 2;
      if (this.badylInnerHeight > this.badylHeight) {
        this.$refEl.css({
          height: this.badylInnerHeight + "px"
        });
        this.badylHeight = this.$refEl.height() + this.config.offset * 2;
      }
      this.$el.replaceWith(this.$badylContainer = $("<div>").css({
        position: 'relative',
        height: this.badylHeight + "px",
        margin: "-" + this.config.offset + "px 0"
      }).append(this.$badylInner = $("<div>").css({
        width: this.containerInnerWidth + "px",
        height: this.badylInnerHeight + "px",
        padding: this.config.offset + "px 0"
      }).append(this.$originalElement = this.$el.clone())));
      this.$originalElement.data("badyl", this);
      this.$badylContainer.data("badyl", this);
      this.badylOffsetTop = this.$badylContainer.offset().top;
      this.refreshInnerCss();
      this.bindEvents();
      this.badylized = true;
      return this.$originalElement.trigger("badylized");
    };

    Badyl.prototype.rebadylize = function() {
      if (!this.badylized) {
        return;
      }
      if (this.smartResizeTimeout) {
        clearTimeout(this.smartResizeTimeout);
      }
      this.containerInnerWidth = this.measureInnerWidth(this.$originalParent);
      this.rebadylizeFromState = this.state;
      this.badylized = false;
      this.state = null;
      this.$refEl.css({
        height: ""
      });
      this.badylHeight = this.$refEl.height() + this.config.offset * 2;
      this.$badylInner.css({
        width: this.containerInnerWidth + "px",
        padding: this.config.offset + "px 0"
      });
      this.originalHeight = this.$originalElement.height();
      this.badylInnerHeight = this.originalHeight + this.config.offset * 2;
      if (this.badylInnerHeight > this.badylHeight) {
        this.$refEl.css({
          height: this.badylInnerHeight + "px"
        });
        this.badylHeight = this.$refEl.height() + this.config.offset * 2;
      }
      this.$badylContainer.css({
        position: 'relative',
        height: this.badylHeight + "px",
        margin: "-" + this.config.offset + "px 0"
      });
      this.$badylInner.css({
        height: this.badylInnerHeight + "px"
      });
      this.badylOffsetTop = this.$badylContainer.offset().top;
      this.refreshInnerCss();
      this.badylized = true;
      return this.$originalElement.trigger("rebadylized");
    };

    Badyl.prototype.debadylize = function() {
      if (!this.badylized) {
        return;
      }
      if (this.smartResizeTimeout) {
        clearTimeout(this.smartResizeTimeout);
      }
      this.unbindEvents();
      this.$badylContainer.replaceWith(this.$el = this.$originalElement);
      this.$el.data("badyl", this);
      this.badylized = false;
      this.state = null;
      return this.$el.trigger("debadylized");
    };

    Badyl.prototype.bindEvents = function() {
      $(window).on("scroll", this.windowScrollHandler = (function(_this) {
        return function(e) {
          return _this.refreshInnerCss();
        };
      })(this));
      return $(window).on("resize", this.windowResizeHandler = (function(_this) {
        return function(e) {
          if (_this.smartResizeTimeout) {
            clearTimeout(_this.smartResizeTimeout);
          }
          return _this.smartResizeTimeout = setTimeout(function() {
            if (_this.badylized) {
              _this.rebadylize();
            }
            return _this.smartResizeTimeout = null;
          }, 100);
        };
      })(this));
    };

    Badyl.prototype.unbindEvents = function() {
      $(window).off("scroll", this.windowScrollHandler);
      return $(window).off("resize", this.windowResizeHandler);
    };

    Badyl.prototype.refreshInnerCss = function() {
      var containerHeight, ref, scrollingBottom, scrollingTop, windowHeight, windowScrollTop;
      windowScrollTop = $(window).scrollTop();
      windowHeight = $(window).height();
      containerHeight = this.$badylContainer.height();
      scrollingBottom = windowScrollTop > this.prevWindowScrollTop;
      scrollingTop = !scrollingBottom;
      if (this.badylInnerHeight > windowHeight) {
        switch (this.state) {
          case null:
            if (windowScrollTop >= this.badylOffsetTop + this.badylHeight - this.badylInnerHeight) {
              this.switchState("bottom");
            } else if (windowScrollTop < this.badylOffsetTop) {
              this.switchState("top");
            } else if ((ref = this.rebadylizeFromState) === "fixTop" || ref === "fixBottom") {
              this.switchState(this.rebadylizeFromState);
            } else if (this.rebadylizeFromState === "unstable") {
              this.switchState("unstable", {
                top: this.unstableTop + "px"
              });
            }
            break;
          case "top":
            if (windowScrollTop >= this.badylOffsetTop + this.badylInnerHeight - windowHeight) {
              this.switchState("fixBottom");
            }
            break;
          case "bottom":
            if (windowScrollTop < this.badylOffsetTop + this.badylHeight - this.badylInnerHeight) {
              this.switchState("fixTop");
            }
            break;
          case "fixBottom":
            if (windowScrollTop + windowHeight < this.badylOffsetTop + this.badylInnerHeight) {
              this.switchState("top");
            } else if (windowScrollTop + windowHeight >= this.badylOffsetTop + this.badylHeight) {
              this.switchState("bottom");
            } else if (scrollingTop) {
              this.switchState("unstable", {
                top: (this.unstableTop = windowScrollTop - this.badylOffsetTop - (this.badylInnerHeight - windowHeight)) + "px"
              });
            }
            break;
          case "fixTop":
            if (windowScrollTop < this.badylOffsetTop) {
              this.switchState("top");
            } else if (windowScrollTop >= this.badylOffsetTop + this.badylHeight - this.badylInnerHeight) {
              this.switchState("bottom");
            } else if (scrollingBottom) {
              this.switchState("unstable", {
                top: (this.unstableTop = windowScrollTop - this.badylOffsetTop) + "px"
              });
            }
            break;
          case "unstable":
            if (windowScrollTop < this.unstableTop + this.badylOffsetTop) {
              this.switchState("fixTop");
            } else if (windowScrollTop >= this.unstableTop + this.badylOffsetTop + (this.badylInnerHeight - windowHeight)) {
              this.switchState("fixBottom");
            }
        }
      } else {
        if (windowScrollTop >= this.badylHeight + this.badylOffsetTop - this.badylInnerHeight) {
          this.switchState("bottom");
        } else if (windowScrollTop > this.badylOffsetTop) {
          this.switchState("fixTop");
        } else {
          this.switchState("top");
        }
      }
      return this.prevWindowScrollTop = windowScrollTop;
    };

    Badyl.prototype.switchState = function(newState, addCss) {
      if (newState === this.state) {
        return;
      }
      if (this.cssSnippets[newState]) {
        this.$badylInner.css(this.cssSnippets[newState]);
      }
      if (addCss) {
        this.$badylInner.css(addCss);
      }
      return this.state = newState;
    };

    Badyl.prototype.measureInnerWidth = function($el) {
      var $measureDiv, result;
      $el.append($measureDiv = $("<div>").css({
        display: "block",
        width: "100%"
      }));
      result = $measureDiv.width();
      $measureDiv.remove();
      return result;
    };

    return Badyl;

  })();
  return $.fn.badyl = function() {
    var args, method;
    method = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    return this.each(function() {
      var badyl;
      badyl = $(this).data('badyl');
      if (!badyl) {
        badyl = new Badyl(this, typeof method === 'object' ? method : {});
      }
      if (typeof method === 'string') {
        return badyl[method].apply(badyl, args);
      }
    });
  };
};

if (typeof define === 'function' && define.amd) {
  define(['jquery'], plugin);
} else {
  plugin(jQuery);
}


/*
@name jquery-select7
@version 1.2.5
@author Se7enSky studio <info@se7ensky.com>
 */

/*! jquery-select7 1.2.5 http://github.com/Se7enSky/jquery-select7 */
var plugin,
  slice = [].slice;

plugin = function($) {
  "use strict";
  var Select7, readItemsFromSelect, readSelected, trim;
  trim = function(s) {
    return s.replace(/^\s*/, '').replace(/\s*$/, '');
  };
  readItemsFromSelect = function(el) {
    var placeholderText, readOptgroup, readOption, readOptionsAndOptgroups;
    if (placeholderText = $(el).attr("placeholder")) {
      $(el).find("option:first").prop("disabled", true).attr("data-is-placeholder", true).text(placeholderText);
    }
    readOption = function(option) {
      var c, data;
      data = $(option).data();
      data.title = trim($(option).text());
      data.value = $(option).attr("value") || trim($(option).text());
      if ($(option).attr("disabled")) {
        data.disabled = true;
      }
      if (c = $(option).attr("class")) {
        data["class"] = c;
      }
      return data;
    };
    readOptgroup = function(optgroup) {
      var c, data;
      data = $(optgroup).data();
      data.isOptgroup = true;
      data.title = trim($(optgroup).attr("label"));
      if (c = $(optgroup).attr("class")) {
        data["class"] = c;
      }
      data.options = readOptionsAndOptgroups(optgroup);
      return data;
    };
    readOptionsAndOptgroups = function(el) {
      var item, j, len, ref, results;
      ref = $(el).find("> option, > optgroup");
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        item = ref[j];
        if ($(item).is("option")) {
          results.push(readOption(item));
        } else {
          results.push(readOptgroup(item));
        }
      }
      return results;
    };
    return readOptionsAndOptgroups(el);
  };
  readSelected = function(el, items) {
    var item, j, l, len, len1, option, ref, selectedValue;
    selectedValue = $(el).val();
    for (j = 0, len = items.length; j < len; j++) {
      item = items[j];
      if (item.isOptgroup) {
        ref = item.options;
        for (l = 0, len1 = ref.length; l < len1; l++) {
          option = ref[l];
          if (option.value === selectedValue) {
            return option;
          }
        }
      } else if (item.value === selectedValue) {
        return item;
      }
    }
    if (items.length > 0 && items[0].isPlaceholder) {
      return items[0];
    }
    return null;
  };
  Select7 = (function() {
    Select7.prototype.defaults = {
      nativeDropdown: false,
      readonly: false
    };

    function Select7(el1, config) {
      var ref, templateCurrentFnName, templateOptgroupFnName, templateOptionFnName;
      this.el = el1;
      this.$el = $(this.el);
      this.$select7 = null;
      this.$drop = null;
      this.config = $.extend({}, this.defaults, config);
      if (this.$el.is(".select7_native_dropdown")) {
        this.config.nativeDropdown = true;
      }
      if (this.$el.is(".select7_readonly")) {
        this.config.readonly = true;
      }
      this.config.removeCurrent = !this.$el.is(".select7_no-remove_current");
      if (this.$el.is(".select7_collapse_optgroups")) {
        this.config.collapseOptgroups = true;
      }
      ref = this.$el.data(), templateOptionFnName = ref.templateOptionFnName, templateOptgroupFnName = ref.templateOptgroupFnName, templateCurrentFnName = ref.templateCurrentFnName;
      if (templateOptionFnName) {
        this.config.optionTemplate = function() {
          var args, ref1;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return (ref1 = window[templateOptionFnName]).call.apply(ref1, [this].concat(slice.call(args)));
        };
      }
      if (templateOptgroupFnName) {
        this.config.optgroupTemplate = function() {
          var args, ref1;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return (ref1 = window[templateOptgroupFnName]).call.apply(ref1, [this].concat(slice.call(args)));
        };
      }
      if (templateCurrentFnName) {
        this.config.currentTemplate = function() {
          var args, ref1;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return (ref1 = window[templateCurrentFnName]).call.apply(ref1, [this].concat(slice.call(args)));
        };
      }
      this.updateItemsAndSelected();
      this.opened = false;
      this.pwnSelect();
    }

    Select7.prototype.updateItemsAndSelected = function() {
      this.items = readItemsFromSelect(this.el);
      return this.selected = readSelected(this.el, this.items);
    };

    Select7.prototype.pwnSelect = function() {
      var classes, h, select7Markup, v, w;
      if (!this.config.nativeDropdown) {
        this.$el.hide();
      }
      classes = this.$el.attr("class").split(" ");
      classes.splice(classes.indexOf("select7"), 1);
      select7Markup = "<div class=\"select7 " + (classes.join(' ')) + "\">\n	<div class=\"select7__current\">\n		<span data-role=\"value\" class=\"select7__current-value\" data-value=\"\"></span><span class=\"select7__caret\"></span>\n	</div>\n</div>";
      this.$select7 = $(select7Markup);
      this.$el.data("updateCurrentFn", (function(_this) {
        return function() {
          return _this.updateCurrent();
        };
      })(this));
      this.$el.on("change", this.$el.data("updateCurrentFn"));
      this.updateCurrent();
      if (!this.config.nativeDropdown) {
        this.$select7.find(".select7__current").click((function(_this) {
          return function() {
            return _this.toggle();
          };
        })(this));
      }
      this.$el.after(this.$select7);
      if (this.config.nativeDropdown) {
        this.$el.css({
          position: "absolute",
          transformOrigin: "top left",
          zIndex: 1,
          opacity: 0,
          margin: 0,
          padding: 0
        });
        v = function($el, k) {
          return parseFloat($el.css(k).replace("px", ""));
        };
        w = function($el) {
          return v($el, "width") + v($el, "padding-left") + v($el, "padding-right") + v($el, "border-left-width") + v($el, "border-right-width");
        };
        h = function($el) {
          return v($el, "height") + v($el, "padding-top") + v($el, "padding-bottom") + v($el, "border-top-width") + v($el, "border-bottom-width");
        };
        return this.$el.css({
          transform: "scaleX(" + (w(this.$select7) / w(this.$el)) + ") scaleY(" + (h(this.$select7) / h(this.$el)) + ")"
        });
      }
    };

    Select7.prototype.updateCurrent = function() {
      var $value;
      this.updateItemsAndSelected();
      $value = this.$select7.find("[data-role='value']");
      if (this.selected === null) {
        this.selected = {
          isPlaceholder: true,
          title: "-"
        };
      }
      $value.attr("data-value", this.selected.isPlaceholder ? "" : this.selected.value);
      $value.toggleClass("select7__placeholder", !!this.selected.isPlaceholder);
      if (this.config.currentTemplate) {
        return $value.html(this.config.currentTemplate.call(this, this.selected, this.items));
      } else {
        $value.text(this.selected.title);
        $value.find(".select7__icon").remove();
        if (this.selected.icon) {
          return $value.prepend("<span class=\"select7__icon\"><img src=\"" + this.selected.icon + "\"></span>");
        }
      }
    };

    Select7.prototype.open = function() {
      var $dropList, generate$optgroup, generate$option, i, item, j, len, ref;
      if (this.opened) {
        return;
      }
      this.items = readItemsFromSelect(this.el);
      if (this.items.length === 0) {
        return;
      }
      this.$drop = $("<ul class=\"select7__drop\"></ul>");
      this.$drop = $("<div class=\"select7__drop\"></div>");
      $dropList = $("<ul class=\"select7__drop-list\"></ul>");
      this.$drop.append($dropList);
      generate$option = (function(_this) {
        return function(option) {
          var $option;
          $option = $("<li class=\"select7__option " + (option["class"] || "") + "\"></li>");
          if (_this.config.optionTemplate) {
            $option.html(_this.config.optionTemplate.call(_this, option, _this.items));
          } else {
            $option.text(option.title);
          }
          if (option.disabled) {
            $option.addClass("select7__option_disabled");
          }
          if (option === _this.selected) {
            $option.addClass("select7__option_current");
          }
          if (option.icon) {
            $option.prepend("<span class=\"select7__icon\"><img src=\"" + option.icon + "\"></span>");
          }
          $option.data("option", option);
          return $option;
        };
      })(this);
      generate$optgroup = (function(_this) {
        return function(optgroup) {
          var $label, $optgroup, $ul, hasCurrent, j, len, option, ref;
          $optgroup = $("<li class=\"select7__optgroup " + (optgroup["class"] || "") + "\"></li>");
          if (_this.config.collapseOptgroups) {
            $optgroup.addClass("select7__optgroup_collapse");
          }
          if (optgroup.group) {
            $optgroup.attr("data-group", optgroup.group);
          }
          if (optgroup.parent) {
            $optgroup.attr("data-parent", optgroup.parent);
          }
          hasCurrent = false;
          $label = $("<span class=\"select7__optgroup-label\"></span>");
          if (_this.config.optgroupTemplate) {
            $label.html(_this.config.optgroupTemplate.call(_this, optgroup, _this.items));
          } else {
            $label.text(optgroup.title);
          }
          $optgroup.append($label);
          if (item.options) {
            $ul = $("<ul class=\"select7__optgroup-items\"></ul>");
            ref = item.options;
            for (j = 0, len = ref.length; j < len; j++) {
              option = ref[j];
              if (option === _this.selected) {
                hasCurrent = true;
              }
              if (_this.config.removeCurrent && option === _this.selected) {
                continue;
              }
              $ul.append(generate$option(option));
            }
            $optgroup.append($ul);
          }
          if (_this.config.collapseOptgroups && hasCurrent) {
            $optgroup.addClass("select7__optgroup_collapse_open");
          }
          return $optgroup;
        };
      })(this);
      ref = this.items;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        item = ref[i];
        if (item.isPlaceholder) {
          continue;
        }
        if (this.config.removeCurrent && item === this.selected) {
          continue;
        }
        $dropList.append(item.isOptgroup ? generate$optgroup(item) : generate$option(item));
      }
      this.$drop.find('.select7__optgroup').each(function() {
        var parent;
        parent = $(this).data('parent');
        if (parent) {
          $(this).parent().find('.select7__optgroup[data-group=' + parent + ']').find('>.select7__optgroup-items').append($(this));
        }
        if ($(this).hasClass('select7__optgroup_collapse_open')) {
          return $(this).parents('.select7__optgroup_collapse').addClass('select7__optgroup_collapse_open');
        }
      });
      this.$drop.on("click", ".select7__option", (function(_this) {
        return function(e) {
          var $el, option;
          if (!_this.config.readonly) {
            $el = $(e.currentTarget);
            option = $el.data("option");
            if (option.disabled) {
              return;
            }
            if (option.href) {
              window.location.href = option.href;
              return;
            }
            _this.$el.val(option.value).trigger("change");
          }
          return _this.close();
        };
      })(this));
      this.$drop.on("click", ".select7__optgroup-label", (function(_this) {
        return function(e) {
          var $optgroup;
          $optgroup = $(e.currentTarget).parent();
          return $optgroup.toggleClass("select7__optgroup_collapse_open");
        };
      })(this));
      this.$select7.append(this.$drop);
      this.$select7.addClass("select7_open");
      this.opened = true;
      $("body").trigger("select7Opened");
      return setTimeout((function(_this) {
        return function() {
          _this.$drop.click(function(e) {
            return e.stopPropagation();
          });
          _this.$drop.data("closeFn", function() {
            return _this.close();
          });
          return $("body").on("click select7Opened", _this.$drop.data("closeFn"));
        };
      })(this), 1);
    };

    Select7.prototype.close = function() {
      if (!this.opened) {
        return;
      }
      this.$select7.removeClass("select7_open");
      $("body").off("click select7Opened", this.$drop.data("closeFn"));
      this.$drop.remove();
      this.$drop = null;
      return this.opened = false;
    };

    Select7.prototype.toggle = function() {
      if (this.opened) {
        return this.close();
      } else {
        return this.open();
      }
    };

    Select7.prototype.destroy = function() {
      if (this.opened) {
        close();
      }
      this.$select7.remove();
      this.$el.off("change", this.$el.data("updateCurrentFn"));
      this.$el.data("updateCurrentFn", null);
      this.$el.data("select7", null);
      return this.$el.show();
    };

    return Select7;

  })();
  return $.fn.select7 = function() {
    var args, method;
    method = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    return this.each(function() {
      var select7;
      if ($(this).find('option').length === 1) {
        $(this).hide();
        return $(this).parent().append('<div class="select7 disabled"><div class="select7__current"><span data-role="value" class="select7__current-value" data-value="0">' + $(this).parent().find('option').text() + '</span></div></div>');
      } else {
        select7 = $(this).data('select7');
        if (!select7) {
          select7 = new Select7(this, typeof method === 'object' ? option : {});
          $(this).data('select7', select7);
        }
        if (typeof method === 'string') {
          return select7[method].apply(select7, args);
        }
      }
    });
  };
};

if (typeof define === 'function' && define.amd) {
  define(['jquery'], plugin);
} else {
  plugin(jQuery);
}

var matchSrcset, parseSrcset, processSrcset;

parseSrcset = function(srcset) {
  var i, j, len, len1, results, spec, specString, specStringPart, specStringParts;
  srcset = srcset.split(",");
  results = [];
  for (i = 0, len = srcset.length; i < len; i++) {
    specString = srcset[i];
    specStringParts = specString.replace(/^\s*/, "").replace(/\s*$/, "").split(" ");
    spec = {
      url: specStringParts.shift()
    };
    for (j = 0, len1 = specStringParts.length; j < len1; j++) {
      specStringPart = specStringParts[j];
      if (specStringPart.match(/^\d+w$/)) {
        spec.width = parseInt(specStringPart);
      } else if (specStringPart.match(/^\d+h$/)) {
        spec.height = parseInt(specStringPart);
      } else if (specStringPart.match(/^\d+x$/)) {
        spec.pixelDepth = parseInt(specStringPart);
      }
    }
    results.push(spec);
  }
  return results;
};

matchSrcset = function(srcset, windowWidth, windowHeight, pixelDepth) {
  var arbitratorRange, i, len, matched, matchedRange, range, spec;
  matched = null;
  matchedRange = 0;
  for (i = 0, len = srcset.length; i < len; i++) {
    spec = srcset[i];
    if (spec.width && windowWidth > spec.width) {
      continue;
    }
    if (spec.height && windowHeight > spec.height) {
      continue;
    }
    if (spec.pixelDepth && pixelDepth < spec.pixelDepth) {
      continue;
    }
    range = 0;
    if (spec.width) {
      range += 10;
    }
    if (spec.height) {
      range += 10;
    }
    if (spec.pixelDepth) {
      range += 40;
    }
    if (range < matchedRange) {
      continue;
    }
    if (matched && range === matchedRange) {
      arbitratorRange = 0;
      if (spec.width && matched.width && spec.width !== matched.width) {
        arbitratorRange += spec.width < matched.width ? 1 : -1;
      }
      if (spec.height && matched.height && spec.height !== matched.height) {
        arbitratorRange += spec.height < matched.height ? 1 : -1;
      }
      if (spec.pixelDepth && matched.pixelDepth && spec.pixelDepth !== matched.pixelDepth) {
        arbitratorRange += spec.pixelDepth > matched.pixelDepth ? 1 : -1;
      }
      if (arbitratorRange < 0) {
        continue;
      }
    }
    spec.range = range;
    matched = spec;
    matchedRange = range;
  }
  if (matched) {
    return matched.url;
  } else {
    return null;
  }
};

processSrcset = function() {
  var pixelDepth, windowHeight, windowWidth;
  windowWidth = $(window).width();
  windowHeight = $(window).height();
  pixelDepth = window.devicePixelRatio || 1;
  return $("img[srcset]").each(function() {
    var matched, srcset;
    srcset = parseSrcset($(this).attr("srcset"));
    matched = matchSrcset(srcset, windowWidth, windowHeight, pixelDepth);
    if (matched) {
      return $(this).attr("src", matched);
    }
  });
};

$(function() {
  processSrcset();
  return $(window).resize(processSrcset);
});


/*! wait-for-web-fonts 2.0.0 http://github.com/Se7enSky/wait-for-web-fonts */

/*
@name wait-for-web-fonts
@description Detect webfont loaded with JavaScript. Code styred from http://stackoverflow.com/a/11689060
@version 2.0.0
@author Se7enSky studio <info@se7ensky.com>
 */
var waitForWebFonts;

waitForWebFonts = function(fonts, callback) {
  var done, f, i, len, loadedFonts, results;
  done = function() {
    return setTimeout((function(_this) {
      return function() {
        return callback();
      };
    })(this), 500);
  };
  loadedFonts = 0;
  results = [];
  for (i = 0, len = fonts.length; i < len; i++) {
    f = fonts[i];
    results.push((function(font) {
      var checkFont, interval, node, width;
      node = document.createElement("span");
      node.innerHTML = "giItT1WQy@!-/#";
      node.style.position = "fixed";
      node.style.left = "-10000px";
      node.style.top = "-10000px";
      node.style.fontSize = "1000px";
      node.style.fontFamily = "sans-serif";
      node.style.fontVariant = "normal";
      node.style.fontStyle = "normal";
      node.style.fontWeight = "normal";
      node.style.letterSpacing = "0";
      document.body.appendChild(node);
      width = node.offsetWidth;
      node.style.fontFamily = font;
      interval = void 0;
      checkFont = function() {
        if (node && node.offsetWidth !== width) {
          ++loadedFonts;
          node.parentNode.removeChild(node);
          node = null;
        }
        if (loadedFonts >= fonts.length) {
          if (interval) {
            clearInterval(interval);
          }
          if (loadedFonts === fonts.length) {
            done();
            return true;
          }
        }
      };
      if (!checkFont()) {
        return interval = setInterval(checkFont, 500);
      }
    })(f));
  }
  return results;
};

if (typeof define === 'function' && define.amd) {
  define([], waitForWebFonts);
} else {
  window.waitForWebFonts = waitForWebFonts;
}

$(document).each(function() {
  return $(".js-seo").clone().appendTo('.flex_container').addClass('is-open');
});

$("#select-specialization").on("click", "li a", function() {
  var item;
  item = $(this);
  $('.js-clone span').text(item.text());
  $('.js-clear').addClass('is-active');
  $('.direction__title').text('Выбрано направление');
  return $("#select-specialization").modal("hide");
});

$(".js-clear").on("click", function() {
  $(this).siblings("span").text("Выберите направление");
  $(this).removeClass('is-active');
  $('.direction__title').text('Направление');
  return false;
});

$('.cla-fillials a').tooltip({
  container: '.main-content'
});

$('.info-cla').each(function() {
  var _this, parent;
  _this = $(this);
  parent = _this.parent();
  _this.tooltip({
    container: parent
  });
});

$(".js-autocomplete-subject").each(function() {
  var _jScrollPane, _jScrollPaneAPI, _jSheight, availableTags;
  _jScrollPane = void 0;
  _jScrollPaneAPI = void 0;
  _jSheight = 162;
  $.ui.autocomplete.prototype._renderItem = function(ul, item) {
    var highlighted;
    highlighted = item.value.split(this.term).join('<span class="is-active">' + this.term + '</span>');
    return $("<li></li>").data("item.autocomplete", item).append('<a class="search-select" data-search="' + item.value + '">' + highlighted + '</a>').appendTo(ul);
  };
  availableTags = [
    {
      id: 1,
      label: 'Реовазография (РВГ)',
      value: 'Реовазография (РВГ)2'
    }, {
      id: 2,
      label: 'Реоэнцофалография (РЭГ)',
      value: 'Реоэнцофалография (РЭГ)2'
    }, {
      id: 3,
      label: 'Ректороманоскопия',
      value: 'Ректороманоскопия2'
    }, {
      id: 4,
      label: 'Ректороманоскопия',
      value: 'Ректороманоскопия2'
    }, {
      id: 4,
      label: 'Ректороманоскопия',
      value: 'Ректороманоскопия2'
    }, {
      id: 4,
      label: 'Ректороманоскопия',
      value: 'Ректороманоскопия2'
    }, {
      id: 4,
      label: 'Ректороманоскопия',
      value: 'Ректороманоскопия2'
    }
  ];
  $('.js-autocomplete-subject').autocomplete({
    appendTo: ".js-input-cla",
    open: function() {
      $(this).data('uiAutocomplete').menu.element.addClass('subject-scroll1');
      if (void 0 !== _jScrollPane) {
        _jScrollPaneAPI.destroy();
      }
      $('.subject-scroll1 > li').wrapAll($('<ul class="scroll-panel"></ul>').height(_jSheight));
      _jScrollPane = $('.scroll-panel').jScrollPane();
      _jScrollPaneAPI = _jScrollPane.data('jsp');
    },
    close: function(event, ui) {
      _jScrollPaneAPI.destroy();
      _jScrollPane = void 0;
    },
    select: function(event, ui) {
      $(this).val(ui.item.value);
      return false;
    },
    source: function(request, response) {
      var noResult;
      noResult = $('.no-results');
      $.ajax({
        url: '/analysis/search/live',
        dataType: 'json',
        method: 'GET',
        data: {
          term: request.term
        },
        success: function(data) {
          var results;
          results = $.ui.autocomplete.filter(data.list, request.term);
          if (!results.length) {
            noResult.addClass('is-hide');
          } else {
            noResult.removeClass('is-hide');
          }
          return response(results);
        }
      });
      if (!($('.js-autocomplete-subject').val().length >= 2)) {
        noResult.removeClass('is-hide');
        $('.js-rezult-delete').hide();
      } else {
        $('.js-rezult-delete').show();
      }
    }
  });
  return $('.js-rezult-delete').on('click', function(event) {
    var autocompleteInput, rezult;
    autocompleteInput = $(this).siblings('.js-autocomplete-subject');
    rezult = $(this).siblings('.no-results');
    $(this).hide();
    rezult.removeClass('is-hide');
    autocompleteInput.val(' ');
    event.stopPropagation();
    return false;
  });
});

$(function() {
  var updateBadgeLabels;
  updateBadgeLabels = function() {
    return $(".badge-label").each(function() {
      var w;
      w = $(this).outerWidth() / 2;
      return $(this).find(".badge-label__arrow").css({
        borderLeftWidth: w + "px",
        borderRightWidth: w + "px"
      });
    });
  };
  $(window).resize(updateBadgeLabels);
  $(document).on("shown.bs.tab", updateBadgeLabels);
  $(document).on("shown.bs.modal", updateBadgeLabels);
  return updateBadgeLabels();
});

$(document).on('click', '.js-services-btn', function() {
  var drop;
  drop = $(this).siblings('.js-services-block');
  drop.slideToggle('fast');
  $(this).parents('.js-services').toggleClass('active');
  return false;
});



$('.js-add-tel').click(function() {
  $('.add-tel').addClass('is-active');
});

$('.js-section-choice').each(function() {
  var item, removeClass;
  removeClass = true;
  item = $(this).find('.section-choice');
  $('body').click(function() {
    if (removeClass) {
      item.removeClass('is-open');
      return removeClass = true;
    }
  });
  $(this).find('.js-field-child').click(function() {
    if ($(this).hasClass('is-active')) {
      $('.js-field-child').removeClass('is-active');
      $('.section-choice').removeClass('is-open');
      removeClass = false;
    } else {
      $('.js-field-child').removeClass('is-active');
      $('.section-choice').removeClass('is-open');
      $(this).siblings('.section-choice').addClass('is-open');
      removeClass = true;
    }
    return false;
  });
  return item.click(function() {
    return false;
  });
});

$('.js-child').click(function() {
  var elChild, elChildren, elField, elFields, id, item;
  id = $(this).data('id');
  item = $('.item__mod');
  elFields = $('.js-group');
  elField = $('.js-group[data-field="' + id + '"]');
  elChild = $(this);
  elChildren = $('.js-child');
  if (!$(this).hasClass('is-active')) {
    elFields.removeClass('is-open');
    elChildren.removeClass('is-active');
    item.addClass('is-open');
    elChild.addClass('is-active');
    elField.addClass('is-open');
    if ($(this).data('id') === 0) {
      item.removeClass('is-open');
    }
  }
  $(this).parent('.section-choice').removeClass('is-open');
  return $(this).parent('.section-choice').siblings('.js-field-child').text($(this).text());
});

$('.js-remove-parent').each(function() {
  var elParent;
  elParent = $(this);
  return elParent.find('.js-remove-item').click(function() {
    var elTotal, item;
    item = $('.content-favorites__item');
    elTotal = elParent.find(item).length;
    $(this).closest(item).remove();
    console.log(elParent.find(item).length);
    if (elTotal === 1) {
      elParent.remove();
    }
    false;
  });
});

$('.js-table-scroll').jScrollPane({
  autoReinitialise: true
});

$('.js-field-child').click(function() {
  var list;
  list = $(this).siblings('.section-choice');
  if (!list.hasClass('jspScrollable')) {
    list.addClass('jspScrollable');
    list.jScrollPane();
    return;
  }
});

$('.js-selection-city').click(function() {
  var text;
  text = $(this).text();
  $('.js-selection-main').text(text);
  return $(this).closest('.section-choice').removeClass('is-open');
});

$('.js-date-mast').inputmask({
  mask: "99.99.9999 "
});

$(document).on('click', '.js-cla-btn', function() {
  var drop;
  drop = $(this).siblings('.js-cla-block');
  drop.slideToggle('fast');
  $(this).parents('.js-cla-tabs').toggleClass('active');
  return false;
});

$("#select-area").on("change", "input", function() {
  var spanMain, spanText;
  spanText = $(this).siblings('span').text();
  spanMain = $(this).parents('label').siblings();
  if (spanMain.is('ul')) {
    spanMain.parent().addClass('is-main-disrtict');
  }
  if ($(this).prop('checked')) {
    $(this).parents('label').addClass('is-active');
    $(this).siblings('span').attr('data-place', spanText);
    return $('.js-btn-text').text('Добавьте район');
  } else {
    $(this).parents('label').removeClass('is-active');
    return $('.js-btn-text').text('Выберете район');
  }
});

$("#select-area").on("click", ".js-btn-clone", function() {
  var item, itemParent;
  item = $('.is-active').children('span');
  itemParent = item.parent('.is-active');
  $(".alternative-btn__district").empty();
  if (item.siblings("input:checkbox:checked")) {
    item.clone().appendTo(".alternative-btn__district");
    return $(".alternative-btn__district").find("span").append('<i class="icon-close js-remove"></i>');
  }
});

$("#select-area [data-action='reset']").on("click", function() {
  $("#select-area").find('.pill').removeClass('is-active');
  return $('.js-btn-text').text('Выберете район');
});

$(".alternative-btn__district").on("click", ".js-remove", function() {
  var $item, $itemParent, data1, inputAlternative;
  inputAlternative = $(this).parents('span');
  data1 = inputAlternative.data("place");
  $item = $("#select-area").find('.is-active').children('span[data-place=\'' + data1 + '\']');
  $itemParent = $item.closest('.pill-group');
  inputAlternative.remove();
  $item.siblings('input').prop("checked", false).parents('.pill').removeClass('is-active');
  if ($itemParent.hasClass('is-main-disrtict')) {
    $itemParent.find(".pill :checked").prop("checked", false);
  }
  if (!$("#select-area").find('.is-active').hasClass('is-active')) {
    return $('.js-btn-text').text('Выберете район');
  }
});

$("#select-specialization").on("click", "li a", function() {
  var item;
  item = $(this);
  $('.alternative-btn__specialization span').empty();
  $('.alternative-btn__specialization span').text(item.text());
  $('.js-remove').addClass('is-active');
  return $('.js-btn-special').text('Выбрана специальность');
});

$(".js-remove").on("click", function() {
  $(this).siblings("span").empty();
  $(this).removeClass('is-active');
  $('.js-btn-special').text('Выберите специальность');
  return false;
});

$('.js-clinic-autocomplete').each(function() {
  var _jScrollPane, _jScrollPaneAPI, _jSheight;
  _jScrollPane = void 0;
  _jScrollPaneAPI = void 0;
  _jSheight = 200;
  jQuery.ui.autocomplete.prototype._resizeMenu = function() {
    var ul;
    ul = this.menu.element;
    ul.outerWidth(this.element.outerWidth());
  };
  return $(this).autocomplete({
    minLength: 2,
    appendTo: ".application",
    open: function() {
      $(this).data('uiAutocomplete').menu.element.addClass('subject-scroll');
      if (void 0 !== _jScrollPane) {
        _jScrollPaneAPI.destroy();
      }
      $('.subject-scroll > li').wrapAll($('<ul class="scroll-panel"></ul>').height(_jSheight));
      _jScrollPane = $('.scroll-panel').jScrollPane();
      _jScrollPaneAPI = _jScrollPane.data('jsp');
    },
    source: function(request, response) {
      return $.ajax({
        url: '/analysis/search/live/clinic-profile.json',
        dataType: 'json',
        method: 'GET',
        data: request,
        success: function(data) {
          return response($.map(data.profile, function(item) {
            return {
              value: item.value,
              label: item.label
            };
          }));
        }
      });
    }
  });
});

$('.js-clinic-datepicker').datetimepicker({
  format: "dd MM yyyy - hh:ii",
  weekStart: 1,
  todayBtn: 0,
  autoclose: 1
});

$('.js-datepicker-trigger').on('click', function() {
  return $('.js-clinic-datepicker').datetimepicker('show');
});

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

$(function() {
  var $block, activeItemIndex, setActiveElement;
  $block = $(".comment-quotes");
  activeItemIndex = 0;
  setActiveElement = function(el) {
    $block.find(".comment-quotes__item.active").removeClass("active");
    $block.find(".comment-quotes__pane.active").removeClass("active");
    $(el).addClass("active");
    activeItemIndex = $(el).parent().index();
    return $block.find(".comment-quotes__pane").eq(activeItemIndex).addClass("active");
  };
  $(".comment-quotes__item").on("click", function() {
    return setActiveElement(this);
  });
  return $(".comment-quotes__header").owlCarousel({
    navigation: true,
    pagination: false,
    navigationText: ["", ""],
    rewindNav: false,
    lazyLoad: false,
    items: 5,
    itemsDesktop: [1215, 5],
    itemsTablet: [979, 5],
    itemsMobile: [767, 2],
    afterAction: function(el) {
      var activateIndex, owl;
      owl = $(el).data("owlCarousel");
      if (owl) {
        if (indexOf.call(owl.owl.visibleItems, activeItemIndex) < 0) {
          activateIndex = activeItemIndex < owl.owl.visibleItems[0] ? owl.owl.visibleItems[0] : owl.owl.visibleItems[owl.owl.visibleItems.length - 1];
          return setActiveElement($block.find(".comment-quotes__item").eq(activateIndex).get());
        }
      }
    }
  });
});

if (window.matchMedia('screen and (max-width: 767px)').matches) {
  $('.js-tab__mobile-c').addClass('js-tab__header-c');
}

$('.js-tab__header-c').click(function() {
  var item, parent;
  parent = $(this).parent(".js-tab__parent-index");
  item = parent.children('.js-content_hide-index');
  item.slideToggle('fast');
  parent.find('.btn__mobile').toggleClass('btn__mobile_open');
  $(this).toggleClass('tab__header_open');
  return false;
});

$(function() {
  return $('.js-datepicker').daterangepicker({
    autoUpdateInput: true,
    alwaysShowCalendars: true,
    startDate: moment(),
    opens: "left",
    applyClass: "apply-btn",
    cancelClass: "cancel-btn",
    ranges: {
      'Последние :': [],
      '7 дней': [moment(), moment().add(6, 'days')],
      '14 дней': [moment(), moment().add(13, 'days')],
      '30 дней': [moment(), moment().add(29, 'days')]
    },
    locale: {
      format: 'YYYY.MM.DD',
      separator: ' - ',
      applyLabel: 'Подтвердить',
      cancelLabel: 'Отменить',
      daysOfWeek: ['ВC', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'],
      monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
      firstDay: 1
    }
  });
});

if (window.matchMedia('screen and (max-width: 767px)').matches) {
  $('.js-tab__mobile-d').addClass('js-tab__header-d');
}

$('.js-tab__header-d').click(function() {
  var item, parent;
  parent = $(this).parent(".js-tab__parent-index");
  item = parent.children('.js-content-hide');
  item.slideToggle('fast');
  item.toggleClass('tab-active_info-index');
  parent.find('.btn__mobile').toggleClass('btn__mobile_open');
  $(this).toggleClass('tab__header_open');
  return false;
});

$('.js-nav a').on('click', function() {
  var section;
  section = $(this).attr('href');
  $('html, body').animate({
    scrollTop: $(section).offset().top - 35
  }, 500);
  return false;
});

$.fn.initFavoritesBlock = function() {
  return this.each(function() {
    var favored, favoritesBlockInitialized, ref;
    ref = $(this).data(), favored = ref.favored, favoritesBlockInitialized = ref.favoritesBlockInitialized;
    if (favoritesBlockInitialized) {
      return;
    }
    $(this).toggleClass("favorites-block_favored", !!favored);
    $(this).data("favoritesBlockInitialized", true);
    return $(this).on('click', function(e) {
      favored = $(this).data().favored;
      favored = !favored;
      $(this).toggleClass("favorites-block_favored", !!favored);
      $(this).data('favored', !!favored);
      $(this).trigger(!!favored ? 'favored' : 'unfavored');
      return e.preventDefault();
    });
  });
};

$(".favorites-block").initFavoritesBlock();

var trim;

trim = function(s) {
  return s.replace(/^\s*/, '').replace(/\s*$/, '');
};

$(".finder").on("columnagram.columnized", function() {
  return setTimeout((function(_this) {
    return function() {
      return $(_this).addClass("finder_loaded");
    };
  })(this), 50);
});

$(".finder .finder__field-text").each(function() {
  return $(this).data("emptyText", $(this).text());
});

$("a[data-toggle='tab'][href='#select-area-metro'], a[data-toggle='tab'][href='#select-area-districts']").on("shown.bs.tab", function(e) {
  return $("#select-area").find(".pill :checked").prop("checked", false);
});

$("#select-area [data-action='reset']").click(function() {
  $("#select-area").find(".pill :checked").prop("checked", false);
  $(".finder [data-target='#select-area'] .finder__field-text").text($(".finder [data-target='#select-area'] .finder__field-text").data("emptyText")).addClass("grey");
  $(".finder [data-target='#select-area'] input[type='hidden']").val("");
  return false;
});

$("#select-countries [data-action='reset']").click(function() {
  $("#select-countries").find(".pill :checked").prop("checked", false);
  $(".finder [data-target='#select-countries'] .finder__field-text").text($(".finder [data-target='#select-countries'] .finder__field-text").data("emptyText")).addClass("grey");
  $(".finder [data-target='#select-countries'] input[type='hidden']").val("");
  return false;
});

$("#select-specialization").on("click", "li a", function(e) {
  var dataValue, title, value;
  value = $(e.currentTarget).data().value;
  title = trim($(e.currentTarget).text());
  if (!value) {
    value = title;
  }
  dataValue = trim($(e.target).data('value'));
  $(".finder").trigger("specializationSelected", {
    title: title,
    value: value,
    dataValue: dataValue
  });
  return false;
});

$("select-other-spec").on("click", "li a", function(e) {
  var dataValue, title, value;
  value = $(e.currentTarget).data().value;
  title = trim($(e.currentTarget).text());
  if (!value) {
    value = title;
  }
  dataValue = trim($(e.target).data('value'));
  $(".finder").trigger("specializationSelected2", {
    title: title,
    value: value,
    dataValue: dataValue
  });
  return false;
});

$("#select-branch").on("click", "li a", function(e) {
  var title, value;
  value = $(e.currentTarget).data().value;
  title = trim($(e.currentTarget).text());
  if (!value) {
    value = title;
  }
  $(".finder").trigger("branchSelected", {
    title: title,
    value: value
  });
  return false;
});

$("#select-actions").on("click", "li a", function(e) {
  var title, value;
  value = $(e.currentTarget).data().value;
  title = trim($(e.currentTarget).text());
  if (!value) {
    value = title;
  }
  $(".finder").trigger("actionsSelected", {
    title: title,
    value: value
  });
  return false;
});

$("#select-bundles").on("click", "li a", function(e) {
  var title, value;
  value = $(e.currentTarget).data().value;
  title = trim($(e.currentTarget).text());
  if (!value) {
    value = title;
  }
  $(".finder").trigger("bundlesSelected", {
    title: title,
    value: value
  });
  return false;
});

$("#select-area-diagnostics").on("click", "li a", function(e) {
  var defaultTitle, ref, title, value;
  ref = $(e.currentTarget).data(), title = ref.title, value = ref.value;
  defaultTitle = $(e.currentTarget).siblings("ul").length ? trim($(e.currentTarget).text()) : (trim($(e.currentTarget).parent().parent().parent().find(">a:first").text())) + " " + (trim($(e.currentTarget).text()));
  if (!title) {
    title = defaultTitle;
  }
  if (!value) {
    value = title;
  }
  $(".finder").trigger("diagnosticSelected", {
    title: title,
    value: value
  });
  return false;
});

$("#select-area").on("click", ".modal-footer .btn", function() {
  var values;
  values = [];
  $("#select-area .pill :checked").each(function() {
    var $parentPill, $pill, title, value;
    $pill = $(this).closest(".pill");
    $parentPill = $pill.closest("ul").siblings(".pill");
    if ($parentPill.length === 1) {
      if ($parentPill.find(":checked").length) {
        return;
      }
    }
    value = $pill.data().value;
    title = trim($pill.text());
    if (!value) {
      value = title;
    }
    return values.push({
      title: title,
      value: value
    });
  });
  return $("#select-area").trigger("areaSelected", {
    values: values
  });
});

$(".finder #doctors").on("click", ".chooser__list__item-link", function(e) {
  var title, value;
  value = $(e.target).data().value;
  title = trim($(e.target).text());
  if (!value) {
    value = title;
  }
  $(".finder").trigger("specializationSelected", {
    title: title,
    value: value
  });
  return false;
});

$(".finder #clinics").on("click", ".chooser__list__item-link", function(e) {
  var title, value;
  value = $(e.target).data().value;
  title = trim($(e.target).text());
  if (!value) {
    value = title;
  }
  $(".finder").trigger("branchSelected", {
    title: title,
    value: value
  });
  return false;
});

$(".finder").on("specializationSelected", function(e, arg) {
  var dataValue, title, value;
  title = arg.title, value = arg.value, dataValue = arg.dataValue;
  if (docMaps.pageName === 'map' && value) {
    docMaps.loadDoctors('specialty', dataValue);
  }
  $(".finder [data-target='#select-specialization']").parent().find('.finder__field-text:first').val(value ? title : $(".finder [data-target='#select-specialization'] .finder__field-text").data("emptyText")).toggleClass("grey", !value);
  $(".finder [data-target='#select-specialization'] input[type='hidden']").val(value);
  return $("#select-specialization").modal("hide");
});

$(".finder").on("specializationSelected2", function(e, arg) {
  var dataValue, title, value;
  title = arg.title, value = arg.value, dataValue = arg.dataValue;
  if (docMaps.pageName === 'map' && value) {
    docMaps.loadDoctors('specialty', dataValue);
  }
  $(".finder [data-target='#select-specialization']").parent().find('.finder__field-text:first').val(value ? title : $(".finder [data-target='#select-specialization'] .finder__field-text").data("emptyText")).toggleClass("grey", !value);
  $(".finder [data-target='#select-specialization'] input[type='hidden']").val(value);
  return $("#select-specialization").modal("hide");
});

$(".finder").on("branchSelected", function(e, arg) {
  var title, value;
  title = arg.title, value = arg.value;
  $(".finder [data-target='#select-branch']").parent().find('.finder__field-text:first').val(value ? title : $(".finder [data-target='#select-branch'] .finder__field-text").data("emptyText")).toggleClass("grey", !value);
  $("#select-branch").modal("hide");
  $(".finder [data-target='#select-branch'] input[type='hidden']").val(value);
  return false;
});

$(".finder").on("actionsSelected", function(e, arg) {
  var title, value;
  title = arg.title, value = arg.value;
  $(".finder [data-target='#select-actions']").parent().find('.finder__field-text:first').val(value ? title : $(".finder [data-target='#select-actions'] .finder__field-text").data("emptyText")).toggleClass("grey", !value);
  $("#select-actions").modal("hide");
  $(".finder [data-target='#select-actions'] input[type='hidden']").val(value);
  return false;
});

$(".finder").on("bundlesSelected", function(e, arg) {
  var title, value;
  title = arg.title, value = arg.value;
  $(".finder [data-target='#select-bundles']").parent().find('.finder__field-text:first').val(value ? title : $(".finder [data-target='#select-bundles'] .finder__field-text").data("emptyText")).toggleClass("grey", !value);
  $(".finder [data-target='#select-bundles'] input[type='hidden']").val(value);
  $("#select-bundles").modal("hide");
  return false;
});

$("#select-area").on("areaSelected", function(e, arg) {
  var title, value, values;
  values = arg.values;
  title = ((function() {
    var j, len, results1;
    results1 = [];
    for (j = 0, len = values.length; j < len; j++) {
      value = values[j];
      results1.push(value.title);
    }
    return results1;
  })()).join(", ");
  value = ((function() {
    var j, len, results1;
    results1 = [];
    for (j = 0, len = values.length; j < len; j++) {
      value = values[j];
      results1.push(value.value);
    }
    return results1;
  })()).join(", ");
  $(".finder [data-target='#select-area'] input[type='hidden']").val(value);
  $(".finder [data-target='#select-area']").parent().find('.finder__field-text:last').val(values.length > 0 ? title : $(".finder [data-target='#select-area'] .finder__field-text").data("emptyText")).toggleClass("grey", values.length === 0);
  return $("#select-area").modal("hide");
});

$('.finder').on('diagnosticSelected', function(t, e) {
  var i, n;
  n = void 0;
  i = void 0;
  n = e.title;
  i = e.value;
  $('.finder [data-target=\'#select-area-diagnostics\'] .finder__field-text').text(i ? n : $('.finder [data-target=\'#select-area-diagnostics\'] .finder__field-text').data('emptyText')).toggleClass('grey', !i);
  $('.finder [data-target=\'#select-area-diagnostics\'] input[type=\'hidden\']').val(i);
  return $('#select-area-diagnostics').modal('hide');
});

$(".js-finder-autocomplete").each(function() {
  var _jScrollPane, _jScrollPaneAPI, _jSheight, availableTags;
  _jScrollPane = void 0;
  _jScrollPaneAPI = void 0;
  _jSheight = 342;
  $.ui.autocomplete.prototype._renderItem = function(ul, item) {
    var highlighted;
    highlighted = item.label.split(this.term).join('<span class="is-active">' + this.term + '</span>');
    return $("<li></li>").data("item.autocomplete", item).append('<a class="search-select" data-search="' + item.label + '">' + highlighted + '</a>').appendTo(ul);
  };
  availableTags = ['(Биохимия для ФиброМакса) (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза', 'ФиброМакс (Холестерин; Глюкоза (сыворотка); Триглицериды; Гаптоглог γ-глутаматтрансфераза', 'γ-глутаматтрансфераза', 'γ-глутаматтрансфераза (ГГТ, GGT)', 'γ-глутаматтрансфераза (ГГТ)', 'Тиреоидная панель', 'Тиреоглобулин (ТГ)', 'Тиреоглобулин, антитела (АТТГ)', 'Тиреоидный: ТТГ, Т4 св., АМСт (тиреотропный гормон (ТТГ); Тироксин свободный (T4 свободный) ', 'Тиреотропный гормон (ТТГ)', 'Тироксин общий', 'Тироксин свободный (T4 свободный)', 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Illo facilis necessitatibus omnis unde? Et nobis, placeat odio non corrupti molestiae iure earum repellendus tempora velit voluptate iusto deserunt. Accusantium, maiores!'];
  return $('.js-finder-autocomplete').autocomplete({
    source: availableTags,
    appendTo: ".finder__field",
    open: function() {
      var _this;
      $(this).data('uiAutocomplete').menu.element.addClass('subject-scroll');
      if (void 0 !== _jScrollPane) {
        _jScrollPaneAPI.destroy();
      }
      if ($('.subject-scroll').height() <= _jSheight) {
        $('.subject-scroll > li').wrapAll($('<ul class="scroll-panel"></ul>').css('height', 'auto'));
        $('.ui-menu-item').addClass('no-scroll');
      } else {
        $('.subject-scroll > li').wrapAll($('<ul class="scroll-panel"></ul>').height(_jSheight));
        _jScrollPane = $('.scroll-panel').jScrollPane();
        _jScrollPaneAPI = _jScrollPane.data('jsp');
      }
      if ($('.ui-menu-item').height() >= 20) {
        _this = $('.ui-menu-item');
        _this.addClass('js-text-hidden');
        _this.dotdotdot({
          elipsis: " ...",
          fallbackToLetter: true
        });
      }
    },
    close: function(event, ui) {
      _jScrollPaneAPI.destroy();
      _jScrollPane = void 0;
    },
    select: function(event, ui) {
      $(this).val(ui.item.label);
      return false;
    },
    source: function(request, response) {
      var noResultFinder, results;
      noResultFinder = $('.no-results-finder');
      results = $.ui.autocomplete.filter(availableTags, request.term);
      if (!results.length) {
        noResultFinder.addClass('is-hide');
      } else {
        noResultFinder.removeClass('is-hide');
      }
      response(results);
      $.ajax({
        url: '/analysis/search/live',
        dataType: 'json',
        method: 'GET',
        data: {
          term: request.term
        },
        success: function(data) {
          results = $.ui.autocomplete.filter(data.list, request.term);
          if (!results.length) {
            noResultFinder.addClass('is-hide');
          } else {
            noResultFinder.removeClass('is-hide');
          }
          return response(results);
        }
      });
      if (!($('.js-finder-autocomplete').val().length >= 2)) {
        noResultFinder.removeClass('is-hide');
      }
    }
  });
});

$(".js-index-autocomplete").each(function() {
  var _jScrollPane, _jScrollPaneAPI, _jSheight, complete, dotText, searchHidden;
  complete = $(this);
  dotText = complete.children('.js-search-title');
  searchHidden = complete.siblings('.search-result');
  _jScrollPane = void 0;
  _jScrollPaneAPI = void 0;
  _jSheight = 250;
  jQuery.ui.autocomplete.prototype._resizeMenu = function() {
    var ul;
    ul = this.menu.element;
    ul.outerWidth(this.element.outerWidth());
  };
  complete.autocomplete({
    minLength: 2,
    open: function() {
      $(this).data('uiAutocomplete').menu.element.addClass('index-autocomplete js-lists');
      if (void 0 !== _jScrollPane) {
        _jScrollPaneAPI.destroy();
      }
      if ($('.index-autocomplete').height() <= _jSheight) {
        $('.index-autocomplete > li').wrapAll($('<ul class="scroll-panel"></ul>').css('height', 'auto'));
      } else {
        $('.index-autocomplete > li').wrapAll($('<ul class="scroll-panel"></ul>').height(_jSheight));
        _jScrollPane = $('.scroll-panel').jScrollPane();
        _jScrollPaneAPI = _jScrollPane.data('jsp');
      }
      $(this).data('uiAutocomplete').menu.element.find('.js-search-title').addClass('bla');
      return $(this).data('uiAutocomplete').menu.element.find('.js-search-title').dotdotdot({
        height: 36,
        lines: 2,
        responsive: true
      });
    },
    close: function(event, ui) {
      _jScrollPane = void 0;
    },
    focus: function(event, ui) {
      return false;
    },
    select: function(event, ui) {
      $(this).val(ui.item.label);
      return false;
    },
    source: function(request, response) {
      $.ajax({
        url: '/analysis/search/live/index-search.json',
        dataType: 'json',
        method: 'GET',
        data: {
          term: request.term
        },
        success: function(data) {
          var noResult, results;
          results = $.ui.autocomplete.filter(data.projects, request.term);
          noResult = complete.siblings('.no-results-finder');
          if (!results.length) {
            noResult.show();
          } else {
            noResult.hide();
          }
          return response(results);
        }
      });
      if (!($(".js-index-autocomplete").val().length >= 3)) {
        searchHidden.hide('slow');
      }
    }
  });
  complete.data("ui-autocomplete")._renderItem = function(ul, item) {
    var $img, $li, newText;
    $li = $('<li>');
    $img = $('<img>');
    newText = String(item.value).replace(new RegExp(this.term, 'gi'), '<span class=\'ui-menu-item-highlight\'>$&</span>');
    $img.attr({
      src: 'i/new-search/' + item.icon,
      alt: item.label
    });
    $li.attr('data-value', item.label);
    $li.addClass('top-list__item');
    $li.append('<a href="#" class="top-list__item-link">');
    $li.find('.top-list__item-link').append('<div class="top-list__picture">');
    $li.find('.top-list__picture').append($img);
    $li.find('.top-list__item-link').append('<div class="top-list__left">');
    $li.find('.top-list__left').append('<div class="top-list__title">');
    $li.find('.top-list__title').data('item.autocomplete', item).append('<a href="#" class="js-search-title">' + newText + '</a>');
    $li.find('.top-list__item-link').append('<div class="top-list__right">');
    $li.find('.top-list__right').append('<div class="top-list__subject">');
    $li.find('.top-list__subject').append(item.desc);
    return $li.appendTo(ul);
  };
  complete.on("click", function() {
    searchHidden.show();
    return $('.top-list__title').dotdotdot({
      lines: 2,
      responsive: true
    });
  });
  $('.js-static-search').on("click", '.top-list__item', function() {
    var completeThis, thisItem, thisText;
    thisItem = $(this).find('.top-list__title');
    thisText = $(this).find('.top-list__title').text();
    completeThis = $(this).parents('.search-result').siblings(".js-index-autocomplete");
    completeThis.val(thisText);
    return searchHidden.hide();
  });
  return complete.on('click', function() {
    if ($(this).val().length) {
      return searchHidden.hide();
    } else {
      return searchHidden.show();
    }
  });
});

$(document).mouseup(function(e) {
  var container;
  container = $('.search-result');
  if (container.has(e.target).length === 0) {
    container.hide();
  }
});

$('.top-list__title').dotdotdot({
  lines: 2,
  responsive: true
});

$('body').on('click', function() {
  var noResult;
  noResult = $('.no-results-finder');
  return noResult.hide();
});

$(".js-index-autocomplete").on('keyup', function() {
  var _this, noResult;
  _this = $(this);
  if (_this.val().length < 3) {
    noResult = _this.siblings('.no-results-finder');
    return noResult.hide();
  }
});

$(document).on('click', '.js-select-scroll', function() {
  var list;
  list = $('.js-select-scroll').find('.select7__drop-list');
  if (!list.hasClass('jspScrollable')) {
    list.addClass('jspScrollable');
    list.addClass('js-lists');
    list.jScrollPane();
  }
});

$('body').on('scroll', '.location', function(e) {
  return e.stopPropagation();
});

if ($(document).height() <= $(window).height()) {
  $(".container-fluid_footer-bg").addClass("sticky-footer");
}

if (window.matchMedia('screen and (max-width: 767px)').matches) {
  $('.js-tab__mobile-f').addClass('js-tab__header-f');
}

$('.js-tab__header-f').click(function() {
  var item, parent;
  parent = $(this).parent(".js-tab__parent-index");
  item = parent.children('.js-content_hide-index');
  item.slideToggle('fast');
  item.toggleClass('tab-active_info-index');
  parent.find('.btn__mobile').toggleClass('btn__mobile_open');
  $(this).toggleClass('tab__header_open');
  return false;
});

var $goTop, SHOW_GOTOP_AFTER, goTopShown;

SHOW_GOTOP_AFTER = 500;

$goTop = $(".go-top");

$goTop.toggle(goTopShown = $(window).scrollTop() > SHOW_GOTOP_AFTER);

$goTop.click(function() {
  $('html,body').animate({
    scrollTop: 0
  }, 800);
  return false;
});

$(window).scroll(function() {
  if (!goTopShown && $(window).scrollTop() > SHOW_GOTOP_AFTER) {
    $goTop.stop(true, true).fadeIn("fast");
    return goTopShown = true;
  } else if (goTopShown && $(window).scrollTop() <= SHOW_GOTOP_AFTER) {
    $goTop.stop(true, true).fadeOut("fast");
    return goTopShown = false;
  }
});

var myFunctionResize;

$(function() {
  var updateGroup1, updateGroup2;
  updateGroup1 = function() {
    return $(".x-check-group1").toggle($(".x-check-group1-toggle").prop("checked"));
  };
  updateGroup1();
  $(".x-check-group1-toggle").change(updateGroup1);
  updateGroup2 = function() {
    return $(".x-check-group2").toggle($(".x-check-group2-toggle").prop("checked"));
  };
  updateGroup2();
  return $(".x-check-group2-toggle").change(updateGroup2);
});

$('.bs-modal-md').on('show.bs.modal', function(e) {
  setTimeout(function() {
    $('.js-list-scroll').jScrollPane({
      autoReinitialise: true
    });
  }, 10);
});

myFunctionResize = function() {
  var api, pane;
  pane = $('.js-list-scroll');
  pane.jScrollPane();
  api = pane.data('jsp');
  api.reinitialise();
};

$(".dropdown__btn").on("click", function() {
  if ($(window).width() < 560) {
    setTimeout(function() {
      myFunctionResize();
    }, 15);
  }
});

$(window).resize(function() {
  myFunctionResize();
});

$("#select-area-diagnostics").on("click", "li a", function() {
  return $("#select-area-diagnostics").modal("hide");
});

$(window).scroll(function() {
  if (window.matchMedia('screen and (min-width: 768px)').matches) {
    if ($(window).scrollTop() > 50) {
      $('.navbar-fixed-top').addClass('navbar-main_slide');
    } else {
      $('.navbar-fixed-top').removeClass('navbar-main_slide');
    }
    return;
  }
});

if (window.matchMedia('screen and (max-width: 767px)').matches) {
  $('.navbar-fixed-top').addClass('navbar-main_slide');
}

$(window).on('scroll', function() {
  if ($('.header .select7_open').length) {
    if ($(window).scrollTop() >= 50) {
      $(".header .select7").trigger('click');
    }
  }
  if ($('.navbar-fixed-top .select7_open').length) {
    if ($(window).scrollTop() <= 50) {
      return $(".navbar-fixed-top .select7").trigger('click');
    }
  }
});

var galleryOption, gallerySlider, gallerySlider2, gallerySlider3, sliderOption;

galleryOption = {
  thumbnail: true,
  animateThumb: false,
  showThumbByDefault: true,
  currentPagerPosition: 'left',
  thumbWidth: 40,
  thumbContHeight: 100,
  toogleThumb: false,
  exThumbImage: 'data-exthumbimage',
  width: '825px',
  height: '600px',
  mode: 'lg-fade',
  download: false,
  enableSwipe: false,
  enableDrag: false,
  ubHtmlSelectorRelative: true
};

sliderOption = {};

lightGallery(document.getElementById('js-lightgallery'), galleryOption);

lightGallery(document.getElementById('js-lightgallery2'), galleryOption);

lightGallery(document.getElementById('js-lightgallery3'), galleryOption);

gallerySlider = $(".js-light-slider").lightSlider({
  slideMargin: 0,
  loop: false,
  item: 4,
  autoWidth: false,
  controls: true,
  pager: false,
  adaptiveHeight: true,
  responsive: [
    {
      breakpoint: 1200,
      settings: {
        item: 3,
        slideMove: 1,
        slideMargin: 0
      }
    }, {
      breakpoint: 700,
      settings: {
        item: 2,
        slideMove: 1
      }
    }, {
      breakpoint: 440,
      settings: {
        item: 1,
        slideMove: 1
      }
    }
  ]
});

gallerySlider2 = $(".js-light-slider2").lightSlider({
  slideMargin: 0,
  loop: false,
  item: 4,
  autoWidth: false,
  controls: true,
  pager: false,
  adaptiveHeight: true,
  responsive: [
    {
      breakpoint: 1200,
      settings: {
        item: 3,
        slideMove: 1,
        slideMargin: 0
      }
    }, {
      breakpoint: 700,
      settings: {
        item: 2,
        slideMove: 1
      }
    }, {
      breakpoint: 440,
      settings: {
        item: 1,
        slideMove: 1
      }
    }
  ]
});

gallerySlider3 = $(".js-light-slider3").lightSlider({
  slideMargin: 0,
  loop: false,
  item: 4,
  autoWidth: false,
  controls: true,
  pager: false,
  adaptiveHeight: true,
  responsive: [
    {
      breakpoint: 1200,
      settings: {
        item: 3,
        slideMove: 1,
        slideMargin: 0
      }
    }, {
      breakpoint: 700,
      settings: {
        item: 2,
        slideMove: 1
      }
    }, {
      breakpoint: 440,
      settings: {
        item: 1,
        slideMove: 1
      }
    }
  ]
});

$('body').on('click', '.js-slider-refresh', function() {
  console.log('bla');
  gallerySlider.refresh();
  gallerySlider2.refresh();
  return gallerySlider3.refresh();
});

$(document).ready(function() {
  $('.js-tab-container').each(function() {
    $(this).find('.js-tab-link').first().addClass('active');
    $(this).find('.js-tab-block').first().addClass('active');
    return $('.js-tab-link').on('click', function() {
      var id;
      id = $(this).data('id');
      $('.js-tab-link').removeClass('active');
      $('.js-tab-block').removeClass('active');
      $('.js-tab-block[data-block="' + id + '"]').addClass('active');
      $(this).addClass('active');
      if ($(window).width() < 768) {
        $('html, body').animate({
          scrollTop: $('.js-scrollto').offset().top
        }, 1000);
      }
      return false;
    });
  });
});

$(".js-autocomplete-doc").each(function() {
  var availableTags;
  availableTags = ['Аллерголог', 'Андролог', 'Анестезиолог', 'Венеролог', 'Вертебролог', 'Гастроэнтеролог', 'Гематолог', 'Генетик', 'Дерматолог', 'Диетолог', 'Иммунолог', 'Кардиолог', 'Кинезитерапевт', 'Логопед', 'Маммолог', 'Нарколог', 'Невролог', 'Ортопед', 'Педиатр', 'Подолог', 'Ревматолог', 'Терапевт'];
  return $('.js-autocomplete-doc').autocomplete({
    source: availableTags
  });
});

$(".js-autocomplete-clinic").each(function() {
  var availableTags;
  availableTags = ['Инсайт Медикал', 'Саперная слободка', 'Исида', 'Феврония Клинская', 'Валерия Ильинишна Колмагорова', 'Феврония Клинская', 'Добробут'];
  return $('.js-autocomplete-clinic').autocomplete({
    source: availableTags
  });
});

$(".phones__item_life").hover(function() {
  $(this).toggleClass("phones__item_hover");
  return $(".phones__list").find(".phones__item_life").toggleClass("phones__item_hover");
});

$(".phones__item_mts").hover(function() {
  $(this).toggleClass("phones__item_hover");
  return $(".phones__list").find(".phones__item_mts").toggleClass("phones__item_hover");
});

$(".phones__item_kyivstar").hover(function() {
  $(this).toggleClass("phones__item_hover");
  return $(".phones__list").find(".phones__item_kyivstar").toggleClass("phones__item_hover");
});

$(".phones__item_civic").hover(function() {
  $(this).toggleClass("phones__item_hover");
  return $(".phones__list").find(".phones__item_civic").toggleClass("phones__item_hover");
});

$(function() {
  if (window.matchMedia('screen and (min-width: 768px)').matches) {
    $(".js-phones").find(".phones__toggle").addClass("js-phones-btn");
    $(".js-phones-btn").click(function() {
      var _parent, _this;
      _this = $(this);
      _parent = _this.parents(".js-phones");
      if (_parent.find(".js-phones-list").hasClass("phones__list_block")) {
        return true;
      } else {
        _this.addClass("phones__toggle_open");
        _parent.find(".js-phones-list").addClass("phones__list_block");
        return false;
      }
    });
    return $(document).on("click", function() {
      $(".js-phones-list").removeClass("phones__list_block");
      return $(".js-phones-btn").removeClass("phones__toggle_open");
    });
  }
});

$(function() {
  if (window.matchMedia('screen and (max-width: 767px)').matches) {
    $(".js-phones").addClass("js-phones-btn");
    $(".js-phones-btn").click(function() {
      var _this;
      _this = $(this);
      if (_this.find(".js-phones-list").hasClass("phones__list_block")) {
        return true;
      } else {
        _this.find(".phones__toggle").addClass("phones__toggle_open");
        _this.find(".js-phones-list").addClass("phones__list_block");
        return false;
      }
    });
    return $(document).on("click", function() {
      $(".js-phones-list").removeClass("phones__list_block");
      return $(".phones__toggle").removeClass("phones__toggle_open");
    });
  }
});

var galleryCount, generateMarkupForOwlCarousel, initOwlCarousel, syncOwlCarousels;

galleryCount = 1;

generateMarkupForOwlCarousel = function(items, opts) {
  var generateImg, html, item, j, k, l, len, len1, len2;
  html = "";
  generateImg = function(src) {
    if (!opts.simpleThumbs) {
      return "<img data-src=\"" + src + "\" alt=\"\" class=\"lazyOwl\"/>";
    } else {
      return "<img src=\"" + src + "\" alt=\"\"/>";
    }
  };
  if (!opts.owlbox) {
    html += "<ul class=\"photo-gallery__images\">";
    for (j = 0, len = items.length; j < len; j++) {
      item = items[j];
      html += "<li class=\"photo-gallery__image item\">\n	" + (generateImg(item.big)) + "\n	" + (item.title ? '<div class="photo-gallery__image-caption">' + item.title + '</div>' : '') + "\n</li>";
    }
    html += "</ul>";
    html += "<ul class=\"photo-gallery__thumbs\">";
    for (k = 0, len1 = items.length; k < len1; k++) {
      item = items[k];
      html += "<li class=\"photo-gallery__thumb item\">\n	" + (generateImg(item.thumb)) + "\n</li>";
    }
    html += "</ul>";
  } else {
    html += "<ul class=\"photo-gallery__thumbs\">";
    for (l = 0, len2 = items.length; l < len2; l++) {
      item = items[l];
      html += "<li class=\"photo-gallery__thumb item\">\n	<a href=\"" + item.big + "\" class=\"owlbox\" rel=\"gallery-" + galleryCount + "\" " + (item.title ? 'title="' + item.title + '"' : '') + ">\n		" + (generateImg(item.thumb)) + "\n	</a>\n</li>";
    }
    html += "</ul>";
  }
  if (!opts.owlbox) {
    html += "<div class=\"photo-gallery__counter\">\n	<span class=\"photo-gallery__counter-current\">1</span> из <span class=\"photo-gallery__counter-total\">" + items.length + "</span>\n</div>";
  }
  return html;
};

syncOwlCarousels = function(sync1, sync2) {
  var center;
  center = function(number) {
    var found, i, num, sync2visible;
    if (!sync2.data("owlCarousel")) {
      return;
    }
    sync2visible = sync2.data("owlCarousel").visibleItems;
    if (!sync2visible) {
      return;
    }
    num = number;
    found = false;
    for (i in sync2visible) {
      if (num === sync2visible[i]) {
        found = true;
      }
    }
    if (found === false) {
      if (num > sync2visible[sync2visible.length - 1]) {
        return sync2.trigger("owl.goTo", num - sync2visible.length + 2);
      } else {
        if (num - 1 === -1) {
          num = 0;
        }
        return sync2.trigger("owl.goTo", num);
      }
    } else if (num === sync2visible[sync2visible.length - 1]) {
      return sync2.trigger("owl.goTo", sync2visible[1]);
    } else {
      if (num === sync2visible[0]) {
        return sync2.trigger("owl.goTo", num - 1);
      }
    }
  };
  sync1.on("owl.afterAction", function(e, owl) {
    var current;
    current = owl.currentItem;
    sync2.find(".photo-gallery__thumb_current").removeClass("photo-gallery__thumb_current");
    sync2.find(".photo-gallery__thumb").eq(current).addClass("photo-gallery__thumb_current");
    return center(current);
  });
  return sync2.on("click", ".owl-item", function(e) {
    e.preventDefault();
    return sync1.trigger("owl.goTo", $(this).data("owlItem"));
  });
};

initOwlCarousel = function(container, items, opts) {
  var $images, $thumbs;
  $(container).prepend(generateMarkupForOwlCarousel(items, opts));
  $thumbs = $(container).find(".photo-gallery__thumbs");
  if (!opts.owlbox) {
    $images = $(container).find(".photo-gallery__images");
    syncOwlCarousels($images, $thumbs);
    $images.owlCarousel({
      singleItem: true,
      lazyLoad: true,
      pagination: false,
      navigation: true,
      navigationText: ["", ""],
      slideSpeed: 394,
      afterAction: function(el) {
        $(el).trigger("owl.afterAction", this);
        return $(container).find(".photo-gallery__counter-current").text(this.currentItem + 1);
      },
      afterInit: function(el) {
        return $(el).trigger("owl.afterInit", this);
      }
    });
  }
  if (!opts.simpleThumbs) {
    return $thumbs.owlCarousel({
      items: 5,
      itemsTablet: [979, 6],
      itemsMobile: [767, 2],
      lazyLoad: true,
      pagination: false,
      navigation: true,
      navigationText: ["", ""],
      slideSpeed: 394,
      scrollPerPage: true,
      afterAction: function(el) {
        return $(el).trigger("owl.afterAction", this);
      },
      afterInit: function(el) {
        return $(el).trigger("owl.afterInit", this);
      }
    });
  }
};

$.fn.makeCustomPhotoGallery = function(_opts) {
  if (_opts == null) {
    _opts = {};
  }
  return this.each(function() {
    var $img, $items, item, items, opts;
    opts = $.extend({}, _opts);
    items = opts.items;
    if (!items) {
      $items = $(this).find("ul a[href]");
      items = (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = $items.length; j < len; j++) {
          item = $items[j];
          $img = $(item).find("img");
          results.push({
            thumb: $(item).attr("data-src") || $img.attr("src"),
            big: $(item).attr("href"),
            title: $(item).attr("title")
          });
        }
        return results;
      })();
      $(this).find("ul").remove();
    }
    if (!opts.owlbox) {
      opts.owlbox = $(this).hasClass("photo-gallery_owlbox");
    }
    if (!opts.simpleThumbs) {
      opts.simpleThumbs = $(this).hasClass("photo-gallery_simple-thumbs");
    }
    initOwlCarousel(this, items, opts);
    $(this).on({
      "photoGallery.next": (function(_this) {
        return function() {
          return $(_this).find(".photo-gallery__images").trigger("owl.next");
        };
      })(this),
      "photoGallery.prev": (function(_this) {
        return function() {
          return $(_this).find(".photo-gallery__images").trigger("owl.prev");
        };
      })(this)
    });
    $(this).addClass("photo-gallery_initialized");
    return galleryCount++;
  });
};

$(function() {
  return $(".photo-gallery").makeCustomPhotoGallery();
});

$(document).on("change", ".pill-group .pill input", function(e) {
  var $childrenPills, $parentPill, $pill, $pillsGroup, allChecked, checked;
  $pill = $(e.target).closest(".pill");
  checked = $(e.target).is(":checked");
  $childrenPills = $pill.siblings("ul").find(".pill");
  if ($childrenPills.length > 0) {
    return $childrenPills.find("input").prop("checked", checked);
  } else {
    $parentPill = $pill.closest("ul").siblings(".pill");
    if ($parentPill.length === 1) {
      $pillsGroup = $parentPill.siblings("ul").find(".pill");
      allChecked = $pillsGroup.length === $pillsGroup.find(":checked").length;
      return $parentPill.find("input").prop("checked", allChecked);
    }
  }
});

var postLocationWidthFix;

postLocationWidthFix = function() {
  return $(".post").each(function() {
    var locationValueWidth, locationWidth, px;
    if ($(this).hasClass("post_single")) {
      if ($(window).width() > 767) {
        locationWidth = $(this).find(".post__footer").width() - $(this).find(".post__price").width() - $(this).find(".post__submits").width() - 10;
        locationValueWidth = locationWidth - 35;
        px = "px";
      } else {
        locationWidth = 'auto';
        locationValueWidth = 245;
        px = '';
      }
    } else {
      if (($(window).width() > 979) || ($(window).width() < 768)) {
        locationWidth = $(this).find(".post__footer").width() - $(this).find(".post__price").width() + 10;
        locationValueWidth = locationWidth - 35;
        px = "px";
      } else {
        locationWidth = 'auto';
        if ($(this).closest(".widget").length) {
          locationValueWidth = 130;
        } else {
          locationValueWidth = 180;
        }
        px = '';
      }
    }
    $(this).find(".post__location").attr('style', "width: " + locationWidth + px + " !important");
    $(this).find(".post__location-title").css({
      maxWidth: locationValueWidth + "px"
    });
    return $(this).find(".select7__current-value").css({
      maxWidth: locationValueWidth + "px"
    });
  });
};

$(window).resize(postLocationWidthFix);

$(document).on("shown.bs.tab", postLocationWidthFix);

postLocationWidthFix();



$('.js-truncate').dotdotdot({
  lines: 2,
  responsive: true
});

$(function() {
  return $(".price-block_collapse .price-block__header").on("click", function() {
    return $(this).closest(".price-block").toggleClass("price-block_collapse_open");
  });
});

$(document).on('click', '.js-offers-btn', function() {
  var changeText, drop, getAttr, getText, getTextAttr;
  drop = $(this).parents('.js-offers-tabs').find('.js-offers-content');
  changeText = $(this).children('.dotted');
  getAttr = changeText.data('hidden');
  getText = changeText.text();
  getTextAttr = changeText.data('name');
  drop.slideToggle('fast');
  $(this).parents('.js-offers-tabs').toggleClass('is-active');
  changeText.toggleClass('is-change');
  if (changeText.hasClass('is-change')) {
    changeText.attr("data-name", getText);
    changeText.text(getAttr);
  } else {
    changeText.text(getTextAttr);
  }
  return false;
});

$(function() {
  $('.js-search-btn').click(function() {
    if ($('.js-form').hasClass('is-search-open')) {
      return true;
    } else {
      $('.js-form').addClass('is-search-open');
      return false;
    }
  });
  $('.js-search-input').focus(function() {
    if ($('.js-form').hasClass('is-search-active')) {
      return true;
    } else {
      $('.js-form').addClass('is-search-active');
      return false;
    }
  });
  $(document).on("click", function() {
    return $(".js-form").removeClass("is-search-active");
  });
  $(document).on("click", function() {
    return $(".js-form").removeClass("is-search-open");
  });
  return $('.js-form').on("click", function(e) {
    return e.stopPropagation();
  });
});

var flags;

flags = true;

$('.js-location-lists').on('click', function() {
  var list, paneHeight;
  list = $(this).children('.js-lists');
  paneHeight = 216;
  list.show();
  if (list.height() <= paneHeight) {
    list.css('height', 'auto');
    list.css('padding', '0');
  } else {
    list.height(paneHeight);
    list.jScrollPane();
    $(this).addClass('is-active');
    return;
  }
  flags = false;
});

$('body').on('click', '.js-lists-item', function() {
  var changeText, parent, value;
  changeText = $(this).closest('.js-lists').siblings('.finder__field-text');
  parent = $(this).closest('.js-lists');
  value = $(this).text();
  changeText.val(value);
  $(this).addClass('is-active');
  changeText.addClass('is-change');
  parent.hide();
  return flags = true;
});

$(document).mouseup(function(e) {
  var container;
  container = $('.js-lists');
  if (container.has(e.target).length === 0) {
    container.hide();
  }
});

$("#select-area").on("areaSelected", function(e, arg) {
  var title, value, values;
  values = arg.values;
  title = ((function() {
    var i, len, results;
    results = [];
    for (i = 0, len = values.length; i < len; i++) {
      value = values[i];
      results.push(value.title);
    }
    return results;
  })()).join(", ");
  value = ((function() {
    var i, len, results;
    results = [];
    for (i = 0, len = values.length; i < len; i++) {
      value = values[i];
      results.push(value.value);
    }
    return results;
  })()).join(", ");
  $(".js-services-go [data-target='#select-area']").parent().find('.finder__field-text:last').val(values.length > 0 ? title : $(".js-services-go [data-target='#select-area'] .finder__field-text").data("emptyText")).toggleClass("grey", values.length === 0);
  return $("#select-area").modal("hide");
});

var smallCardInit;

smallCardInit = function() {
  var c, w, windowWidth;
  windowWidth = $(window).width();
  c = "small-card__job_fixmargin";
  if (windowWidth < 768) {
    $(".small-card__job").removeClass(c);
    return;
  }
  w = windowWidth < 980 ? 235 : 400;
  return $(".small-card__job strong").each(function() {
    return $(this).closest(".small-card__job").toggleClass(c, $(this).width() > w);
  });
};

$(window).resize(smallCardInit);

smallCardInit();

$("body").on("smallCardInit", smallCardInit);

(function() {
  var $bodyMap, $commonPill, $skinPill, IE, detailed, gender, map, otherZoneClickHandler, refreshView, selectZone, selected, setGender, side, toggleDetailed, toggleSide, unselectZones, zones;
  $bodyMap = void 0;
  $commonPill = void 0;
  $skinPill = void 0;
  IE = void 0;
  detailed = void 0;
  gender = void 0;
  map = void 0;
  otherZoneClickHandler = void 0;
  refreshView = void 0;
  selectZone = void 0;
  selected = void 0;
  setGender = void 0;
  side = void 0;
  toggleDetailed = void 0;
  toggleSide = void 0;
  unselectZones = void 0;
  zones = void 0;
  $bodyMap = $('.body-map');
  IE = !!top.execScript;
  $bodyMap.toggleClass('body-map_ie', IE);
  if ($bodyMap.length > 0 && $('.body-map__container').length > 0) {
    $commonPill = $bodyMap.find('[data-zone-id=\'common\']');
    $skinPill = $bodyMap.find('[data-zone-id=\'skin\']');
    gender = 'man';
    side = 'front';
    detailed = false;
    map = null;
    selected = null;
    zones = {};
    refreshView = function() {
      var $el, _i, _len, _ref, createZone, resetCss, svgFile, svgFileKey, zone;
      $el = void 0;
      createZone = void 0;
      resetCss = void 0;
      svgFile = void 0;
      svgFileKey = void 0;
      zone = void 0;
      _i = void 0;
      _len = void 0;
      _ref = void 0;
      if (map) {
        map.remove();
        map = null;
      }
      if (detailed) {
        resetCss = {
          top: '-10%',
          left: '-15%'
        };
      } else {
        resetCss = {
          top: 0,
          left: '50%'
        };
      }
      $el = $bodyMap.find('.body-map__main').panElement('destroy').css(resetCss).removeClass('body-map__main_detailed').hide().filter('.body-map__main_' + gender + '_' + side).show().toggleClass('body-map__main_detailed', detailed);
      svgFileKey = '' + gender + '-' + side + (detailed ? '-detailed' : '');
      svgFile = SVG_FILES[svgFileKey];
      map = Raphael($el.find('.body-map__zones')[0]);
      map.setViewBox(svgFile.viewbox[0], svgFile.viewbox[1], svgFile.viewbox[2], svgFile.viewbox[3], true);
      map.setSize('100%', '100%');
      unselectZones();
      zones = {};
      createZone = function(zone) {
        var _len;
        var _i;
        var clicking, path, pathList, pathString;
        clicking = void 0;
        path = void 0;
        pathList = void 0;
        pathString = void 0;
        _i = void 0;
        _len = void 0;
        pathList = (function() {
          var _ref;
          var _len;
          var _i;
          var _results;
          _i = void 0;
          _len = void 0;
          _ref = void 0;
          _results = void 0;
          if (zone.path) {
            return [map.path(zone.path)];
          } else if (zone.pathList) {
            _ref = zone.pathList;
            _results = [];
            _i = 0;
            _len = _ref.length;
            while (_i < _len) {
              pathString = _ref[_i];
              _results.push(map.path(pathString));
              _i++;
            }
            return _results;
          } else {
            throw new Error('invalid zone ' + JSON.stringify(zone));
          }
        })();
        while (_i < _len) {
          path = pathList[_i];
          path.attr({
            zoneId: zone.id,
            'stroke-width': 0,
            fill: '#ff4c4c',
            cursor: 'pointer',
            opacity: 0
          });
          path.mouseover(function() {
            var _j, _len1, p;
            p = void 0;
            _j = void 0;
            _len1 = void 0;
            if (zone.id !== selected) {
              _j = 0;
              _len1 = pathList.length;
              while (_j < _len1) {
                p = pathList[_j];
                p.attr({
                  opacity: 0.5
                });
                _j++;
              }
            }
            return $bodyMap.trigger('mouseoverZone', {
              gender: gender,
              side: side,
              detailed: detailed,
              zoneId: zone.id
            });
          });
          path.mouseout(function() {
            var _j, _len1, p;
            p = void 0;
            _j = void 0;
            _len1 = void 0;
            if (zone.id !== selected) {
              _j = 0;
              _len1 = pathList.length;
              while (_j < _len1) {
                p = pathList[_j];
                p.attr({
                  opacity: 0
                });
                _j++;
              }
            }
            return $bodyMap.trigger('mouseoutZone', {
              gender: gender,
              side: side,
              detailed: detailed,
              zoneId: zone.id
            });
          });
          clicking = false;
          path.mousedown(function() {
            return clicking = true;
          });
          path.mousemove(function() {
            return clicking = false;
          });
          path.mouseup(function(e) {
            var $m, offset, offsetX, offsetY;
            $m = void 0;
            offset = void 0;
            offsetX = void 0;
            offsetY = void 0;
            if (!clicking) {
              return;
            }
            $m = $bodyMap.find('.body-map__main:visible');
            offset = $m.offset();
            offsetX = e.offsetX || e.pageX - offset.left;
            offsetY = e.offsetY || e.pageY - offset.top;
            return $bodyMap.trigger('clickZone', {
              gender: gender,
              side: side,
              detailed: detailed,
              zoneId: zone.id,
              offset: {
                left: offsetX,
                top: offsetY
              },
              size: {
                width: $m.width(),
                height: $m.height()
              }
            });
          });
          _i++;
        }
        return zones[zone.id] = pathList;
      };
      _ref = svgFile.zones;
      _i = 0;
      _len = _ref.length;
      while (_i < _len) {
        zone = _ref[_i];
        createZone(zone);
        _i++;
      }
      if (detailed) {
        return $el.panElement();
      }
    };
    unselectZones = function() {
      var _i, _len, id, p, pathList;
      id = void 0;
      p = void 0;
      pathList = void 0;
      _i = void 0;
      _len = void 0;
      $skinPill.prop('checked', false);
      $commonPill.prop('checked', false);
      for (id in zones) {
        id = id;
        pathList = zones[id];
        _i = 0;
        _len = pathList.length;
        while (_i < _len) {
          p = pathList[_i];
          p.attr({
            opacity: 0
          });
          _i++;
        }
      }
      return selected = null;
    };
    selectZone = function(id) {
      unselectZones();
      setTimeout((function() {
        var _i, _len, _ref, _results, p;
        p = void 0;
        _i = void 0;
        _len = void 0;
        _ref = void 0;
        _results = void 0;
        switch (id) {
          case 'common':
            return $commonPill.prop('checked', true);
          case 'skin':
            return $skinPill.prop('checked', true);
          default:
            _ref = zones[id];
            _results = [];
            _i = 0;
            _len = _ref.length;
            while (_i < _len) {
              p = _ref[_i];
              _results.push(p.attr({
                opacity: 0.5
              }));
              _i++;
            }
            return _results;
        }
      }), 1);
      return selected = id;
    };
    setGender = function() {
      gender = (function() {
        switch ($bodyMap.find('.body-map__select [name=\'gender\']:checked').val()) {
          case 'male':
            return 'man';
          case 'female':
            return 'woman';
          default:
            throw new Error('invalid gender');
        }
      })();
      return refreshView();
    };
    toggleSide = function() {
      side = side === 'front' ? 'back' : 'front';
      return refreshView();
    };
    toggleDetailed = function() {
      detailed = !detailed;
      $bodyMap.find('.body-map__zoom').toggleClass('body-map__zoom_out', detailed);
      return refreshView();
    };
    $bodyMap.find('.body-map__select [name=\'gender\']').change(function() {
      setGender();
      return $bodyMap.trigger('selectGender', {
        gender: gender
      });
    });
    $bodyMap.find('.body-map__rotate').click(function() {
      toggleSide();
      return $bodyMap.trigger('selectSide', {
        side: side
      });
    });
    $bodyMap.find('.body-map__zoom').click(function() {
      toggleDetailed();
      return $bodyMap.trigger('selectDetailed', {
        detailed: detailed
      });
    });
    $bodyMap.on('selectZone', function(e, o) {
      return selectZone(o.zoneId);
    });
    otherZoneClickHandler = function(e) {
      $bodyMap.trigger('clickZone', {
        zoneId: $(this).data('zoneId'),
        gender: gender,
        detailed: detailed,
        side: side
      });
      e.stopPropagation();
      e.preventDefault();
      return false;
    };
    $commonPill.click(otherZoneClickHandler);
    $skinPill.click(otherZoneClickHandler);
    $bodyMap.on('clickZone', function(event, o) {
      var $c, $d, _ref;
      $c = void 0;
      $d = void 0;
      _ref = void 0;
      if ((_ref = o.zoneId) === 'common' || _ref === 'skin' || o.detailed) {
        return $bodyMap.trigger('selectZone', {
          zoneId: o.zoneId
        });
      } else {
        toggleDetailed();
        $d = $bodyMap.find('.body-map__main_detailed');
        $c = $d.parent();
        return $bodyMap.find('.body-map__main').css({
          top: '' + Math.min(0, Math.max($c.height() - $d.height(), -($d.height() - $c.height()) / 2 + (0.5 - (o.offset.top / o.size.height)) * $d.height())) + 'px',
          left: '' + Math.min(0, Math.max($c.width() - $d.width(), -($d.width() - $c.width()) / 2 + (0.5 - (o.offset.left / o.size.width)) * $d.width())) + 'px'
        });
      }
    });
    setGender();
  }
}).call(this);

$('.js-tooltip').tooltip();

$('.js-city-close').on('click', function(e) {
  var block;
  block = $(this).closest('.your-city');
  block.addClass('is-hide');
  e.stopPropagation();
  return false;
});

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

$(function() {
  var $scrollDiv, $selectCollapse, $setDatePickerLang, $tabLink, findTitle, formatResult, formatSelection, href, mobileCss, pagination, postLoadHeight, ref, refreshChildrenAgesSelector, scrollbarWidth, shhack;
  $.fn.applyRegularScript = function() {
    return this.find(".phone-input-mask").inputmask({
      mask: "+38 (999) 999-99-99",
      onBeforeMask: function(value, opts) {
        return value.replace(/^38/g, '');
      },
      onBeforePaste: function(value, opts) {
        return value.replace(/^38/g, '');
      }
    });
  };
  $('body').applyRegularScript();
  pagination = function() {
    var paginationWidth;
    $(".pagination").removeAttr('style');
    paginationWidth = 0;
    $(".pagination li").each(function() {
      return paginationWidth += $(this).outerWidth(true);
    });
    return $(".pagination").width(paginationWidth + 5);
  };
  pagination();
  postLoadHeight = function() {
    if ($(window).width() < 560) {
      return $('.post-load').height(180);
    } else {
      return $('.post-load').height($('.post-load').parent().prev().find('.post').height() - 14);
    }
  };
  postLoadHeight();
  $('.navbar-main .navbar-toggle').on("click", function(e) {
    $('.navbar-mobile').slideToggle(300);
    return $('body').toggleClass('lock');
  });
  $("body").prepend($scrollDiv = $("<div>").css({
    width: "100px",
    height: "100px",
    overflow: "scroll",
    position: "absolute",
    top: "-9999px"
  }));
  scrollbarWidth = $scrollDiv.get(0).offsetWidth - $scrollDiv.get(0).clientWidth;
  $scrollDiv.remove();
  if ($('.blog-diseases h2, .blog-diseases h3').length > 0) {
    $('<div class="disease-subTitle js-nav"></div><ul class="disease-subTitle__list"></ul></div>').insertAfter($('.disease-content header:not(.sr-only)').first());
    $.each($('.blog-diseases h2, .blog-diseases h3, .after-content-title p'), function(index, val) {
      if ($(this).text()) {
        return $('.disease-subTitle__list').append('<li class="disease-subTitle__item first-child"><a class="disease-subTitle__link" href="#">' + $(this).text() + '</a></li>');
      }
    });
    if ('.list-view.tomenu'.length > 0) {
      findTitle = $('.list-view.tomenu').prev().text().replace(/^\S+/, '').replace(/^\s/, '');
      $('.disease-subTitle__list').append('<li><a href="#">' + findTitle + '</a></li>');
    }
    $('.main-content').on('click', '.disease-subTitle__list a', function(e) {
      var offsetY;
      offsetY = void 0;
      offsetY = void 0;
      offsetY = $('h2:contains(\'' + $(this).text() + '\'), h3:contains(\'' + $(this).text() + '\'), p:contains(\'' + $(this).text() + '\')').offset().top;
      if ($(window).width() < 768) {
        offsetY -= 40;
      } else {
        offsetY -= 50;
      }
      return $('html,body').animate({
        scrollTop: offsetY
      }, 300);
    });
  }
  $("body").on("click", "[data-toggle='class']", function(e) {
    var $el, absSelector, className, ref;
    $el = $(e.target).is("[data-toggle='class']") ? $(e.target) : $(e.target).closest("[data-toggle='class']");
    ref = $el.data(), absSelector = ref.absSelector, className = ref.className;
    if (absSelector && className) {
      $(absSelector).toggleClass(className);
      return e.preventDefault();
    } else {
      return console.log("Incorrect [data-toggle='class'] usage. Please set data-abs-selector, data-class-name.");
    }
  });
  $('body').on("click", ".dropdown:not(.dropdown_clickable) .dropdown-menu__item", function(e) {
    var $cv, $dd, html, value;
    e.preventDefault();
    $dd = $(e.target).closest(".dropdown");
    $cv = $dd.find(".dropdown-current__value");
    if (!$dd.is(".dropdown-static")) {
      value = $(e.target).data('value');
      html = $(e.target).html();
      $(this).html($cv.html()).data('value', $cv.data('value'));
      $cv.html(html).data('value', value);
      return $dd.trigger("dropdown-change", value);
    }
  });
  $(".dropdown:not(.dropdown-noopts)").each(function() {
    return $(this).toggleClass("dropdown-noopts", $(this).find(".dropdown-menu__item").length === 0);
  });
  $("#select-area-districts").on("columnagram.columnized", function(e, opts) {
    $(this).attr("data-columnagram-column-count", opts.columns);
    if (opts.columns === 1) {
      return $("#select-area-districts .columnize > div").css({
        float: "none",
        width: "50%",
        marginLeft: "auto",
        marginRight: "auto"
      });
    }
  });
  $(".columnize").each(function() {
    var adaptiveColumnCount, columns, minColumnWidth, opts, ref;
    ref = $(this).data(), columns = ref.columns, minColumnWidth = ref.minColumnWidth, adaptiveColumnCount = ref.adaptiveColumnCount;
    opts = {
      columns: columns
    };
    opts.minColumnWidth = (minColumnWidth != null) || 160;
    if (adaptiveColumnCount) {
      opts.limitColumnCount = function(c) {
        var w;
        w = $(window).width();
        if (w < 768) {
          c = 1;
        } else if (w < 980 && c > 3) {
          c = 3;
        }
        return c;
      };
    }
    opts.columns || (opts.columns = 4);
    opts.columns = Math.min(opts.columns, $(this).children().length);
    $(this).on("columnagram.columnized", function(e, eventData) {
      return $(this).addClass("columnized").attr("data-columnagram-column-count", opts.columns);
    });
    return $(this).columnagram(opts);
  });
  mobileCss = function() {
    return $('.navbar-mobile').css({
      top: $('.navbar-main').height()
    });
  };
  mobileCss();
  $(window).resize(function() {
    postLoadHeight();
    pagination();
    $(".columnize").columnagram('recolumnize');
    if ($(window).width() > 768) {
      $('.footer-sub-menu').removeAttr('style');
    }
    return mobileCss();
  });
  $(document).on("shown.bs.tab", function(e) {
    var tabSelector;
    tabSelector = $(e.target).attr("href");
    if ($(tabSelector).find('.pagination').length > 0) {
      pagination();
    }
    return $(tabSelector).find(".columnize").each(function() {
      return $(this).columnagram('recolumnize');
    });
  });
  $(document).on("show.bs.modal", function(e) {
    return $(e.target).css({
      display: "block"
    }).find(".columnize").each(function() {
      return $(this).columnagram('recolumnize');
    });
  });
  $(".odd-even").each(function() {
    return $(this).children().each(function() {
      return $(this).addClass($(this).index() % 2 ? "even" : "odd");
    });
  });
  $("ul").each(function() {
    return $(this).find("> li:last").addClass("last-child");
  });
  $("ul").each(function() {
    return $(this).find("> li:first").addClass("first-child");
  });
  $(".owl").each(function() {
    var data, opts;
    data = $(this).data();
    opts = {
      navigation: true,
      pagination: false,
      navigationText: ["", ""],
      rewindNav: false,
      lazyLoad: true,
      itemsDesktop: false,
      itemsDesktopSmall: false,
      itemsTablet: false,
      itemsTabletSmall: false,
      itemsMobile: false
    };
    if ($(this).is('.owl_single')) {
      opts.singleItem = true;
    } else {
      opts.items = data.itemsCount || 8;
    }
    if ($(this).is(".owl_schedule")) {
      opts.items = 7;
      opts.itemsTablet = [979, 4];
      opts.itemsMobile = [767, 2];
    }
    if ($(this).is(".owl_action")) {
      opts.items = 1;
      opts.pagination = true;
      opts.itemsTablet = [979, 2];
      opts.itemsMobile = [768, 1];
    }
    if ($(this).is(".gallery")) {
      opts.items = 4;
      opts.itemsTablet = [979, 5];
      opts.itemsMobile = [767, 2];
    }
    if ($(this).is(".top-list-carousel")) {
      opts.itemsTablet = [979, 4];
      opts.itemsMobile = [767, 1];
    }
    return $(this).owlCarousel(opts);
  });
  $.fn.ratingStars = function() {
    var getAllPrev;
    getAllPrev = function(star) {
      var $stars;
      $stars = $(star).parent().find('>*');
      return $stars.slice(0, $stars.index($(star)));
    };
    $.each(this, function() {
      $(this).hover(function() {
        return $(this).add(getAllPrev(this)).addClass('hover');
      }, function() {
        return $(this).add(getAllPrev(this)).removeClass('hover');
      });
      $(this).click(function() {
        $(this).siblings().removeClass('active');
        $(this).add(getAllPrev(this)).addClass('active');
        return $(this).find(':radio').get(0).checked = true;
      });
      return $(this).find(":radio:checked").parent().trigger('click');
    });
    return this;
  };
  $(".rating__stars li").ratingStars();
  $("[data-toggle='tooltip']").tooltip({
    container: 'body'
  }, $(".wrap").tooltip("hide"));
  $("[data-toggle='tooltip-metro']").tooltip({
    container: false
  });
  $("a[href^='#']").click(function(e) {
    var $tabLink, href;
    href = $(this).attr('href');
    $tabLink = $("a[data-toggle='tab'][href='" + href + "']");
    if ($tabLink.length > 0) {
      $tabLink.tab("show");
      return e.preventDefault();
    }
  });
  if (((ref = window.location.hash) != null ? ref[0] : void 0) === '#') {
    href = window.location.hash.split('/');
    $tabLink = $("a[data-toggle='tab'][href='" + href[0] + "']");
    if ($tabLink.length > 0) {
      $tabLink.tab("show");
    }
    if (href.length === 2) {
      window.scrollTo(0, $("#" + href[1]).offset().top);
    }
  }
  $(document).on("reinitSelect2", function(e) {
    var $select;
    $select = $(e.target);
    $select.select2({
      dropdownCssClass: $select.data('dropdownClass'),
      searchInputPlaceholder: $select.data('searchPlaceholder'),
      matcher: function(term, text) {
        return text.toUpperCase().indexOf(term.replace(/_/g, "").toUpperCase()) === 0;
      }
    });
    $select.on('select2-open', function(e) {
      var $container, $el, $searchField, dropdownMask;
      $el = $(e.target);
      dropdownMask = $el.data('dropdownMask');
      $searchField = $el.data('select2').search;
      $container = $el.data('select2').container;
      $container.css('max-width', $container.parent().width());
      if (dropdownMask) {
        $searchField.inputmask({
          mask: dropdownMask
        });
      }
      if (dropdownMask === "99:99") {
        return $searchField.on('keypress.mask keydown.mask', function(e) {
          var v, x1, x2, y1;
          $searchField = $(e.target);
          v = $searchField.val();
          x1 = parseInt(v.substring(0, 1));
          if (x1 > 2) {
            v = '0' + x1 + v.substring(2, 5);
            $searchField.val(v.replace(/:|_/g, ""));
          }
          x2 = parseInt(v.substring(0, 2));
          if (x2 > 23) {
            v = '23' + v.substring(2, 5);
            $searchField.val(v.replace(/:|_/g, ""));
          }
          y1 = parseInt(v.substring(3, 4));
          if (y1 > 5) {
            v = v.substring(0, 2) + '5' + v.substring(4, 5);
            return $searchField.val(v.replace(/:|_/g, ""));
          }
        });
      }
    });
    return $select.on('select2-close', function(e) {
      var $el, $searchField;
      $el = $(e.target);
      return $searchField = $el.data('select2').search;
    });
  });
  $(document).on("reinitSelect7", function(e) {
    return $(e.target).select7();
  });
  $('.select2').trigger("reinitSelect2");
  $('.select7').trigger("reinitSelect7");
  $setDatePickerLang = function(s) {
    switch (s) {
      case 'uk':
        return $.extend($.fn.pickadate.defaults, {
          monthsFull: ['Січня', 'Лютого', 'Березня', 'Квітня', 'Травня', 'Червня', 'Липня', 'Серпня', 'Вересня', 'Жовтня', 'Листопада', 'Грудня'],
          monthsShort: ['Січ', 'Лют', 'Бер', 'Кві', 'Трі', 'Чер', 'Лип', 'Сер', 'Вер', 'Жов', 'Лис', 'Гру'],
          weekdaysFull: ['неділя', 'понеділок', 'вівторок', 'середа', 'четвер', 'п‘ятниця', 'субота'],
          weekdaysShort: ['нд', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'],
          today: 'сьогодні',
          clear: 'викреслити'
        });
      default:
        return $.extend($.fn.pickadate.defaults, {
          monthsFull: ['Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря'],
          monthsShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
          weekdaysFull: ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
          weekdaysShort: ['вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'],
          today: 'сегодня',
          clear: 'удалить'
        });
    }
  };
  $('.birthdaypicker').each(function() {
    var displayFormat, setLang, submitFormat, val;
    val = $(this).val();
    if (val) {
      $(this).data('value', val);
    }
    submitFormat = $(this).data('dateFormatSubmit') || 'yyyy-mm-dd';
    displayFormat = $(this).data('dateFormatDisplay') || 'dd.mm.yyyy';
    setLang = $(this).data('lang');
    $setDatePickerLang(setLang);
    return $(this).pickadate({
      format: displayFormat,
      formatSubmit: submitFormat,
      hiddenName: true,
      selectYears: 100,
      selectMonths: true,
      firstDay: 1,
      min: [1934, 1, 1],
      max: new Date(),
      clear: '',
      today: '',
      labelMonthNext: '',
      labelMonthPrev: '',
      labelMonthSelect: '',
      labelYearSelect: '',
      onRender: function() {
        var highlight, highlightedData, isOpen, value;
        $(this.$root).find("select").trigger("reinitSelect7");
        isOpen = this.get('open');
        highlight = this.get('highlight', submitFormat);
        value = this.get('select', submitFormat);
        highlightedData = this.get('highlight');
        if ((highlight !== value) && isOpen) {
          return this.set("select", highlightedData);
        }
      }
    });
  });
  $(".password-eye").click(function() {
    $(this).siblings("input[type=text], input[type=password]").each(function() {});
    return $(this).prev().attr("type", ($(this).prev().attr("type") === "password" ? "text" : "password"));
  });
  $('.scroll-pane').jScrollPane({
    autoReinitialise: true
  });
  $("#symptoms-select").on({
    change: function(e) {
      var v;
      v = e.val || $("#symptoms-select").select2("val");
      return $("#symptoms-list-selector li").each(function() {
        var ref1;
        return $(this).toggleClass("symptoms__list-item_selected", (ref1 = "" + ($(this).data("value")), indexOf.call(v, ref1) >= 0));
      });
    }
  });
  $("#symptoms-list-selector").on("click", "li", function() {
    var v;
    v = $("#symptoms-select").select2("val");
    if ($(this).is(".symptoms__list-item_selected")) {
      v.splice(v.indexOf("" + ($(this).data("value"))), 1);
    } else {
      v.push("" + ($(this).data("value")));
    }
    return $("#symptoms-select").select2("val", v).trigger("change");
  });
  $("#symptoms-list-selector").empty();
  $("#symptoms-select").find("option").each(function() {
    return $("#symptoms-list-selector").append($("<li></li>").addClass("symptoms__list-item").data("value", "" + ($(this).attr("value"))).text($(this).text()));
  });
  $(".owlbox").owlbox();
  $("[data-action='clone']").click(function() {
    var $clone, $cloneSource, cloneSelector;
    cloneSelector = $(this).data().cloneSelector;
    $cloneSource = $(cloneSelector);
    $cloneSource.find(".select2").select2("destroy");
    $clone = $cloneSource.clone();
    $clone.insertAfter($cloneSource);
    $clone.find("input:not([type='checkbox'], [type='radio']), select, textarea").val("");
    $clone.find(":checked").prop("checked", false);
    $cloneSource.add($clone).find(".select2").trigger("reinitSelect2");
    return false;
  });
  refreshChildrenAgesSelector = function() {
    var val;
    val = $("#field-personal-children-quantity").val();
    $("[data-for-children-count='one']").toggle(val === "one" || val === "two" || val === "three" || val === "more");
    $("[data-for-children-count='two']").toggle(val === "two" || val === "three" || val === "more");
    $("[data-for-children-count='three']").toggle(val === "three" || val === "more");
    return $("[data-for-children-count='more']").toggle(val === "more");
  };
  $("#field-personal-children-quantity").change(refreshChildrenAgesSelector);
  if ($("#field-personal-children-quantity").length > 0) {
    refreshChildrenAgesSelector();
  }
  $("body").on("click", "[data-doctor-request-set-time]", function(e) {
    var hours, minutes, time;
    time = parseInt($(e.target).attr("data-doctor-request-set-time"));
    hours = Math.floor(time / 60);
    minutes = time % 60;
    if (hours < 10) {
      hours = "0" + hours;
    }
    if (minutes < 10) {
      minutes = "0" + minutes;
    }
    time = hours + ":" + minutes;
    return $("#doctor-request-time-select, .time-select").val(time).trigger("change");
  });
  $("body").on("click", "[data-doctor-request-set-date]", function(e) {
    return $("#doctor-request-date-input").pickadate("picker").set("select", parseInt($(e.target).attr("data-doctor-request-set-date")));
  });
  $("body").on({
    "show.bs.modal": function() {
      if (scrollbarWidth > 0 && $("body").height() > $(window).height()) {
        return $("html").css({
          paddingRight: scrollbarWidth + "px"
        });
      }
    },
    "hidden.bs.modal": function() {
      return $("html").css({
        paddingRight: ""
      });
    }
  });
  $("ul.nav li.active").each(function() {
    var $pp;
    $pp = $(this).parent().parent();
    if ($pp.is("li")) {
      return $pp.addClass("active");
    }
  });
  window.openNotification = function(title, content) {
    $("#notification .modal-title").text(title);
    $("#notification .modal-body").html(content);
    return $("#notification").modal("show");
  };
  $(document).on("openNotification", function(event, title, content) {
    return openNotification(title, content);
  });
  $(document).on("focusin", ".has-error", function(e) {
    var $el;
    $el = $(e.target).is(".has-error") ? $(e.target) : $(e.target).closest(".has-error");
    return $el.removeClass("has-error");
  });
  $.fn.sameHeightHack = function() {
    var processChunk, processSameHeightHack;
    processChunk = function(chunk) {
      var i, maxHeight, minHeight;
      minHeight = Math.min.apply(Math, (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = chunk.length; j < len; j++) {
          i = chunk[j];
          results.push($(i).outerHeight());
        }
        return results;
      })());
      if (minHeight === 0) {
        return;
      }
      maxHeight = Math.max.apply(Math, (function() {
        var j, len, results;
        results = [];
        for (j = 0, len = chunk.length; j < len; j++) {
          i = chunk[j];
          results.push($(i).outerHeight());
        }
        return results;
      })());
      return $(chunk).css({
        height: maxHeight + "px"
      });
    };
    processSameHeightHack = function() {
      var chunk, lastTop;
      this.css({
        height: ""
      });
      lastTop = null;
      chunk = null;
      this.each(function() {
        if (lastTop !== $(this).offset().top) {
          if (chunk) {
            processChunk(chunk);
          }
          lastTop = $(this).offset().top;
          return chunk = [this];
        } else {
          return chunk.push(this);
        }
      });
      if ((chunk != null ? chunk.length : void 0) > 0) {
        processChunk(chunk);
        return chunk = null;
      }
    };
    return processSameHeightHack.call(this);
  };
  shhack = function() {
    return $(".same-height").sameHeightHack();
  };
  $(shhack);
  $(document).on("shown.bs.modal", shhack);
  $(document).on("shown.bs.tab", shhack);
  $(window).resize(shhack);
  $(".registration input[type='radio']").on("change", shhack);
  if (location.hash && location.hash !== "" && $(location.hash).hasClass("modal")) {
    $(location.hash).modal("show");
  }
  $(document).on("click", "a[href^='#tab-doctors']", function(e) {
    return $(window).scrollTo($("#tab-doctors"), 500, {
      offset: -100
    });
  });
  $(document).on("click", ".scroll-to", function(e) {
    var selector, yPos;
    selector = $(e.currentTarget).attr('href') || $(e.currentTarget).data('href');
    if ($(window).width() > 768) {
      yPos = $(selector).offset().top - $('.navbar-main').outerHeight(true);
    } else {
      yPos = $(selector).offset().top;
    }
    $('html,body').animate({
      scrollTop: yPos
    }, 400);
    return false;
  });
  $('body').scrollspy({
    target: '.page-sidebar'
  });
  formatResult = function(item) {
    var descr, itemData, itemTitle, r;
    if (!item.id) {
      itemData = item.element[0].dataset;
      r = "<div class='price-item'>";
      r += "<span class='price-item__title'>" + item.text + "</span>";
      if (itemData.description) {
        descr = "(" + itemData.description + ")";
      } else {
        descr = '';
      }
      r += "&nbsp;<span class='price-item__description'>" + descr + "</span>";
      if (itemData.price) {
        r += "<span class='price-item__aside'><span class='price-item__value'>" + itemData.price + "</span></span>";
      }
      r += "</div>";
      return r;
    }
    itemData = item.element[0].dataset;
    itemTitle = itemData.label ? itemData.label : item.text;
    r = "<div class='price-item'>";
    r += "<span class='price-item__title'><span class='sr-only'>" + item.text + "</span>" + itemTitle + "</span>";
    if (itemData.description) {
      descr = "(" + itemData.description + ")";
    } else {
      descr = '';
    }
    r += "&nbsp;<span class='price-item__description'>" + descr + "</span>";
    if (itemData.price) {
      r += "<span class='price-item__aside'><span class='price-item__value'>" + itemData.price + "</span></span>";
    }
    if (itemData.actionTitle) {
      r += "<div class='price-item__action'><strong>Акция! </strong><a href=" + itemData.actionLink + ">" + itemData.actionTitle + "</a></div>";
    }
    r += "</div>";
    return r;
  };
  formatSelection = function(item) {
    var descr, itemData, r;
    itemData = item.element[0].dataset;
    r = "<div class='price-item'>";
    r += "<div class='price-item__body'>";
    r += "<span class='price-item__title'>" + item.text + "</span>";
    if (itemData.description) {
      descr = "(" + itemData.description + ")";
    } else {
      descr = '';
    }
    r += "&nbsp;<span class='price-item__description'>" + descr + "</span>";
    r += "</div>";
    if (itemData.price) {
      r += "<span class='price-item__aside'><span class='price-item__value'>" + itemData.price + "</span></span>";
    }
    r += "</div>";
    return r;
  };
  $selectCollapse = $('.select-prices');
  $selectCollapse.select2({
    tags: $selectCollapse.data('tags'),
    formatResult: formatResult,
    formatSelection: formatSelection,
    dropdownCssClass: 'show-search select2-collapse'
  });
  $selectCollapse.on("change", function(e) {
    var $selectCollapseEl;
    $selectCollapseEl = $(e.target).data('select2');
    return $selectCollapseEl.container.css('max-width', $selectCollapseEl.container.closest('form').width());
  });
  return $selectCollapse.on("select2-open", function(e) {
    var $dropdown, $selectCollapseEl;
    $selectCollapseEl = $(e.target).data('select2');
    $selectCollapseEl.container.css('max-width', $selectCollapseEl.container.closest('form').width());
    $selectCollapseEl.onSelect = (function(fn) {
      return function(data, options) {
        var target;
        if (options) {
          target = $(options.target);
        }
        if (target && target.is('a')) {
          return window.location.href = target.attr('href');
        } else {
          return fn.apply(this, arguments);
        }
      };
    })($selectCollapseEl.onSelect);
    $dropdown = $($selectCollapseEl.dropdown[0]);
    $dropdown.find('.select2-highlighted').parent().parent().addClass('select2-collapse-open');
    return $dropdown.find('.select2-result-with-children>.select2-result-label').each(function() {
      $(this).parent().addClass('select2-collapsed');
      return $(this).click(function() {
        return $(this).parent().toggleClass('select2-collapse-open');
      });
    });
  });
});

var docMaps;

docMaps = {
  icon1: typeof exports !== "undefined" && exports !== null ? exports : 'i/pin.png',
  icon2: typeof exports !== "undefined" && exports !== null ? exports : 'i/pin-active.png',
  addNewMarker: '',
  city: '',
  pageName: '',
  mapOffsetTop: 0,
  canAnimateTop: true,
  popupMarker: '',
  pageName: '',
  markersList: [],
  allItemsList: [],
  map: {},
  geocoder: {},
  cardId: 0,
  domain: '',
  initialize: function(allItemsList, pageName, city, domain) {
    var latlng, mapOptions;
    this.allItemsList = allItemsList;
    this.city = city;
    this.domain = domain;
    this.pageName = pageName;
    this.geocoder = new google.maps.Geocoder;
    latlng = new google.maps.LatLng(-50.446, -30.515);
    mapOptions = {
      zoom: 10,
      maxZoom: 10,
      center: latlng,
      scrollwheel: false,
      disableDefaultUI: true,
      disableDoubleClickZoom: true,
      panControl: false
    };
    if (this.pageName === 'map') {
      this.mapCss.bigMap();
      this.map = new google.maps.Map(document.getElementById('map-canvas-big'), mapOptions);
      this.listeners.common(this.map);
      return this.newScope();
    } else {
      docMaps.mapOffsetTop = $('.widget-map').offset().top;
      this.map = new google.maps.Map(document.getElementById('map-canvas-right'), mapOptions);
      if (this.pageName === 'doctorInner' || this.pageName === 'clinicInner' || this.pageName === 'diagnostCenter' || this.pageName === 'actionAbout' || this.pageName === 'claInner') {
        this.mapCss.inner();
      } else {
        this.mapCss.index();
        $(window).scroll(function() {
          return docMaps.mapCss.index();
        });
        this.listeners.common(this.map);
      }
      this.newScope();
      return this.mapModal();
    }
  },
  newScope: function(list) {
    if (list) {
      this.allItemsList = list;
    }
    if (this.pageName === 'doctorInner' || this.pageName === 'diagnostCenter' || this.pageName === 'actionAbout') {
      this.addNewMarker = this.addMarker.inner();
      return this.addNewMarker();
    } else if (this.pageName === 'diagnostList') {
      this.addNewMarker = this.addMarker.diagnost();
      return this.addNewMarker();
    } else if (this.pageName === 'action') {
      this.addNewMarker = this.addMarker.actions();
      return this.addNewMarker();
    } else if (this.pageName === 'cla') {
      this.addNewMarker = this.addMarker.actions();
      return this.addNewMarker();
    } else {
      this.addNewMarker = this.addMarker.clinics();
      return this.addNewMarker();
    }
  },
  scrollInit: function() {
    var scrollObj;
    if (this.scrollApi) {
      this.scrollApi.destroy();
      this.scrollApi = '';
    }
    scrollObj = $('.short-list__items-wrapper');
    scrollObj.width($('.big-map__widget').width());
    scrollObj.height(this.mapHeight - $('.short-list__header').outerHeight(true) - 500);
    return this.scrollApi = scrollObj.jScrollPane({
      verticalGutter: 0,
      verticalDragMaxHeight: 30
    }).data().jsp;
  },
  loadDoctors: function(filter, filterValue) {
    $('.short-list__items').html('');
    return $.ajax({
      url: 'https://' + docMaps.domain + '/api/doctor/doctors?' + filter + '=' + filterValue,
      data: {},
      success: function(data) {
        var d, i, j, ref, tpl;
        for (i = j = 0, ref = data.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
          d = data[4];
          tpl = '<li class="short-list__item"> <div class="male short-list__image"><img src="' + 'https://' + docMaps.domain + d.image + '" alt=""> </div>' + '<div class="short-list__item-content"><a href="/doctor-consultation.html" title="' + d.name + '" class="short-list__title">' + d.name + '</a>' + '<div class="short-list__label">' + d.specialty + '</div> <div class="rating"> <div class="rating__stars"> <div class="rating__stars-bg"> </div> <div style="width: ' + d.rating * 20 + '%;" class="rating__stars-overlay"> </div> </div> <div class="rating__value value">' + d.rating + ' </div> </div> </div> </li>';
          $('.short-list__items').append(tpl);
        }
        return $('.short-list__items-wrapper').scrollInit();
      }
    });
  },
  mapModal: function() {
    var geocoder, latlng, map, mapOptions;
    geocoder = new google.maps.Geocoder;
    latlng = new google.maps.LatLng(-50.446, -30.515);
    mapOptions = {
      zoom: 10,
      center: latlng
    };
    map = new google.maps.Map(document.getElementById('modal-map'), mapOptions);
    return $('#clinic-location-map').on('shown.bs.modal', function(e) {
      var addInfo, contentString, index, infowindow;
      index = docMaps.findMarker('id', $(e.relatedTarget).closest("[data-id]").data('id'));
      contentString = '<div class="map-marker-content"> <div class="image"><img src="i/_isida.jpg" class="marker-logo"></div> <a href="/clinic-inner.html" class="title">ИСИДА</a> <div class="card__address">' + '<span>ул. Теодора Драйзера, 4</span></div> <div class="rating"> <div class="rating__value value">3</div> <div class="rating__stars"> <div class="rating__stars-bg"></div> <div style="width: ' + '%;" class="rating__stars-overlay"></div> </div> </div><a href="#" class="marker-review"> 17 отзыва</a><div class="big-map__button"><a href="#clinic-request" data-toggle="mod al" class="btn btn-success">Записаться в клинику</a></div></div>';
      infowindow = new google.maps.InfoWindow({
        content: contentString,
        maxWidth: 200,
        zIndex: 10011
      });
      addInfo = {};
      if (docMaps.markersList[index].addInfo.affilate) {
        addInfo.address = docMaps.markersList[index].addInfo.affilate.address;
      } else {
        addInfo.address = docMaps.markersList[index].addInfo.address;
      }
      docMaps.popupMarker = new google.maps.Marker({
        map: map,
        icon: docMaps.icon2,
        position: docMaps.markersList[index].position
      });
      docMaps.fitMap([docMaps.popupMarker], map, 14);
      return google.maps.event.addListener(docMaps.popupMarker, 'click', function() {
        infowindow.open(map, docMaps.popupMarker);
        return setTimeout((function() {
          var gmEl;
          gmEl = $('.map-marker-content').closest('.gm-style-iw');
          gmEl.parent().addClass('marker-window');
          $('.marker-window').clone().insertAfter($('.marker-window'));
          $('.marker-window').first().remove();
          $('.marker-window .gm-style-iw').css({
            'width': 220
          });
          $('.marker-window').children().find('.card__address').css({
            'font-size': 14
          });
          $('.marker-window').children().find('.title').css({
            'font-size': 15
          });
          $('.marker-window').children().find('.rating__value').css({
            'font-size': 19
          });
          $('.marker-window').children().find('.marker-review').css({
            'font-size': 16
          });
          $('.marker-window .gm-style-iw>div').eq(0).css({
            'width': 220,
            'max-width': 220
          });
          $('.marker-window .gm-style-iw>div').eq(0).addClass('is-active');
          return $('.marker-window .gm-style-iw>div>div').eq(0).addClass('is-active');
        }), 400);
      });
    });
  },
  mapCss: {
    index: function() {
      var mapHeight, navbarHeight;
      navbarHeight = $('.navbar-main').outerHeight();
      if (docMaps.mapOffsetTop - $(window).scrollTop() < 0) {
        $('#map-canvas-right, .widget-map').height($(window).height() - navbarHeight - 30);
        $('.widget-map').css({
          position: 'fixed',
          top: '60px'
        }, $('.widget-map').width($('.widget-map').parent('aside').width()));
        if ($(document).height() <= $(document).scrollTop() + $(window).height() + $('.row.footer').outerHeight(true) + $('.row-articles').outerHeight(true) + 120 - parseInt($('.main-content aside').css('margin-top'))) {
          docMaps.canAnimateTop = true;
          $('aside').height($('aside').prev().height() - parseInt($('.main-content aside').css('margin-top')));
          $('.widget-map').css({
            position: 'absolute',
            bottom: 20,
            top: 'auto'
          });
        } else {
          if (docMaps.canAnimateTop) {
            docMaps.canAnimateTop = false;
            $('.widget-map').animate({
              top: navbarHeight + 20
            });
          }
        }
      } else {
        mapHeight = ($('#map-canvas-right').position().top + $(window).scrollTop()) + ($(window).height() - ($('.container-header').outerHeight() + $('.container-menu').outerHeight() + ($('.container-finder').outerHeight() + 50) + 115));
        docMaps.canAnimateTop = true;
        $('#map-canvas-right, .widget-map').height(mapHeight);
        $('.widget-map').css({
          position: 'relative',
          top: '0'
        });
      }
      return $(window).resize(function() {
        $('.widget-map').width($('.widget-map').parent('aside').width());
      });
    },
    inner: function() {
      if (docMaps.pageName === 'clinicInner' || docMaps.pageName === 'actionAbout' || docMaps.pageName === 'claInner') {
        return $('#map-canvas-right, .widget-map').height(600);
      } else {
        $('#map-canvas-right, .widget-map').height($('.card').outerHeight(true));
        return $('#map-canvas-right, .widget-map').css('border-radius', '4px');
      }
    },
    bigMap: function() {
      docMaps.mapHeight = $(window).height() - $('header.header').outerHeight(true) - $('.header__nav').outerHeight(true);
      docMaps.scrollInit();
      $('#map-canvas-big').height(docMaps.mapHeight);
      if ($(window).width() <= 767) {
        docMaps.mapHeight = $(window).height() - $('.navbar').outerHeight(true) - $('.short-list__header').outerHeight(true);
        return $('#map-canvas-big').height(docMaps.mapHeight);
      }
    }
  },
  addMarker: {
    clinics: function() {
      var affilateIndex, clinicIndex;
      clinicIndex = 0;
      affilateIndex = -1;
      return function() {
        var addInfo, address;
        if (clinicIndex < this.allItemsList.length) {
          addInfo = {};
          if (clinicIndex === 0) {
            addInfo.active = true;
          } else {
            addInfo.active = false;
          }
          addInfo.name = this.allItemsList[clinicIndex].name;
          addInfo.id = clinics[clinicIndex].id;
          addInfo.image = this.allItemsList[clinicIndex].image;
          if (this.allItemsList[clinicIndex].affilates) {
            if (affilateIndex === -1) {
              affilateIndex = 0;
            }
            addInfo.affilate = this.allItemsList[clinicIndex].affilates[affilateIndex];
            address = this.allItemsList[clinicIndex].affilates[affilateIndex].address;
            if (affilateIndex === this.allItemsList[clinicIndex].affilates.length - 1) {
              affilateIndex = -1;
              clinicIndex += 1;
            } else {
              affilateIndex += 1;
            }
          } else {
            address = this.allItemsList[clinicIndex].address;
            addInfo.directions = this.allItemsList[clinicIndex].directions;
            addInfo.address = this.allItemsList[clinicIndex].address;
            addInfo.reviews = this.allItemsList[clinicIndex].reviews;
            addInfo.rating = this.allItemsList[clinicIndex].rating;
            clinicIndex += 1;
          }
          address += ' ' + this.city;
          return this.geocoder.geocode({
            'address': address
          }, function(results, status) {
            var icon, marker;
            if (status === google.maps.GeocoderStatus.OK) {
              if (addInfo.active && !docMaps.pageName === 'map') {
                icon = docMaps.icon2;
              } else {
                icon = docMaps.icon1;
              }
              marker = new google.maps.Marker({
                map: docMaps.map,
                icon: icon,
                addInfo: addInfo,
                position: results[0].geometry.location
              });
              docMaps.markersList.push(marker);
              docMaps.listeners.marker(marker, docMaps.map);
              if (addInfo.active) {
                docMaps.map.setCenter(marker.getPosition());
              }
              return docMaps.addNewMarker();
            } else {
              return console.log('Geocode was not successful for the following reason: ' + status);
            }
          });
        }
      };
    },
    inner: function() {
      var index;
      index = 0;
      return function() {
        var addInfo;
        if (index < this.allItemsList.length) {
          addInfo = this.allItemsList[index];
          this.geocoder.geocode({
            'address': addInfo.address + ' ' + this.city
          }, function(results, status) {
            var marker;
            if (status === google.maps.GeocoderStatus.OK) {
              marker = new google.maps.Marker({
                map: docMaps.map,
                icon: docMaps.icon1,
                addInfo: addInfo,
                position: results[0].geometry.location
              });
              docMaps.markersList.push(marker);
              docMaps.listeners.marker(marker, docMaps.map);
              return docMaps.addNewMarker();
            } else {
              return console.log('Geocode was not successful for the following reason: ' + status);
            }
          });
          return index++;
        } else {
          return docMaps.fitMap(docMaps.markersList, docMaps.map);
        }
      };
    },
    diagnost: function() {
      var affilateIndex, clinicIndex;
      clinicIndex = 0;
      affilateIndex = -1;
      return function() {
        var addInfo, address;
        if (clinicIndex < this.allItemsList.length) {
          addInfo = {};
          if (clinicIndex === 0) {
            addInfo.active = true;
          } else {
            addInfo.active = false;
          }
          addInfo.name = this.allItemsList[clinicIndex].name;
          addInfo.id = diagnost[clinicIndex].id;
          addInfo.image = this.allItemsList[clinicIndex].image;
          if (this.allItemsList[clinicIndex].affilates) {
            if (affilateIndex === -1) {
              affilateIndex = 0;
            }
            addInfo.affilate = this.allItemsList[clinicIndex].affilates[affilateIndex];
            address = this.allItemsList[clinicIndex].affilates[affilateIndex].address;
            if (affilateIndex === this.allItemsList[clinicIndex].affilates.length - 1) {
              affilateIndex = -1;
              clinicIndex += 1;
            } else {
              affilateIndex += 1;
            }
          } else {
            address = this.allItemsList[clinicIndex].address;
            addInfo.directions = this.allItemsList[clinicIndex].directions;
            addInfo.address = this.allItemsList[clinicIndex].address;
            addInfo.reviews = this.allItemsList[clinicIndex].reviews;
            addInfo.rating = this.allItemsList[clinicIndex].rating;
            clinicIndex += 1;
          }
          address += ' ' + this.city;
          return this.geocoder.geocode({
            'address': address
          }, function(results, status) {
            var icon, marker;
            if (status === google.maps.GeocoderStatus.OK) {
              if (addInfo.active && !docMaps.pageName === 'map') {
                icon = docMaps.icon2;
              } else {
                icon = docMaps.icon1;
              }
              marker = new google.maps.Marker({
                map: docMaps.map,
                icon: icon,
                addInfo: addInfo,
                position: results[0].geometry.location
              });
              docMaps.markersList.push(marker);
              docMaps.listeners.marker(marker, docMaps.map);
              if (addInfo.active) {
                docMaps.map.setCenter(marker.getPosition());
              }
              return docMaps.addNewMarker();
            } else {
              return console.log('Geocode was not successful for the following reason: ' + status);
            }
          });
        }
      };
    },
    actions: function() {
      var affilateIndex, clinicIndex;
      clinicIndex = 0;
      affilateIndex = -1;
      return function() {
        var addInfo, address;
        if (clinicIndex < this.allItemsList.length) {
          addInfo = {};
          if (clinicIndex === 0) {
            addInfo.active = true;
          } else {
            addInfo.active = false;
          }
          addInfo.name = this.allItemsList[clinicIndex].name;
          addInfo.id = actions[clinicIndex].id;
          addInfo.image = this.allItemsList[clinicIndex].image;
          if (this.allItemsList[clinicIndex].affilates) {
            if (affilateIndex === -1) {
              affilateIndex = 0;
            }
            addInfo.affilate = this.allItemsList[clinicIndex].affilates[affilateIndex];
            address = this.allItemsList[clinicIndex].affilates[affilateIndex].address;
            if (affilateIndex === this.allItemsList[clinicIndex].affilates.length - 1) {
              affilateIndex = -1;
              clinicIndex += 1;
            } else {
              affilateIndex += 1;
            }
          } else {
            address = this.allItemsList[clinicIndex].address;
            addInfo.directions = this.allItemsList[clinicIndex].directions;
            addInfo.address = this.allItemsList[clinicIndex].address;
            addInfo.reviews = this.allItemsList[clinicIndex].reviews;
            addInfo.rating = this.allItemsList[clinicIndex].rating;
            clinicIndex += 1;
          }
          address += ' ' + this.city;
          return this.geocoder.geocode({
            'address': address
          }, function(results, status) {
            var icon, marker;
            if (status === google.maps.GeocoderStatus.OK) {
              if (addInfo.active && !docMaps.pageName === 'map') {
                icon = docMaps.icon2;
              } else {
                icon = docMaps.icon1;
              }
              marker = new google.maps.Marker({
                map: docMaps.map,
                icon: icon,
                addInfo: addInfo,
                position: results[0].geometry.location
              });
              docMaps.markersList.push(marker);
              docMaps.listeners.marker(marker, docMaps.map);
              if (addInfo.active) {
                docMaps.map.setCenter(marker.getPosition());
              }
              return docMaps.addNewMarker();
            } else {
              return console.log('Geocode was not successful for the following reason: ' + status);
            }
          });
        }
      };
    },
    cla: function() {
      var affilateIndex, clinicIndex;
      clinicIndex = 0;
      affilateIndex = -1;
      return function() {
        var addInfo, address;
        if (clinicIndex < this.allItemsList.length) {
          addInfo = {};
          if (clinicIndex === 0) {
            addInfo.active = true;
          } else {
            addInfo.active = false;
          }
          addInfo.name = this.allItemsList[clinicIndex].name;
          addInfo.id = cla[clinicIndex].id;
          addInfo.image = this.allItemsList[clinicIndex].image;
          if (this.allItemsList[clinicIndex].affilates) {
            if (affilateIndex === -1) {
              affilateIndex = 0;
            }
            addInfo.affilate = this.allItemsList[clinicIndex].affilates[affilateIndex];
            address = this.allItemsList[clinicIndex].affilates[affilateIndex].address;
            if (affilateIndex === this.allItemsList[clinicIndex].affilates.length - 1) {
              affilateIndex = -1;
              clinicIndex += 1;
            } else {
              affilateIndex += 1;
            }
          } else {
            address = this.allItemsList[clinicIndex].address;
            addInfo.directions = this.allItemsList[clinicIndex].directions;
            addInfo.address = this.allItemsList[clinicIndex].address;
            addInfo.reviews = this.allItemsList[clinicIndex].reviews;
            addInfo.rating = this.allItemsList[clinicIndex].rating;
            clinicIndex += 1;
          }
          address += ' ' + this.city;
          return this.geocoder.geocode({
            'address': address
          }, function(results, status) {
            var icon, marker;
            if (status === google.maps.GeocoderStatus.OK) {
              if (addInfo.active && !docMaps.pageName === 'map') {
                icon = docMaps.icon2;
              } else {
                icon = docMaps.icon1;
              }
              marker = new google.maps.Marker({
                map: docMaps.map,
                icon: icon,
                addInfo: addInfo,
                position: results[0].geometry.location
              });
              docMaps.markersList.push(marker);
              docMaps.listeners.marker(marker, docMaps.map);
              if (addInfo.active) {
                docMaps.map.setCenter(marker.getPosition());
              }
              return docMaps.addNewMarker();
            } else {
              return console.log('Geocode was not successful for the following reason: ' + status);
            }
          });
        }
      };
    }
  },
  sideMarkerActivate: function(marker, map) {
    var offsetTop, yPos;
    docMaps.resetMarkers();
    marker.setIcon(docMaps.icon2);
    docMaps.fitMap([marker], map);
    if (marker.addInfo.affilate) {
      if (docMaps.pageName === 'diagnostCenter') {
        offsetTop = $("[data-id='" + marker.addInfo.affilate.id + "']").offset().top;
      } else {
        offsetTop = $("[data-id='" + marker.addInfo.affilate.id + "']").closest('.card').offset().top;
      }
    } else {
      offsetTop = $("[data-id='" + marker.addInfo.id + "']").offset().top;
    }
    yPos = offsetTop - $('.navbar-main').outerHeight() - 20;
    return $('html,body').animate({
      scrollTop: yPos
    }, 'slow');
  },
  resetMarkers: function() {
    return $.each(docMaps.markersList, function(index, value) {
      return docMaps.markersList[index].setIcon(docMaps.icon1);
    });
  },
  showInfoWindow: function(map, marker, tpl) {
    var contentString, infoWindow;
    contentString = '<div class="map-marker-content">' + tpl + '</div>';
    infoWindow = new google.maps.InfoWindow({
      content: contentString,
      maxWidth: 200,
      zIndex: 10011
    });
    $('.marker-window').remove();
    setTimeout((function() {
      return infoWindow.open(map, marker);
    }), 300);
    return setTimeout((function() {
      var gmEl;
      gmEl = $('.map-marker-content').closest('.gm-style-iw');
      gmEl.parent().addClass('marker-window');
      $('.marker-window').clone().insertAfter($('.marker-window'));
      $('.marker-window').first().remove();
      $('.marker-window .gm-style-iw').css({
        'width': 220
      });
      $('.marker-window').children().find('.card__address').css({
        'font-size': 14
      });
      $('.marker-window').children().find('.marker-review').css({
        'font-size': 16
      });
      $('.marker-window .gm-style-iw>div').eq(0).css({
        'width': 220,
        'max-width': 220
      });
      $('.marker-window .gm-style-iw>div').eq(0).addClass('is-active');
      return $('.marker-window .gm-style-iw>div>div').eq(0).addClass('is-active');
    }), 500);
  },
  listeners: {
    marker: function(marker, map) {
      var address, rating, reviews;
      if (marker.addInfo.affilate) {
        rating = marker.addInfo.affilate.rating;
        address = marker.addInfo.affilate.address;
        reviews = marker.addInfo.affilate.reviews;
      } else {
        rating = marker.addInfo.rating;
        address = marker.addInfo.address;
        reviews = marker.addInfo.reviews;
      }
      return google.maps.event.addListener(marker, 'click', function() {
        if (docMaps.pageName === 'map') {
          docMaps.showInfoWindow(map, marker, '<div class="image"><img src="' + marker.addInfo.image + '" class="marker-logo"></div> <a href="/clinic-inner.html" class="title">' + marker.addInfo.name + '</a> <div class="card__address">' + '<span>' + address + '</span></div> <div class="rating"> <div class="rating__value value">' + rating + '</div> <div class="rating__stars"> <div class="rating__stars-bg"></div> <div style="width: ' + rating * 20 + '%;" class="rating__stars-overlay"></div> </div> </div><a href="#" class="marker-review"> ' + reviews + ' отзыва</a><div class="big-map__button"><a href="#clinic-request" data-toggle="mod al" class="btn btn-success">Записаться в клинику</a></div>');
          map.panTo(marker.getPosition());
          docMaps.resetMarkers();
          return marker.setIcon(docMaps.icon2);
        } else if (docMaps.pageName === 'doctorInner') {
          return $('#clinic-location-map').modal();
        } else if (docMaps.pageName === 'actionAbout') {
          return $('#clinic-location-map').modal();
        } else if (docMaps.pageName === 'diagnostCenter') {
          return $('#clinic-location-map').modal();
        } else if (docMaps.pageName === 'claInner') {
          return $('#clinic-location-map').modal();
        } else {
          return docMaps.sideMarkerActivate(marker, map);
        }
      });
    },
    common: function(map) {
      google.maps.event.addListenerOnce(map, 'idle', function() {
        return setTimeout((function() {
          return $('.finder-map').prependTo('.big-map__container');
        }), 1500);
      });
      $("body").on("click", ".marker-window >div:last", function(e) {
        return $('.marker-window').remove();
      });
      $("body").on("mouseover", ".card", function() {
        var index, list;
        if (docMaps.cardId !== $(this).data('id') && docMaps.markersList.length > 0) {
          docMaps.resetMarkers();
          if (docMaps.pageName === 'clinics') {
            if ($(this).find('.small-card').length > 0) {
              index = docMaps.findMarker('id', $(this).find('.small-card').eq(0).data('id'));
            } else {
              index = docMaps.findMarker('id', $(this).closest('.card').data('id'));
            }
          } else if (docMaps.pageName === 'diagnostList') {
            if ($(this).find('.card-services').length > 0) {
              index = docMaps.findMarker('id', $(this).find('.card-services').eq(0).data('id'));
            } else {
              index = docMaps.findMarker('id', $(this).closest('.card').data('id'));
            }
          } else if (docMaps.pageName === 'doctors') {
            if ($(this).find('.card__job').length > 0) {
              index = docMaps.findMarker('id', $(this).find('.card__job').eq(0).data('id'));
            } else {
              index = docMaps.findMarker('id', $(this).closest('.card').data('id'));
            }
          } else if (docMaps.pageName === 'action') {
            if ($(this).find('.action-card').length > 0) {
              index = docMaps.findMarker('id', $(this).find('.action-card').eq(0).data('id'));
            } else {
              index = docMaps.findMarker('id', $(this).closest('.card').data('id'));
            }
          } else if (docMaps.pageName === 'cla') {
            if ($(this).find('.affilliate').length > 0) {
              index = docMaps.findMarker('id', $(this).find('.affilliate').eq(0).data('id'));
            } else {
              index = docMaps.findMarker('id', $(this).closest('.card').data('id'));
            }
          }
          if ($(this).find('.card-services').length > 0) {
            list = docMaps.markersList.slice(index, index + ($(this).find('.card-services').length));
          } else if ($(this).find('.card__job').length > 0) {
            list = docMaps.markersList.slice(index, index + ($(this).find('.card__job').length));
          } else if ($(this).find('.small-card').length > 0) {
            list = docMaps.markersList.slice(index, index + ($(this).find('.small-card').length));
          } else if ($(this).find('.action-card').length > 0) {
            list = docMaps.markersList.slice(index, index + ($(this).find('.action-card').length));
          } else {
            list = [];
            list.push(docMaps.markersList[index]);
          }
          docMaps.fitMap(list, map);
          return docMaps.cardId = $(this).data('id');
        }
      });
      return $(window).resize(function() {
        if (docMaps.pageName === 'map') {
          return docMaps.mapCss.bigMap();
        } else {
          if (docMaps.pageName === 'doctorInner' || docMaps.pageName === 'clinicInner') {
            return docMaps.mapCss.inner();
          } else {
            return docMaps.mapCss.index();
          }
        }
      });
    }
  },
  findMarker: function(key, value) {
    var i, index;
    i = 0;
    index = -1;
    while (index === -1 || i < docMaps.markersList.length - 1) {
      if (docMaps.markersList[i].addInfo.affilate) {
        if (docMaps.markersList[i].addInfo.affilate[key] === value) {
          index = i;
        }
      } else {
        if (docMaps.markersList[i].addInfo[key] === value) {
          index = i;
        }
      }
      i++;
    }
    if (index === -1) {
      console.log('Not found marker key: ' + key + ', value: ' + value);
    }
    return index;
  },
  fitMap: function(currentMarkers, map, zoom) {
    map.panTo(currentMarkers[0].getPosition());
    currentMarkers[0].setIcon(docMaps.icon2);
    if (!zoom) {
      zoom = 12;
    }
    return map.setZoom(zoom);
  }
};
