window._UXK_Components.SEGMENTEDCONTROL = {
    props: function (dom) {
        return {
            tintColor: $(dom).attr('tintColor') || "#209b53",
            backColor: $(dom).attr('backColor') || "#ffffff",
            selectedIndex: $(dom).attr('selectedIndex') ? parseInt($(dom).attr('selectedIndex')) : 0,
            title: $(dom).attr('title') ? $(dom).attr('title').split(',') : [],
        }
    },
    setProps: function (dom, props) {
        var segmentedControlProps = window._UXK_Components.SEGMENTEDCONTROL.props(dom);
        var width = dom.frame != undefined ? parseFloat(dom.frame.width) : 0.0;
        if (width == 0.0) {
            dom.setAttribute("hidden", 'true');
            return;
        }
        else {
            dom.setAttribute("hidden", 'false');
        }
        if (dom._props !== undefined && dom._props.tintColor === segmentedControlProps.tintColor && dom._props.title.join(',') === segmentedControlProps.title.join(',')) {
            if (dom._props.selectedIndex !== props.selectedIndex) {
                $(dom).find("[vKey='buttonView']").find("button").each(function (idx, btn) {
                    if (idx == segmentedControlProps.selectedIndex) {
                        $(btn).attr('selected', 'selected');
                    }
                    else {
                        $(btn).removeAttr('selected');
                    }
                });
            }
            dom._props = segmentedControlProps;
            return;
        }
        dom._props = segmentedControlProps;
        dom.querySelector("[vKey='borderView']").setAttribute("borderColor", segmentedControlProps.tintColor);
        var buttonDOM = [];
        var buttonProps =
            "textFont='13' " +
            "backgroundColorHighlighted='" + this.colorWithAlpha(segmentedControlProps.tintColor, 0.10) + "' " +
            "backgroundColorSelected='" + segmentedControlProps.tintColor + "' " +
            "backgroundColorNormal='#00ffffff" + "' " +
            "textColorHighlighted='" + segmentedControlProps.tintColor + "' " +
            "textColorSelected='" + segmentedControlProps.backColor + "' " + 
            "textColorNormal='" + segmentedControlProps.tintColor + "'";
        for (var index = 0; index < segmentedControlProps.title.length; index++) {
            if (index > 0) {
                buttonDOM.push('<view frame="' + ((width / segmentedControlProps.title.length) * index) + ',0,1,-1" backgroundColor="' + segmentedControlProps.tintColor + '"></view>');
            }
            var element = segmentedControlProps.title[index];
            buttonDOM.push("<button " + buttonProps + (index == segmentedControlProps.selectedIndex ? "selected" : "") + " title='" + element + "' frame='" + ((width / segmentedControlProps.title.length) * index) + ",0," + (width / segmentedControlProps.title.length) + ",-1'></button>");
        }
        dom.querySelector("[vKey='buttonView']").innerHTML = buttonDOM.join('');
        setTimeout(function () {
            $(dom).find('button').each(function (idx, btn) {
                $(btn).onTouchUpInside(function () {
                    $(dom).attr('selectedIndex', parseInt(idx).toString());
                    $(dom).update();
                    if (typeof dom._onchange === "function") {
                        dom._onchange.call(this, parseInt(idx));
                    }
                });
            })
        }, 0);
    },
    onLoad: function (dom) {
        $(dom).onLayout(function (frame) {
            dom.frame = frame;
            $(dom).update();
        })
        $(dom).value('frame', function (frame) {
            dom.frame = frame;
            $(dom).update();
        })
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

$.createIMP('onChange', 'SEGMENTEDCONTROL', function (callback) {
    $(this).get(0)._onchange = callback;
})