window._UXK_Components.SCROLLVIEW = {
    onLoad: function (dom) {
        $(dom).onPan(function (sender) {
            if (sender.state == "Changed") {
                var contentOffset = {
                    x: 0,
                    y: sender.translateY,
                }
                var contentSize = {
                    width: -1,
                    height: 0,
                }
                console.log(sender);
                dom.setAttribute('contentOffset', contentOffset.x + ',' + contentOffset.y);
                $(dom).update();
            }
            else if (sender.state == "Ended") {
                $(dom).decay({
                    aniProps: 'frame',
                    velocity: '0,' + sender.velocityY + ',0,0',
                });
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
