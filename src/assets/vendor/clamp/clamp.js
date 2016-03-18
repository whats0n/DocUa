// http://css-tricks.com/line-clampin/

// Clamp.js
// https://github.com/josephschmitt/Clamp.js

/**
 * TextOverflowClamp.js
 *
 * Updated 2014-05-08 to improve speed and fix some bugs.
 *
 * Updated 2013-05-09 to remove jQuery dependancy.
 * But be careful with webfonts!
 *
 * NEW!
 * - Support for padding.
 * - Support for nearby floated elements.
 * - Support for text-indent.
 */

// bind function support for older browsers without it
// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Function/bind
if (!Function.prototype.bind) {
    Function.prototype.bind = function (oThis) {
        if (typeof this !== "function") {
            // closest thing possible to the ECMAScript 5 internal IsCallable function
            throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
        }

        var aArgs = Array.prototype.slice.call(arguments, 1),
            fToBind = this,
            fNOP = function () {},
            fBound = function () {
                return fToBind.apply(this instanceof fNOP && oThis ? this : oThis,
                aArgs.concat(Array.prototype.slice.call(arguments)));
            };

        fNOP.prototype = this.prototype;
        fBound.prototype = new fNOP();

        return fBound;
    };
}


// the actual meat is here
(function (w, d) {
    var clamp, measure, text, lineWidth,
    lineStart, lineCount, wordStart,
    line, lineText, wasNewLine,
    ce = d.createElement.bind(d),
        ctn = d.createTextNode.bind(d),
        width, widthChild, newWidthChild;

    // measurement element is made a child of the clamped element to get it's style
    measure = ce('span');

    (function (s) {
        s.position = 'absolute'; // prevent page reflow
        s.whiteSpace = 'pre'; // cross-browser width results
        s.visibility = 'hidden'; // prevent drawing
    })(measure.style);

    // width element calculates the width of each line
    width = ce('span');

    widthChild = ce('span');
    widthChild.style.display = 'block';
    widthChild.style.overflow = 'hidden';
    widthChild.appendChild(ctn("\u2060"));

    clamp = function (el, lineClamp) {
        var i;
        // make sure the element belongs to the document
        if (!el.ownerDocument || !el.ownerDocument === d) return;
        // reset to safe starting values
        lineStart = wordStart = 0;
        lineCount = 1;
        wasNewLine = false;
        //lineWidth = el.clientWidth;
        lineWidth = [];
        // get all the text, remove any line changes
        text = (el.textContent || el.innerText).replace(/\n/g, ' ');
        // create a child block element that accounts for floats
        for (i = 1; i < lineClamp; i++) {
            newWidthChild = widthChild.cloneNode(true);
            width.appendChild(newWidthChild);
            if (i === 1) {
                widthChild.style.textIndent = 0;
            }
        }
        widthChild.style.textIndent = '';
        // cleanup
        newWidthChild = void 0;
        // remove all content
        while (el.firstChild)
        el.removeChild(el.firstChild);
        // ready for width calculating magic
        el.appendChild(width);
        // then start calculating widths of each line
        for (i = 0; i < lineClamp - 1; i++) {
            lineWidth.push(width.childNodes[i].clientWidth);
        }
        // we are done, no need for this anymore
        el.removeChild(width);
        // cleanup the lines
        while (width.firstChild)
        width.removeChild(width.firstChild);
        // add measurement element within so it inherits styles
        el.appendChild(measure);
        // http://ejohn.org/blog/search-and-dont-replace/
        text.replace(/ /g, function (m, pos) {
            // ignore any further processing if we have total lines
            if (lineCount === lineClamp) return;
            // create a text node and place it in the measurement element
            measure.appendChild(ctn(text.substr(lineStart, pos - lineStart)));
            // have we exceeded allowed line width?
            if (lineWidth[lineCount - 1] <= measure.clientWidth) {
                if (wasNewLine) {
                    // we have a long word so it gets a line of it's own
                    lineText = text.substr(lineStart, pos + 1 - lineStart);
                    // next line start position
                    lineStart = pos + 1;
                } else {
                    // grab the text until this word
                    lineText = text.substr(lineStart, wordStart - lineStart);
                    // next line start position
                    lineStart = wordStart;
                }
                // create a line element
                line = ce('span');
                // add text to the line element
                line.appendChild(ctn(lineText));
                // add the line element to the container
                el.appendChild(line);
                // yes, we created a new line
                wasNewLine = true;
                lineCount++;
            } else {
                // did not create a new line
                wasNewLine = false;
            }
            // remember last word start position
            wordStart = pos + 1;
            // clear measurement element
            measure.removeChild(measure.firstChild);
        });
        // remove the measurement element from the container
        el.removeChild(measure);
        // create the last line element
        line = ce('span');
        // see if we need to add styles
        if (lineCount === lineClamp) {
            // give styles required for text-overflow to kick in
            (function (s) {
                s.display = 'block';
                s.overflow = 'hidden';
                s.textIndent = 0;
                s.textOverflow = 'ellipsis';
                s.whiteSpace = 'nowrap';
            })(line.style);
        }
        // add all remaining text to the line element
        line.appendChild(ctn(text.substr(lineStart)));
        // add the line element to the container
        el.appendChild(line);
    }
    w.clamp = clamp;
})(window, window.document);




/* YOUR CODE */

var winWidth;
$(window).resize(function () {
    winWidth = $(window).width();
    if (winWidth <= 1200) {
        loadClamp(2);
    } else {
        // back to normal
        loadClamp(0);
    }
}).resize();

function loadClamp(lines) {
    clamp(document.getElementById('clamp-js'), lines);
}