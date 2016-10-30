window._UXK_Components.SCROLLVIEW = {
    props: function (dom) {
        return {
            contentSize: (function (dom) {
                var size = {
                    width: 0,
                    height: 0,
                };
                if (typeof $(dom).attr('contentsize') === "string") {
                    if ($(dom).attr('contentsize') === "auto") {
                        var scrollDirection = typeof $(dom).attr('scrolldirection') === "string" ? $(dom).attr('scrolldirection') : "V";
                        if (scrollDirection === "V") {
                            size.width = -1;
                            $(dom).find(".auto").each(function () {
                                if (typeof $(this).attr('frame') === "string") {
                                    var frameComponent = $(this).attr('frame').split(',');
                                    if (frameComponent.length == 4) {
                                        size.height = Math.max(parseFloat(frameComponent[1]) + parseFloat(frameComponent[3]), size.height);
                                    }
                                }
                            })
                        }
                        else if (scrollDirection === "H") {
                            size.height = -1;
                            $(dom).find(".auto").each(function () {
                                if (typeof $(this).attr('frame') === "string") {
                                    var frameComponent = $(this).attr('frame').split(',');
                                    if (frameComponent.length == 4) {
                                        size.width = Math.max(parseFloat(frameComponent[0]) + parseFloat(frameComponent[2]), size.width);
                                    }
                                }
                            })
                        }
                    }
                    else {
                        size.width = parseFloat($(dom).attr('contentsize').split(',')[0]);
                        size.height = parseFloat($(dom).attr('contentsize').split(',')[1]);
                    }
                }
                return size;
            })(dom),
            contentOffset: (function (dom) {
                var offset = {
                    x: 0,
                    y: 0,
                };
                if (typeof $(dom).attr('contentoffset') === "string") {
                    offset.x = parseFloat($(dom).attr('contentoffset').split(',')[0]);
                    offset.y = parseFloat($(dom).attr('contentoffset').split(',')[1]);
                }
                return offset;
            })(dom),
            scrollDirection: typeof $(dom).attr('scrolldirection') === "string" ? $(dom).attr('scrolldirection') : "V",
            scrollEnabled: $(dom).attr('scrollEnabled') === "false" ? false : true,
            directionalLockEnabled: $(dom).attr('directionalLockEnabled') === "false" ? false : true,
            bounce: $(dom).attr('bounce') === "false" ? false : true,
            pagingEnabled: $(dom).attr('pagingEnabled') === "true" ? true : false,
        }
    },
    setProps: function (dom, props) {
        var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
        dom.querySelector("[vKey='contentView']").setAttribute(
            'frame',
            scrollProps.contentOffset.x + ',' +
            scrollProps.contentOffset.y + ',' +
            scrollProps.contentSize.width + ',' +
            scrollProps.contentSize.height);
    },
    indicator: {
        update: function (dom) {
            var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
            // v
            var vHeight = (dom._tmp_scroll_start.bounds.height / scrollProps.contentSize.height) * dom._tmp_scroll_start.bounds.height;
            var vProgress = (-dom._tmp_scroll_duration.offset.y) / (dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height);
            var vOffset = vProgress * (dom._tmp_scroll_start.bounds.height - vHeight);
            $(dom).find('[vKey="vIndicator"]').attr('frame', (dom._tmp_scroll_start.bounds.width - 5) + ',' + vOffset + ',2.5,' + vHeight);
            $(dom).find('[vKey="vIndicator"]').update(true);
            // h
            var hWidth = (dom._tmp_scroll_start.bounds.width / scrollProps.contentSize.width) * dom._tmp_scroll_start.bounds.width;
            var hProgress = (-dom._tmp_scroll_duration.offset.x) / (dom._tmp_scroll_start.size.width - dom._tmp_scroll_start.bounds.width);
            var hOffset = hProgress * (dom._tmp_scroll_start.bounds.width - hWidth);
            $(dom).find('[vKey="hIndicator"]').attr('frame', hOffset + ',' + (dom._tmp_scroll_start.bounds.height - 5) + ',' + hWidth + ',2.5');
            $(dom).find('[vKey="hIndicator"]').update(true);
        },
        show: function (dom) {
            (function (dom) {
                var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
                if ((scrollProps.scrollDirection === "VH" || scrollProps.scrollDirection === "HV") && scrollProps.directionalLockEnabled) {
                    if (dom._tmp_scroll_start.direction === undefined) {
                        return;
                    }
                    if (dom._tmp_scroll_start.direction === "H") {
                        if ($(dom).find('[vKey="vIndicator"]').attr('alpha') === "1.0") {
                            $(dom).find('[vKey="vIndicator"]').attr('alpha', "0.0");
                            $(dom).find('[vKey="vIndicator"]').update(true);
                        }
                        return;
                    }
                }
                if ($(dom).find('[vKey="vIndicator"]').attr('alpha') === "1.0") {
                    return;
                }
                $(dom).find('[vKey="vIndicator"]').attr('alpha', "1.0");
                $(dom).find('[vKey="vIndicator"]').update(true);
            })(dom);
            (function (dom) {
                var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
                if ((scrollProps.scrollDirection === "VH" || scrollProps.scrollDirection === "HV") && scrollProps.directionalLockEnabled) {
                    if (dom._tmp_scroll_start.direction === undefined) {
                        return;
                    }
                    if (dom._tmp_scroll_start.direction === "V") {
                        if ($(dom).find('[vKey="hIndicator"]').attr('alpha') === "1.0") {
                            $(dom).find('[vKey="hIndicator"]').attr('alpha', "0.0");
                            $(dom).find('[vKey="hIndicator"]').update(true);
                        }
                        return;
                    }
                }
                if ($(dom).find('[vKey="hIndicator"]').attr('alpha') === "1.0") {
                    return;
                }
                $(dom).find('[vKey="hIndicator"]').attr('alpha', "1.0");
                $(dom).find('[vKey="hIndicator"]').update(true);
            })(dom);
        },
        hide: function (dom) {
            (function (dom) {
                if ($(dom).find('[vKey="vIndicator"]').attr('alpha') === "0.0") {
                    return;
                }
                $(dom).find('[vKey="vIndicator"]').attr('alpha', "0.0");
                $(dom).find('[vKey="vIndicator"]').animate();
            })(dom);
            (function (dom) {
                if ($(dom).find('[vKey="hIndicator"]').attr('alpha') === "0.0") {
                    return;
                }
                $(dom).find('[vKey="hIndicator"]').attr('alpha', "0.0");
                $(dom).find('[vKey="hIndicator"]').animate();
            })(dom);
        },
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
            else {
                return false;
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
            var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
            if (!scrollProps.scrollEnabled) {
                dom._tmp_scroll_waiting = true;
                return;
            }
            dom._tmp_scroll_waiting = true;
            dom._tmp_scroll_start = {
                direction: undefined,
                offset: scrollProps.contentOffset,
                size: scrollProps.contentSize,
                bounds: {
                    width: 0,
                    height: 0,
                },
            };
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
            if (scrollProps.scrollDirection === "VH" || scrollProps.scrollDirection === "HV") {
                if (dom._tmp_scroll_start.direction === undefined) {
                    if (Math.abs(parseFloat(sender.translateX)) > Math.abs(parseFloat(sender.translateY))) {
                        dom._tmp_scroll_start.direction = "H";
                    }
                    else if (Math.abs(parseFloat(sender.translateY)) > Math.abs(parseFloat(sender.translateX))) {
                        dom._tmp_scroll_start.direction = "V";
                    }
                }
                if (scrollProps.directionalLockEnabled) {
                    if (dom._tmp_scroll_start.direction === undefined) {
                        return; // prevent any touches.
                    }
                    if (dom._tmp_scroll_start.direction === "H") {
                        newOffset.y = dom._tmp_scroll_start.offset.y;
                    }
                    else if (dom._tmp_scroll_start.direction === "V") {
                        newOffset.x = dom._tmp_scroll_start.offset.x;
                    }
                }
            }
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
            dom._tmp_scroll_duration = {
                offset: newOffset
            };
            $(dom).update();
            if (!scrollProps.pagingEnabled) {
                window._UXK_Components.SCROLLVIEW.indicator.show(dom);
                window._UXK_Components.SCROLLVIEW.indicator.update(dom);
            }
        },
        onDragEnd: function (dom, sender) {
            var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
            if (dom._tmp_scroll_waiting) {
                return;
            }
            if (scrollProps.pagingEnabled && this.onPageScroll(dom, sender) === true) {
                window._UXK_Components.SCROLLVIEW.indicator.hide(dom);
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
            if (scrollProps.scrollDirection === "VH" || scrollProps.scrollDirection === "HV") {
                if (scrollProps.directionalLockEnabled) {
                    if (dom._tmp_scroll_start.direction === undefined) {
                        sender.velocityY = 0.0;
                        sender.velocityX = 0.0;
                    }
                    if (dom._tmp_scroll_start.direction === "H") {
                        sender.velocityY = 0.0;
                    }
                    else if (dom._tmp_scroll_start.direction === "V") {
                        sender.velocityX = 0.0;
                    }
                }
            }
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
                onChange: function (vKey, props, frame) {
                    if (vKey !== $(dom).find("[vKey='contentView']").attr('_UXK_vKey') || props !== "frame") {
                        return;
                    }
                    $(dom).attr('contentoffset', frame.x + ',' + frame.y);
                    dom.querySelector("[vKey='contentView']").setAttribute(
                        'frame',
                        frame.x + ',' +
                        frame.y + ',' +
                        scrollProps.contentSize.width + ',' +
                        scrollProps.contentSize.height);
                    dom._tmp_scroll_duration = {
                        offset: frame,
                    };
                    dom._hideAfterTouchEnded = false;
                    window._UXK_Components.SCROLLVIEW.indicator.update(dom);
                },
                onComplete: function (frame) {
                    if (!dom._touching) {
                        window._UXK_Components.SCROLLVIEW.indicator.hide(dom);
                    }
                    else {
                        dom._hideAfterTouchEnded = true;
                    }
                },
            });
        },
        onPageScroll: function (dom, sender) {
            var scrollProps = window._UXK_Components.SCROLLVIEW.props(dom);
            var newOffset = {
                x: dom._tmp_scroll_start.offset.x + parseFloat(sender.translateX),
                y: dom._tmp_scroll_start.offset.y + parseFloat(sender.translateY),
            }
            if (scrollProps.scrollDirection === "VH" || scrollProps.scrollDirection === "HV") {
                return false;
            }
            else if (scrollProps.scrollDirection === "H") {
                newOffset.y = dom._tmp_scroll_start.offset.y;
                if (sender.velocityX < 0.0) {
                    // scroll right
                    newOffset.x = dom._tmp_scroll_start.bounds.width * Math.floor(newOffset.x / dom._tmp_scroll_start.bounds.width);
                    if (-newOffset.x >= dom._tmp_scroll_start.size.width) {
                        return false;
                    }
                    $(dom).attr('contentoffset', newOffset.x + ',' + newOffset.y);
                    $(dom).spring({
                        bounciness: 1.0,
                    });
                    return true;
                }
                else {
                    // scroll left
                    newOffset.x = dom._tmp_scroll_start.bounds.width * Math.ceil(newOffset.x / dom._tmp_scroll_start.bounds.width);
                    if (-newOffset.x < 0.0) {
                        return false;
                    }
                    $(dom).attr('contentoffset', newOffset.x + ',' + newOffset.y);
                    $(dom).spring({
                        bounciness: 1.0,
                    });
                    return true;
                }
            }
            else {
                newOffset.x = dom._tmp_scroll_start.offset.x;
                if (sender.velocityY < 0.0) {
                    // scroll down
                    newOffset.y = dom._tmp_scroll_start.bounds.height * Math.floor(newOffset.y / dom._tmp_scroll_start.bounds.height);
                    if (-newOffset.y >= dom._tmp_scroll_start.size.height) {
                        return false;
                    }
                    $(dom).attr('contentoffset', newOffset.x + ',' + newOffset.y);
                    $(dom).spring({
                        bounciness: 1.0,
                    });
                    return true;
                }
                else {
                    // scroll up
                    newOffset.y = dom._tmp_scroll_start.bounds.height * Math.ceil(newOffset.y / dom._tmp_scroll_start.bounds.height);
                    if (-newOffset.y < 0.0) {
                        return false;
                    }
                    $(dom).attr('contentoffset', newOffset.x + ',' + newOffset.y);
                    $(dom).spring({
                        bounciness: 1.0,
                    });
                    return true;
                }
            }
        }
    },
    onLoad: function (dom) {
        var obj = this;
        $(dom).onTouch(function (sender) {
            if (sender.state == "Began") {
                dom._touching = true;
                dom._hideAfterTouchEnded = false;
                $(dom).find("[vKey='contentView']").stop(function () {
                    $(dom).find("[vKey='contentView']").value('frame', function (frame) {
                        var contentOffset = frame.x + "," + frame.y;
                        $(dom).attr('contentoffset', contentOffset);
                    })
                });
            }
            else if (sender.state == "Ended") {
                dom._touching = false;
                var bottomBounds = (dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height);
                if (dom._tmp_scroll_start.size.height < dom._tmp_scroll_start.bounds.height) {
                    bottomBounds = 0.0;
                }
                var rightBounds = (dom._tmp_scroll_start.size.width - dom._tmp_scroll_start.bounds.width);
                if (dom._tmp_scroll_start.size.width < dom._tmp_scroll_start.bounds.width) {
                    rightBounds = 0.0;
                }
                $(dom).find("[vKey='contentView']").decayBounce({
                    aniProps: 'frame',
                    bounce: true,
                    bounceRect: '0,0,' + rightBounds + ',' + bottomBounds,
                    velocity: '0,0,0,0',
                    onChange: function (vKey, props, frame) {
                        if (vKey !== $(dom).find("[vKey='contentView']").attr('_UXK_vKey') || props !== "frame") {
                            return;
                        }
                        $(dom).attr('contentoffset', frame.x + ',' + frame.y);
                    }
                });
                window._UXK_Components.SCROLLVIEW.indicator.hide(dom);
            }
            else if (sender.state == "Cancelled") {
                dom._touching = false;
            }
        });
        $(dom).onPan(function (sender) {
            if (sender.state == "Began") {
                obj.scroller.onDragStart(dom, sender);
            }
            else if (sender.state == "Changed") {
                obj.scroller.onBeingDrag(dom, sender);
            }
            else if (sender.state == "Ended") {
                obj.scroller.onDragEnd(dom, sender);
            }
        });
        $(dom).attr('clipsToBounds', 'true');
        $(dom).update();
    },
}
