window._UXK_Components.ACTIONSHEET = {
    props: function (dom) {
        return {
            title: $(dom).attr('title') ? $(dom).attr('title').split(',') : [],
            cancelTitle: "取消",
            dangerIndex: $(dom).attr('dangerIndex') ? parseInt($(dom).attr('dangerIndex')) : -1,
        };
    },
    setProps: function (dom, props) {
        var actionSheetProps = window._UXK_Components.ACTIONSHEET.props(dom);
        var buttonDOM = [];
        // Option Button
        for (var index = 0; index < actionSheetProps.title.length; index++) {
            if (index > 0) {
                buttonDOM.push('<pixelline frame="0,' + (55.0 * index) + ',-1,_" backgroundColor="#dcdcdc"></pixelline>');
            }
            var element = actionSheetProps.title[index];
            var tintColor = index == actionSheetProps.dangerIndex ? "#e04d2c" : '#333333';
            buttonDOM.push("<button textFont='16' tintColor='" + tintColor + "' title='" + element + "' frame='0," + (55.0 * index) + ",-1,55'></button>");
        }
        // Cancel Button
        buttonDOM.push("<button textFont='16' tintColor='#999999' backgroundColor='#f8f8f8' title='" + actionSheetProps.cancelTitle + "' frame='0," + (55.0 * index) + ",-1,55'></button>");
        // Inner HTML
        dom.querySelector("[vKey='buttonView']").innerHTML = buttonDOM.join('');
        setTimeout(function () {
            $(dom).find('button').each(function (idx, btn) {
                $(btn).onTouchUpInside(function () {
                    if (idx < actionSheetProps.title.length) {
                        if (typeof dom._onselect === "function") {
                            dom._onselect.call(this, idx);
                        }
                    }
                    else {
                        if (typeof dom._oncancel === "function") {
                            dom._oncancel.call(this);
                        }
                    }
                    $(dom).hide();
                });
            })
        }, 0);
    },
    onLoad: function (dom) {
        $(dom).find("[vKey='maskView']").onTap(function () {
            $(dom).hide();
        });
    },
};

$.createIMP('show', 'ACTIONSHEET', function () {
    var dom = $(this).get(0);
    var actionSheetProps = window._UXK_Components.ACTIONSHEET.props($(this).get(0));
    $(dom).find('modal').show(function () {
        $(dom).find('modal').find("[vKey='maskView']").fadeIn();
        $(dom).find('modal').find("[vKey='maskView']").value('frame', function (frame) {
            $(dom).find('modal').find("[vKey='buttonView']").attr('frame', '0,' + frame.height + ',-1,' + ((actionSheetProps.title.length + 1) * 55.0));
            $(dom).find('modal').find("[vKey='buttonView']").update();
            setTimeout(function () {
                $(dom).find('modal').find("[vKey='buttonView']").attr('frame', '0,' + (frame.height - ((actionSheetProps.title.length + 1) * 55.0)) + ',-1,' + ((actionSheetProps.title.length + 1) * 55.0));
                $(dom).find('modal').find("[vKey='buttonView']").spring({
                    speed: 20.0,
                    bounciness: 1.0,
                });
            }, 100)
        });
    });
});

$.createIMP('hide', 'ACTIONSHEET', function () {
    var dom = $(this).get(0);
    var actionSheetProps = window._UXK_Components.ACTIONSHEET.props($(this).get(0));
    $(dom).find('modal').find("[vKey='maskView']").fadeOut();
    $(dom).find('modal').find("[vKey='maskView']").value('frame', function (frame) {
        $(dom).find('modal').find("[vKey='buttonView']").attr('frame', '0,' + frame.height + ',-1,' + ((actionSheetProps.title.length + 1) * 55.0));
        $(dom).find('modal').find("[vKey='buttonView']").spring({
            speed: 40.0
        });
        setTimeout(function () {
            $(dom).find('modal').hide();
        }, 300)
    });
});

$.createIMP('onSelect', 'ACTIONSHEET', function (callback) {
    $(this).get(0)._onselect = callback;
})

$.createIMP('onCancel', 'ACTIONSHEET', function (callback) {
    $(this).get(0)._oncancel = callback;
})