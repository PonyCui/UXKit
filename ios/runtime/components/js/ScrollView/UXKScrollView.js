window._UXK_Components.SCROLLVIEW = {
    onLoad: function (dom) {
        $(dom).onPan(function (sender) {
            var contentOffset = {
                x: 0,
                y: sender.translateY,
            }
            var contentSize = {
                width: -1,
                height: 0,
            }
            dom.setAttribute('contentOffset', contentOffset.x + ',' + contentOffset.y);
            $(dom).update();
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
                width: props.contentsize.split(',')[0],
                height: props.contentsize.split(',')[1],
            }
        }
        if (typeof props.contentoffset === "string") {
            contentOffset = {
                x: props.contentoffset.split(',')[0],
                y: props.contentoffset.split(',')[1],
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
