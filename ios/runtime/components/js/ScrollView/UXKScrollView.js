window._UXK_Components.SCROLLVIEW = {
    props: function (dom) {
        return {
            scrollDirection: typeof $(dom).attr('scrolldirection') === "string" ? $(dom).attr('scrolldirection') : "V",
            bounce: $(dom).attr('bounce') === "false" ? false : true,
        }
    },
    scroller: {
        isOutOfXBounds: function (dom, newOffset) {
            if (dom._tmp_scroll_start.size.width < dom._tmp_scroll_start.bounds.width) {
                return true;
            }
            var absX = 0 - newOffset.x;
            if (absX < 0.0) {
                return true;
            }
            else if (absX > dom._tmp_scroll_start.size.width - dom._tmp_scroll_start.bounds.width) {
                return true;
            }
        },
        isOutOfYBounds: function (dom, newOffset) {
            if (dom._tmp_scroll_start.size.height < dom._tmp_scroll_start.bounds.height) {
                return true;
            }
            var absY = 0 - newOffset.y;
            if (absY < 0.0) {
                return true;
            }
            else if (absY > dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height) {
                return true;
            }
            else {
                return false;
            }
        },
        onDragStart: function (dom, sender) {
            dom._tmp_scroll_waiting = true;
            dom._tmp_scroll_start = {
                offset: {
                    x: 0,
                    y: 0,
                },
                size: {
                    width: 0,
                    height: 0,
                },
                bounds: {
                    width: 0,
                    height: 0,
                },
            };
            if (typeof $(dom).attr('contentoffset') === "string") {
                dom._tmp_scroll_start.offset.x = parseFloat($(dom).attr('contentoffset').split(',')[0]);
                dom._tmp_scroll_start.offset.y = parseFloat($(dom).attr('contentoffset').split(',')[1]);
            }
            if (typeof $(dom).attr('contentsize') === "string") {
                dom._tmp_scroll_start.size.width = parseFloat($(dom).attr('contentsize').split(',')[0]);
                dom._tmp_scroll_start.size.height = parseFloat($(dom).attr('contentsize').split(',')[1]);
            }
            $(dom).value('frame', function (frame) {
                dom._tmp_scroll_waiting = false;
                dom._tmp_scroll_start.bounds.width = frame.width;
                dom._tmp_scroll_start.bounds.height = frame.height;
            });
        },
        onBeingDrag: function (dom, sender) {
            var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
            if (dom._tmp_scroll_waiting) {
                return;
            }
            var newOffset = {
                x: dom._tmp_scroll_start.offset.x + parseFloat(sender.translateX),
                y: dom._tmp_scroll_start.offset.y + parseFloat(sender.translateY),
            }
            if (scrollProps.scrollDirection === "VH" || scrollProps.scrollDirection === "HV") { }
            else if (scrollProps.scrollDirection === "H") {
                newOffset.y = dom._tmp_scroll_start.offset.y;
            }
            else {
                newOffset.x = dom._tmp_scroll_start.offset.x;
            }
            if (this.isOutOfXBounds(dom, newOffset)) {
                if (newOffset.x > 0.0) {
                    if (scrollProps.bounce) {
                        newOffset.x = newOffset.x / 3.0;
                    }
                    else {
                        newOffset.x = 0.0;
                    }
                }
                else {
                    var rightBounds = (dom._tmp_scroll_start.size.width - dom._tmp_scroll_start.bounds.width);
                    if (dom._tmp_scroll_start.size.width < dom._tmp_scroll_start.bounds.width) {
                        rightBounds = 0.0;
                    }
                    if (scrollProps.bounce) {
                        var delta = (0 - rightBounds) - newOffset.x;
                        newOffset.x = (0 - rightBounds) - delta / 3.0;
                    } else {
                        newOffset.x = -rightBounds;
                    }
                }
            }
            if (this.isOutOfYBounds(dom, newOffset)) {
                if (newOffset.y > 0.0) {
                    if (scrollProps.bounce) {
                        newOffset.y = newOffset.y / 3.0;
                    }
                    else {
                        newOffset.y = 0.0;
                    }
                }
                else {
                    var bottomBounds = dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height;
                    if (dom._tmp_scroll_start.size.height < dom._tmp_scroll_start.bounds.height) {
                        bottomBounds = 0.0;
                    }
                    if (scrollProps.bounce) {
                        var delta = (0 - bottomBounds) - newOffset.y;
                        newOffset.y = (0 - bottomBounds) - delta / 3.0;
                    }
                    else {
                        newOffset.y = -bottomBounds;
                    }
                }
            }
            dom.setAttribute('contentoffset', newOffset.x + ',' + newOffset.y);
            $(dom).update();
        },
        onDragEnd: function (dom, sender) {
            var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
            if (dom._tmp_scroll_waiting) {
                return;
            }
            var bottomBounds = (dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height);
            if (dom._tmp_scroll_start.size.height < dom._tmp_scroll_start.bounds.height) {
                bottomBounds = 0.0;
            }
            var rightBounds = (dom._tmp_scroll_start.size.width - dom._tmp_scroll_start.bounds.width);
            if (dom._tmp_scroll_start.size.width < dom._tmp_scroll_start.bounds.width) {
                rightBounds = 0.0;
            }
            if (scrollProps.scrollDirection === "VH" || scrollProps.scrollDirection === "HV") { }
            else if (scrollProps.scrollDirection === "H") {
                sender.velocityY = 0.0;
            }
            else {
                sender.velocityX = 0.0;
            }
            $(dom).find("[vKey='contentView']").decayBounce({
                aniProps: 'frame',
                bounce: scrollProps.bounce,
                bounceRect: '0,0,' + rightBounds + ',' + bottomBounds,
                velocity: sender.velocityX + ',' + sender.velocityY + ',0,0',
                onChange: function (frame) {
                    $(dom).attr('contentoffset', frame.x + ',' + frame.y);
                }
            });
        }
    },
    onLoad: function (dom) {
        var obj = this;
        var stopOutOfBounds = false;
        $(dom).onTouch(function (sender) {
            if (sender.state == "Began") {
                $(dom).find("[vKey='contentView']").stop(function () {
                    $(dom).find("[vKey='contentView']").value('frame', function (frame) {
                        var contentOffset = frame.x + "," + frame.y;
                        stopOutOfBounds = obj.scroller.isOutOfXBounds(dom, frame) || obj.scroller.isOutOfYBounds(dom, frame);
                        $(dom).attr('contentoffset', contentOffset);
                    })
                });
            }
            else if (sender.state == "Ended") {
                if (stopOutOfBounds) {
                    var bottomBounds = (dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height);
                    if (dom._tmp_scroll_start.size.height < dom._tmp_scroll_start.bounds.height) {
                        bottomBounds = 0.0;
                    }
                    var rightBounds = (dom._tmp_scroll_start.size.width - dom._tmp_scroll_start.bounds.width);
                    if (dom._tmp_scroll_start.size.width < dom._tmp_scroll_start.bounds.width) {
                        rightBounds = 0.0;
                    }
                    $(dom).find("[vKey='contentView']").decay({
                        aniProps: 'frame',
                        bounce: true,
                        bounceRect: '0,0,' + rightBounds + ',' + bottomBounds,
                        velocity: '0,0,0,0',
                        onChange: function (frame) {
                            $(dom).attr('contentoffset', frame.x + ',' + frame.y);
                        }
                    });
                }
            }
        });
        $(dom).onPan(function (sender) {
            if (sender.state == "Began") {
                $(dom).find("[vKey='contentView']").stop();
                obj.scroller.onDragStart(dom, sender);
            }
            else if (sender.state == "Changed") {
                obj.scroller.onBeingDrag(dom, sender);
            }
            else if (sender.state == "Ended") {
                obj.scroller.onDragEnd(dom, sender);
            }
        });
    },
    setProps: function (dom, props) {
        var contentSize = {
            width: -1,
            height: 0,
        }
        var contentOffset = {
            x: 0,
            y: 0,
        }
        if (typeof props.contentsize === "string") {
            contentSize = {
                width: parseFloat(props.contentsize.split(',')[0]),
                height: parseFloat(props.contentsize.split(',')[1]),
            }
        }
        if (typeof props.contentoffset === "string") {
            contentOffset = {
                x: parseFloat(props.contentoffset.split(',')[0]),
                y: parseFloat(props.contentoffset.split(',')[1]),
            }
        }
        dom.querySelector("[vKey='contentView']").setAttribute(
            'frame',
            contentOffset.x + ',' +
            contentOffset.y + ',' +
            contentSize.width + ',' +
            contentSize.height);
    },
}
