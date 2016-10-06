window._UXK_Components.SCROLLVIEW = {
    scroller: {
        onDragStart: function (dom, sender) {
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
            $(dom).value('frame', function(frame){
                dom._tmp_scroll_start.bounds.width = frame.width;
                dom._tmp_scroll_start.bounds.height = frame.height;
            }) ;
        },
        onBeingDrag: function (dom, sender) {
            var newOffset = {
                x: dom._tmp_scroll_start.offset.x,
                y: dom._tmp_scroll_start.offset.y + parseFloat(sender.translateY),
            }
            var bottomBounds = dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height;
            if (newOffset.y > 0.0) {
                newOffset.y = newOffset.y / 3.0;
            }
            else if (newOffset.y < (0 - bottomBounds)) {
                var delta = (0 - bottomBounds) - newOffset.y;
                newOffset.y = (0 - bottomBounds) - delta / 3.0;
            }
            dom.setAttribute('contentoffset', newOffset.x + ',' + newOffset.y);
            $(dom).update();
        },
        onDragEnd: function (dom, sender) {
            var newOffset = {
                x: dom._tmp_scroll_start.offset.x,
                y: dom._tmp_scroll_start.offset.y + parseFloat(sender.translateY),
            }
            var bottomBounds = dom._tmp_scroll_start.size.height - dom._tmp_scroll_start.bounds.height;
            if (newOffset.y > 0.0) {
                newOffset.y = 0;
                dom.setAttribute('contentoffset', newOffset.x + ',' + newOffset.y);
                $(dom).spring({
                    bounciness: 1.0
                });
            }
            else if (newOffset.y < (0 - bottomBounds)) {
                newOffset.y = (0 - bottomBounds);
                dom.setAttribute('contentoffset', newOffset.x + ',' + newOffset.y);
                $(dom).spring({
                    bounciness: 1.0
                });
            }
            else {
                $(dom).find("[vKey='contentView']").decay({
                    aniProps: 'frame',
                    velocity: '0,' + sender.velocityY + ',0,0',
                    onChange: function (frame) {
                        $(dom).attr('contentoffset', frame.x + ',' + frame.y);
                    }
                });
            }
        }
    },
    onLoad: function (dom) {
        var obj = this;
        $(dom).onTouch(function (sender) {
            if (sender.state == "Began") {
                $(dom).find("[vKey='contentView']").stop(function () {
                    $(dom).find("[vKey='contentView']").value('frame', function (frame) {
                        var contentOffset = frame.x + "," + frame.y;
                        $(dom).attr('contentoffset', contentOffset);
                    })
                });
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
