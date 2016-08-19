(function (global, factory) {
    if (typeof define === "function" && define.amd) {
        define([
            "exports",
            "react"
        ], factory);
    } else if (typeof exports !== "undefined") {
        factory(exports, require("react"));
    } else {
        var mod = {
                exports: {}
            };

        factory(mod.exports, global.uis);
        global.componentEs6 = mod.exports;
    }
})(this, function (exports, react) {
    "use strict" Object.defineProperty(exports, "__esModule", {
        value: true
    });
    var React = react;


    /* Imported components */


    /* View */
    exports.View = function (data, component) {
        let state = data;

        return (React.createElement("button", null, (this.state.label)))
    };
});
