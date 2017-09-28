var ATWebViewBridge ={
    
callNativeFunction:function(functionString,params,callBack,returnValue){
    
    var methodName = (functionString.replace(/function\s?/mi,"").split("("))[0];
    var callBackName = methodName + 'CallBack';
    var message;
    
    if(!callBack){
        
        message = {'methodName':methodName,'params':params};
        window.webkit.messageHandlers.ATWebViewBridge.postMessage(message);
        
    }else{
        message = {'methodName':methodName,'params':params,'callBackName':callBackName};
        if(!Event._listeners[callBackName]){
            Event.addEvent(callBackName, function(data){
                           
                           callBack(data);
                           
                           });
        }
        window.webkit.messageHandlers.ATWebViewBridge.postMessage(message);
    }
    if(returnValue) {
        var returnValueName = methodName + 'ReturnValue';
        if(!Event._listeners[returnValueName]){
            Event.addEvent(returnValueName, function(data){
                           returnValue(data);
                           });
        }
        
    }
},
    
callBack:function(callBackName,data){
    
    Event.fireEvent(callBackName,data);
    
},
    
removeAllCallBacks:function(data){
    Event._listeners ={};
},
   
returnValue:function(returnValueName,data) {
    Event.fireEvent(returnValueName,data);
}

};



var Event = {
    
_listeners: {},
    
    
addEvent: function(type, fn) {
    if (typeof this._listeners[type] === "undefined") {
        this._listeners[type] = [];
    }
    if (typeof fn === "function") {
        this._listeners[type].push(fn);
    }
    
    return this;
},
    
    
fireEvent: function(type,param) {
    var arrayEvent = this._listeners[type];
    if (arrayEvent instanceof Array) {
        for (var i=0, length=arrayEvent.length; i<length; i+=1) {
            if (typeof arrayEvent[i] === "function") {
                arrayEvent[i](param);
            }
        }
    }
    
    return this;
},
    
removeEvent: function(type, fn) {
    var arrayEvent = this._listeners[type];
    if (typeof type === "string" && arrayEvent instanceof Array) {
        if (typeof fn === "function") {
            for (var i=0, length=arrayEvent.length; i<length; i+=1){
                if (arrayEvent[i] === fn){
                    this._listeners[type].splice(i, 1);
                    break;
                }
            }
        } else {
            delete this._listeners[type];
        }
    }
    
    return this;
}
};


