(function ($) {

    var IMPs = {};

    $.createIMP = function (funcName, nodeName, IMP) {
        if (IMPs[funcName] === undefined) {
            IMPs[funcName] = {};
            $.fn[funcName] = function (arg0, arg1, arg2, arg3) {
                if (this.get(0) !== undefined) {
                    if (IMPs[funcName][this.get(0).nodeName] !== undefined) {
                        return IMPs[funcName][this.get(0).nodeName].call(this, arg0, arg1, arg2, arg3);
                    }
                    else if (IMPs[funcName]['*'] !== undefined) {
                        return IMPs[funcName]['*'].call(this, arg0, arg1, arg2, arg3);
                    }
                }
            }
        }
        IMPs[funcName][nodeName] = IMP;
    };

})(jQuery)

// Frame

$.createIMP('frame', '*', function (value) {
    if (typeof value === "object") {
        this.attr('frame', value.x + "," + value.y + "," + value.width + "," + value.height);
        return this;
    }
    else if (typeof value === "string") {
        this.attr('frame', value);
        return this;
    }
    else {
        if (this.attr('frame') === undefined) {
            return { x: 0, y: 0, width: 0, height: 0 };
        }
        var components = this.attr('frame').split(',');
        if (components.length == 4) {
            return {
                x: parseFloat(components[0]),
                y: parseFloat(components[1]),
                width: parseFloat(components[2]),
                height: parseFloat(components[3]),
            };
        }
        else {
            return this.attr('frame');
        }
    }
});

$.createIMP('x', '*', function(value) {
    if (typeof value === "string") {
        var frame = this.frame();
        frame.x = parseFloat(value);
        return this.frame(frame);
    }
    else if (typeof value === "number") {
        var frame = this.frame();
        frame.x = value;
        return this.frame(frame);
    }
    else {
        var frame = this.frame();
        if (typeof frame === "object") {
            return frame.x;
        }
    }
});

$.createIMP('y', '*', function(value) {
    if (typeof value === "string") {
        var frame = this.frame();
        frame.y = parseFloat(value);
        return this.frame(frame);
    }
    else if (typeof value === "number") {
        var frame = this.frame();
        frame.y = value;
        return this.frame(frame);
    }
    else {
        var frame = this.frame();
        if (typeof frame === "object") {
            return frame.y;
        }
    }
});

$.createIMP('width', '*', function(value) {
    if (typeof value === "string") {
        var frame = this.frame();
        frame.width = parseFloat(value);
        return this.frame(frame);
    }
    else if (typeof value === "number") {
        var frame = this.frame();
        frame.width = value;
        return this.frame(frame);
    }
    else {
        var frame = this.frame();
        if (typeof frame === "object") {
            return frame.width;
        }
    }
});

$.createIMP('height', '*', function(value) {
    if (typeof value === "string") {
        var frame = this.frame();
        frame.height = parseFloat(value);
        return this.frame(frame);
    }
    else if (typeof value === "number") {
        var frame = this.frame();
        frame.height = value;
        return this.frame(frame);
    }
    else {
        var frame = this.frame();
        if (typeof frame === "object") {
            return frame.height;
        }
    }
});

// Opacity

$.createIMP('alpha', '*', function (value) {
    if (typeof value === "string") {
        this.attr('alpha', value);
        return this;
    }
    else if (typeof value === "number") {
        this.attr('alpha', value);
        return this;
    }
    else {
        if (this.attr('alpha') === undefined) {
            return 1.0;
        }
        else {
            return parseFloat(this.attr('alpha'));
        }
    }
});

$.createIMP('hide', '*', function (speed, callback) {
    return this.fadeOut(speed, callback);
});

$.createIMP('show', '*', function (speed, callback) {
    return this.fadeIn(speed, callback);
});

$.createIMP('fadeIn', '*', function (speed, callback) {
    if (typeof speed === "string") {
        if (speed === "slow") {
            speed = 600;
        }
        else if (speed === "normal") {
            speed = 300;
        }
        else if (speed === "fast") {
            speed = 150;
        }
        else {
            speed = undefined;
        }
    }
    return this.alpha(1).animate(speed);
});

$.createIMP('fadeOut', '*', function (speed, callback) {
    if (typeof speed === "string") {
        if (speed === "slow") {
            speed = 600;
        }
        else if (speed === "normal") {
            speed = 300;
        }
        else if (speed === "fast") {
            speed = 150;
        }
        else {
            speed = undefined;
        }
    }
    return this.alpha(0).animate(speed);
});

$.createIMP('fadeTo', '*', function (speed, opacity, callback) {
    if (typeof speed === "number" && opacity === undefined && callback === undefined) {
        opacity = speed;
    }
    if (typeof speed === "string") {
        if (speed === "slow") {
            speed = 600;
        }
        else if (speed === "normal") {
            speed = 300;
        }
        else if (speed === "fast") {
            speed = 150;
        }
        else {
            speed = undefined;
        }
    }
    return this.alpha(opacity).animate(speed);
});
