window._UXK_Components.ALERTVIEW = {
    props: function (dom) {
        return {
            title: $(dom).attr('title') || undefined,
            message: $(dom).attr('message') || undefined,
            buttons: $(dom).attr('buttons') ? $(dom).attr('buttons').split(',') : [],
        };
    },
    setProps: function (dom, props) {
        var alertViewProps = window._UXK_Components.ALERTVIEW.props(dom);
        var width = dom.frame != undefined ? dom.frame.width : 0.0;
        $(dom).find("[vKey='titleLabel']").text(alertViewProps.title);
        $(dom).find("[vKey='messageLabel']").text(alertViewProps.message);
        if (alertViewProps.message === undefined) {
            $(dom).find("[vKey='messageLabel']").attr('frame', '|-25-[1000],|-25-[*]');
        }
        else {
            $(dom).find("[vKey='messageLabel']").attr('frame', '|-25-[1000],|-50-[*]');
        }
        var buttonDOM = [];
        for (var index = 0; index < alertViewProps.buttons.length; index++) {
            var element = alertViewProps.buttons[index];
            if (alertViewProps.buttons.length <= 1) {
                buttonDOM.push('<button frame="|-0-[]-0-|,|-0-[44]" title="' + element + '"></button>');
            }
            else if (alertViewProps.buttons.length == 2) {
                if (index == 0) {
                    buttonDOM.push('<button frame="|-0-[|*0.5],|-0-[44]" title="' + element + '"></button>');
                    buttonDOM.push('<pixelline frame="<-0-[_],|-0-[]-0-|"></pixelline>');
                }
                else if (index == 1) {
                    buttonDOM.push('<button frame="[|*0.5]-0-|,|-0-[44]" title="' + element + '"></button>');
                }
            }
            else {
                if (index > 0) {
                    buttonDOM.push('<pixelline frame="|-0-[]-0-|,<-0-[_]"></pixelline>');
                }
                buttonDOM.push('<button frame="|-0-[]-0-|,|-' + (44 * index) + '-[44]" title="' + element + '"></button>');
            }
        }
        $(dom).find("[vKey='buttonView']").html(buttonDOM.join(''));
        if (alertViewProps.buttons.length <= 1) {
            $(dom).find("[vKey='buttonView']").attr('frame', '|-0-[]-0-|,<-0-[44]');
            dom._buttonHeight = 44.0;
        }
        else if (alertViewProps.buttons.length == 2) {
            $(dom).find("[vKey='buttonView']").attr('frame', '|-0-[]-0-|,<-0-[44]');
            dom._buttonHeight = 44.0;
        }
        else {
            $(dom).find("[vKey='buttonView']").attr('frame', '|-0-[]-0-|,<-0-[' + (44 * alertViewProps.buttons.length) + ']');
            dom._buttonHeight = (44 * alertViewProps.buttons.length);
        }
    },
    onLoad: function (dom) {
        $(dom).find("[vKey='maskView']").onTap(function () {
            $(dom).hide();
        });
        $(dom).find("[vKey='messageLabel']").onLayout(function (frame) {
            dom._messageFrame = frame;
            if (frame.height <= 26.0) {
                $(dom).find("[vKey='messageLabel']").attr('align', 'center');
            }
            else {
                $(dom).find("[vKey='messageLabel']").attr('align', 'left');
            }
            $(dom).find("[vKey='messageLabel']").update();
            var width = dom.frame.width;
            var height = dom.frame.height;
            var contentHeight = (dom._messageFrame.y + dom._messageFrame.height + 18.0 + dom._buttonHeight);
            $(dom).find("[vKey='messageView']").attr('frame', width * 0.1 + ',' + ((height - contentHeight) / 2.0) + ',' + (width * 0.8) + ',' + contentHeight);
            $(dom).find("[vKey='messageView']").update();
        });
    },
};

$.createIMP('show', 'ALERTVIEW', function () {
    var dom = $(this).get(0);
    var alertViewProps = window._UXK_Components.ALERTVIEW.props(dom);
    $(dom).find('modal').show(function () {
        setTimeout(function () {
            $(dom).find('modal').find("[vKey='maskView']").value('frame', function (frame) {
                dom.frame = frame;
                var width = frame.width;
                var messageViewFrame = $(dom).find('modal').find("[vKey='messageView']").attr('frame').split(',');
                $(dom).find('modal').find("[vKey='messageView']").attr("frame", width * 0.1 + ',' + messageViewFrame[1] + ',' + (width * 0.8) + ',' + messageViewFrame[3]);
                if (alertViewProps.message === undefined) {
                    $(dom).find('modal').find("[vKey='messageLabel']").attr("frame", '|-25-[' + parseInt((width * 0.8 - 50)) + '],|-25-[*]');
                }
                else {
                    $(dom).find('modal').find("[vKey='messageLabel']").attr("frame", '|-25-[' + parseInt((width * 0.8 - 50)) + '],|-50-[*]');
                }
                $(dom).find('modal').find("[vKey='messageView']").update(function(){
                    $(dom).find('modal').fadeIn();
                });
            });
        }, 0)
    });
});

$.createIMP('hide', 'ALERTVIEW', function () {
    var dom = $(this).get(0);
    $(dom).find('modal').fadeOut();
    setTimeout(function () {
        $(dom).find('modal').hide();
    }, 300)
});