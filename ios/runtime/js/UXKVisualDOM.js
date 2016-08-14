window._UXK_VisualDOMNames = ["BODY", "VIEW"];
window._UXK_VisualDOMAttrs = ["frame", 
                              "userInteractionEnabled", 
                              "transform",
                              "clipsToBounds",
                              "backgroundColor",
                              "alpha",
                              "hidden",
                              ];
window._UXK_VisualDOM = function () {
    return {
        guid: function () {
            function s4() {
                return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
            }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
        },
        update: function (node, onlyProps) {
            if (node === undefined) {
                node = document.body;
            }
            if (onlyProps === true) {
                this.commitTree(node, true);
            }
            else {
                this.assignKeys(node);
                this.commitTree(node);
            }
        },
        assignKeys: function (node) {
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                var childNode = childNodes[i];
                if (window._UXK_VisualDOMNames.indexOf(childNode.nodeName) < 0) {
                    continue;
                }
                if (!childNode.hasAttribute("_UXK_vKey")) {
                    childNode.setAttribute("_UXK_vKey", this.guid());
                }
                this.assignKeys(childNode);
            }
        },
        createTree: function (node, onlyProps) {
            if (window._UXK_VisualDOMNames.indexOf(node.nodeName) < 0) {
                return undefined;
            }
            var tree = {
                name: node.nodeName,
                vKey: node.getAttribute("_UXK_vKey"),
                props: {},
                subviews: [],
            };
            for (var i = 0; i < window._UXK_VisualDOMAttrs.length; i++) {
                var attr = window._UXK_VisualDOMAttrs[i];
                if (node.hasAttribute(attr)) {
                    tree.props[attr] = node.getAttribute(attr);
                }
            }
            if (onlyProps === true) {
                delete tree.subviews;
                return tree;
            }
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                var childNode = childNodes[i];
                var branch = this.createTree(childNode);
                if (branch !== undefined) {
                    tree.subviews.push(branch);
                }
            }
            return tree;
        },
        commitTree: function (node, onlyProps) {
            try {
                webkit.messageHandlers.UXK_ViewUpdater.postMessage(JSON.stringify(this.createTree(node, onlyProps)));
            } catch (err) {
                console.log("UXK_ViewUpdater not ready.");
            }
        },
    };
};
