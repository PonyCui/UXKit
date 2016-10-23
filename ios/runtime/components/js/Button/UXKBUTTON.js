window._UXK_Components.BUTTON = {
    Enum: {
        Status: {
            Normal: 0,
            Highlighted: 1,
            Selected: 2,
            Disabled: 3,
        },
    },
    props: function (dom) {
        var tintColor = $(dom).attr('tintColor') || "#209b53";
        return {
            status: dom._status || window._UXK_Components.BUTTON.Enum.Status.Normal,
            title: {
                normal: $(dom).attr('titleNormal') || $(dom).attr('title'),
                highlighted: $(dom).attr('titleHighlighted') || $(dom).attr('title'),
                selected: $(dom).attr('titleSelected') || $(dom).attr('title'),
                disabled: $(dom).attr('titleDisabled') || $(dom).attr('title'),
            },
            textColor: {
                normal: $(dom).attr('textColorNormal') || $(dom).attr('textColor') || tintColor,
                highlighted: $(dom).attr('textColorHighlighted') || $(dom).attr('textColor') || this.colorWithAlpha(tintColor, 0.3),
                selected: $(dom).attr('textColorSelected') || $(dom).attr('textColor') || tintColor,
                disabled: $(dom).attr('textColorDisabled') || $(dom).attr('textColor') || tintColor,
            },
            textFont: $(dom).attr('textFont'),
            tintColor: tintColor,
        }
    },
    setProps: function (dom, props) {
        var buttonProps = window._UXK_Components.BUTTON.props(dom);
        var width = dom.frame != undefined ? dom.frame.width : 0.0;
        var height = dom.frame != undefined ? dom.frame.height : 0.0;
        var textWidth = dom.textFrame != undefined ? dom.textFrame.width : 0.0;
        var textHeight = dom.textFrame != undefined ? dom.textFrame.height : 0.0;
        var textX = (width - textWidth) / 2.0;
        var textY = (height - textHeight) / 2.0;
        $(dom).find("[vKey='textWrapper']").attr('frame', textX + ',' + textY + ',' + textWidth + ',' + textHeight);
        $(dom).find("[vKey='textLabel']").attr('font', buttonProps.textFont);
        var statusKey = 'normal';
        switch (buttonProps.status) {
            case window._UXK_Components.BUTTON.Enum.Status.Normal:
                statusKey = 'normal';
                break;
            case window._UXK_Components.BUTTON.Enum.Status.Highlighted:
                statusKey = 'highlighted';
                break;
            case window._UXK_Components.BUTTON.Enum.Status.Selected:
                statusKey = 'selected';
                break;
            case window._UXK_Components.BUTTON.Enum.Status.Disabled:
                statusKey = 'disabled';
                break;
        }
        $(dom).find("[vKey='textLabel']").attr('textColor', buttonProps.textColor[statusKey]);
        $(dom).find("[vKey='textLabel']").text(buttonProps.title[statusKey]);
    },
    onLoad: function (dom) {
        $(dom).onLayout(function (frame) {
            dom.frame = frame;
            $(dom).update();
        });
        $(dom).find("[vKey='textLabel']").onLayout(function (frame) {
            dom.textFrame = frame;
            $(dom).update();
        });
        $(dom).value("frame", function (frame) {
            dom.frame = frame;
            $(dom).update();
        });
        $(dom).find("[vKey='textLabel']").value("frame", function (frame) {
            dom.textFrame = frame;
            $(dom).update();
        });
        $(dom).onTap(function (sender) {
            if (dom._status === window._UXK_Components.BUTTON.Enum.Status.Disabled) {
                return;
            }
            if (sender.state == "Ended") {
                if (typeof dom._ontouchupinside === "function") {
                    dom._ontouchupinside.call(this);
                }
            }
        })
        $(dom).onLongPress(function (sender) {
            if (dom._status === window._UXK_Components.BUTTON.Enum.Status.Disabled) {
                return;
            }
            if (sender.state == "Began") {
                if (typeof dom._ontouchdown === "function") {
                    dom._inside = true;
                    dom._ontouchdown.call(this);
                }
                dom._status = window._UXK_Components.BUTTON.Enum.Status.Highlighted;
            }
            else if (sender.state == "Changed") {
                if (sender.locationX > dom.frame.width || sender.locationY > dom.frame.height) {
                    if (typeof dom._ondragoutside === "function") {
                        dom._ondragoutside.call(this);
                    }
                    if (dom._inside === true) {
                        dom._inside = false;
                        if (typeof dom._ondragexit === "function") {
                            dom._ondragexit.call(this);
                        }
                    }
                    dom._status = window._UXK_Components.BUTTON.Enum.Status.Normal;
                }
                else {
                    if (typeof dom._ondraginside === "function") {
                        dom._ondraginside.call(this);
                    }
                    if (dom._inside === false) {
                        dom._inside = true;
                        if (typeof dom._ondragenter === "function") {
                            dom._ondragenter.call(this);
                        }
                    }
                    dom._status = window._UXK_Components.BUTTON.Enum.Status.Highlighted;
                }
            }
            else if (sender.state == "Ended") {
                if (sender.locationX > dom.frame.width || sender.locationY > dom.frame.height) {
                    if (typeof dom._ontouchupoutside === "function") {
                        dom._ontouchupoutside.call(this);
                    }
                }
                else {
                    if (typeof dom._ontouchupinside === "function") {
                        dom._ontouchupinside.call(this);
                    }
                }
                dom._status = window._UXK_Components.BUTTON.Enum.Status.Normal;
            }
            $(dom).update();
        }, { duration: 0.10 })
    },
    colorWithAlpha: function(color, alpha) {
        if (color.indexOf('#') === 0) {
            var hex = color.replace('#', '');
            if (hex.length === 6) {
                return '#' + (parseInt(alpha * 255)).toString(16) + hex;
            }
        }
        return color;
    },
}

$._attach('onTouchDown', 'BUTTON', function (callback) {
    $(this).get(0)._ontouchdown = callback;
})

$._attach('onDragInside', 'BUTTON', function (callback) {
    $(this).get(0)._ondraginside = callback;
})

$._attach('onDragOutside', 'BUTTON', function (callback) {
    $(this).get(0)._ondragoutside = callback;
})

$._attach('onDragEnter', 'BUTTON', function (callback) {
    $(this).get(0)._ondragenter = callback;
})

$._attach('onDragExit', 'BUTTON', function (callback) {
    $(this).get(0)._ondragexit = callback;
})

$._attach('onTouchUpInside', 'BUTTON', function (callback) {
    $(this).get(0)._ontouchupinside = callback;
})

$._attach('onTouchUpOutside', 'BUTTON', function (callback) {
    $(this).get(0)._ontouchupoutside = callback;
})


