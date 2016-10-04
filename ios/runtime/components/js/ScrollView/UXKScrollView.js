window._UXK_Components.SCROLLVIEW = {
    scroller: {
        onDragStart: function (dom, sender) {
            dom._tmp_scroll_start = {
                x: 0,
                y: 0,
            };
            if (typeof $(dom).attr('contentoffset') === "string") {
                dom._tmp_scroll_start = {
                    x: parseFloat($(dom).attr('contentoffset').split(',')[0]),
                    y: parseFloat($(dom).attr('contentoffset').split(',')[1]),
                }
            }
        },
        onBeingDrag: function (dom, sender) {
            var contentOffset = {
                x: dom._tmp_scroll_start.x,
                y: dom._tmp_scroll_start.y + parseFloat(sender.translateY),
            }
            dom.setAttribute('contentOffset', contentOffset.x + ',' + contentOffset.y);
            $(dom).update();
        },
        onDragEnd: function (dom, sender) {
            $(dom).find("[vKey='contentView']").decay({
                aniProps: 'frame',
                velocity: '0,' + sender.velocityY + ',0,0',
                onChange: function (frame) {
                    $(dom).attr('contentoffset', frame.x + ',' + frame.y);
                }
            });
        }
    },
    onLoad: function (dom) {
        var obj = this;
        $(dom).onTouch(function (sender) {
            if (sender.state == "Began") {
                $(dom).find("[vKey='contentView']").stop();
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
