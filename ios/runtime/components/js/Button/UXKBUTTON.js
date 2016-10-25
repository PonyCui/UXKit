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
        var backgroundColor = {
            normal: $(dom).attr('backgroundColorNormal') || $(dom).attr('backgroundColor'),
            highlighted: $(dom).attr('backgroundColorHighlighted') || $(dom).attr('backgroundColor'),
            selected: $(dom).attr('backgroundColorSelected') || $(dom).attr('backgroundColor'),
            disabled: $(dom).attr('backgroundColorDisabled') || $(dom).attr('backgroundColor'),
        };
        var textColor = {
            normal: $(dom).attr('textColorNormal') || $(dom).attr('textColor') || tintColor,
            highlighted: $(dom).attr('textColorHighlighted') || $(dom).attr('textColor') || this.colorWithAlpha(tintColor, 0.3),
            selected: $(dom).attr('textColorSelected') || $(dom).attr('textColor') || tintColor,
            disabled: $(dom).attr('textColorDisabled') || $(dom).attr('textColor') || tintColor,
        };
        var imageUrl = {
            normal: $(dom).attr('imageUrlNormal') || $(dom).attr('imageUrl'),
            highlighted: $(dom).attr('imageUrlHighlighted') || $(dom).attr('imageUrl'),
            selected: $(dom).attr('imageUrlSelected') || $(dom).attr('imageUrl'),
            disabled: $(dom).attr('imageUrlDisabled') || $(dom).attr('imageUrl'),
        };
        var imageBase64 = {
            normal: $(dom).attr('imageBase64Normal') || $(dom).attr('imageBase64'),
            highlighted: $(dom).attr('imageBase64Highlighted') || $(dom).attr('imageBase64'),
            selected: $(dom).attr('imageBase64Selected') || $(dom).attr('imageBase64'),
            disabled: $(dom).attr('imageBase64Disabled') || $(dom).attr('imageBase64'),
        };
        var imageRenderingMode = $(dom).attr('imageRenderingMode') || "template"; 
        var imageColor = {
            normal: $(dom).attr('imageColorNormal') || $(dom).attr('imageColor') || tintColor,
            highlighted: $(dom).attr('imageColorHighlighted') || $(dom).attr('imageColor') || this.colorWithAlpha(tintColor, 0.3),
            selected: $(dom).attr('imageColorSelected') || $(dom).attr('imageColor') || tintColor,
            disabled: $(dom).attr('imageColorDisabled') || $(dom).attr('imageColor') || tintColor,
        };
        var imageSize = {
            normal: $(dom).attr('imageSizeNormal') || $(dom).attr('imageSize'),
            highlighted: $(dom).attr('imageSizeHighlighted') || $(dom).attr('imageSize'),
            selected: $(dom).attr('imageSizeSelected') || $(dom).attr('imageSize'),
            disabled: $(dom).attr('imageSizeDisabled') || $(dom).attr('imageSize'),
        };
        var imageInset = {
            top: $(dom).attr('imageInset') !== undefined ? parseFloat($(dom).attr('imageInset').split(',')[0]) : 0,
            left: $(dom).attr('imageInset') !== undefined ? parseFloat($(dom).attr('imageInset').split(',')[1]) : 0,
            bottom: $(dom).attr('imageInset') !== undefined ? parseFloat($(dom).attr('imageInset').split(',')[2]) : 0,
            right: $(dom).attr('imageInset') !== undefined ? parseFloat($(dom).attr('imageInset').split(',')[3]) : 0,
        }
        var titleInset = {
            top: $(dom).attr('titleInset') !== undefined ? parseFloat($(dom).attr('titleInset').split(',')[0]) : 0,
            left: $(dom).attr('titleInset') !== undefined ? parseFloat($(dom).attr('titleInset').split(',')[1]) : 0,
            bottom: $(dom).attr('titleInset') !== undefined ? parseFloat($(dom).attr('titleInset').split(',')[2]) : 0,
            right: $(dom).attr('titleInset') !== undefined ? parseFloat($(dom).attr('titleInset').split(',')[3]) : 0,
        }
        if ($(dom).attr('reverseOnTouch') === "true" && backgroundColor.normal === undefined) {
            backgroundColor.normal = this.colorWithAlpha(tintColor, 0.0);
            backgroundColor.highlighted = tintColor;
            textColor.highlighted = "#ffffff";
            imageColor.highlighted = "#ffffff";
        }
        return {
            status: dom._status || window._UXK_Components.BUTTON.Enum.Status.Normal,
            title: {
                normal: $(dom).attr('titleNormal') || $(dom).attr('title'),
                highlighted: $(dom).attr('titleHighlighted') || $(dom).attr('title'),
                selected: $(dom).attr('titleSelected') || $(dom).attr('title'),
                disabled: $(dom).attr('titleDisabled') || $(dom).attr('title'),
            },
            textColor: textColor,
            backgroundColor: backgroundColor,
            imageUrl: imageUrl,
            imageBase64: imageBase64,
            imageSize: imageSize,
            imageRenderingMode: imageRenderingMode,
            imageColor: imageColor,
            textFont: $(dom).attr('textFont'),
            tintColor: tintColor,
            imageInset: imageInset,
            titleInset: titleInset,
        }
    },
    setProps: function (dom, props) {
        var buttonProps = window._UXK_Components.BUTTON.props(dom);
        // request status key.
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
        // set props.
        var width = dom.frame != undefined ? dom.frame.width : 0.0;
        var height = dom.frame != undefined ? dom.frame.height : 0.0;
        var textWidth = dom.textFrame != undefined ? dom.textFrame.width : 0.0;
        var textHeight = dom.textFrame != undefined ? dom.textFrame.height : 0.0;
        var imageWidth = 0;
        var imageHeight = 0;
        if (buttonProps.imageUrl[statusKey] !== undefined && buttonProps.imageSize[statusKey] !== undefined) {
            imageWidth = parseFloat(buttonProps.imageSize[statusKey].split(',')[0]);
            imageHeight = parseFloat(buttonProps.imageSize[statusKey].split(',')[1]);
        }
        var contentWidth = textWidth + imageWidth + buttonProps.imageInset.right + buttonProps.titleInset.left;
        var textX = (width - contentWidth) / 2.0 + imageWidth + buttonProps.imageInset.right + buttonProps.titleInset.left;
        var textY = (height - textHeight) / 2.0;
        var imageX = (width - contentWidth) / 2.0;
        var imageY = (height - imageHeight) / 2.0;
        $(dom).find("[vKey='textWrapper']").attr('frame', textX + ',' + textY + ',' + textWidth + ',' + textHeight);
        $(dom).find("[vKey='textLabel']").attr('font', buttonProps.textFont);
        $(dom).find("[vKey='textLabel']").attr('textColor', buttonProps.textColor[statusKey]);
        $(dom).find("[vKey='textLabel']").text(buttonProps.title[statusKey]);
        $(dom).find("[vKey='controlView']").attr('backgroundColor', buttonProps.backgroundColor[statusKey]);
        $(dom).find("[vKey='controlView']").attr('cornerRadius', $(dom).attr('cornerRadius'));
        if (buttonProps.imageUrl[statusKey] !== undefined && buttonProps.imageSize[statusKey] !== undefined) {
            $(dom).find("[vKey='imageWrapper']").attr('frame', imageX + ',' + imageY + ',' + buttonProps.imageSize[statusKey]);
            $(dom).find("[vKey='image']").attr('frame', '0,0,' + buttonProps.imageSize[statusKey]);
            $(dom).find("[vKey='image']").attr('url', buttonProps.imageUrl[statusKey]);
            $(dom).find("[vKey='image']").attr('renderingMode', buttonProps.imageRenderingMode);
            $(dom).find("[vKey='image']").attr('color', buttonProps.imageColor[statusKey]);
        }
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
                dom._status = window._UXK_Components.BUTTON.Enum.Status.Highlighted;
                $(dom).update();
                setTimeout(function () {
                    dom._status = window._UXK_Components.BUTTON.Enum.Status.Normal;
                    $(dom).update();
                }, 150)
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
    colorWithAlpha: function (color, alpha) {
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


