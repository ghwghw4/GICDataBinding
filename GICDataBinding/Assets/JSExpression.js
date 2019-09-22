
function observeArray(array) {
    var proxy = new Proxy(array, {
        get(target, key) {
            var value = target[key]
            return observeObject(value)
        }
    });
    return proxy
}

function observeObject(target) {
    if (typeof target !== "object") {
        return target;
    }

    if (target instanceof Array) {
        return observeArray(target)
    }

    if (!canObserve(target)) {
        return target
    }

    var proxy = new Proxy(target, {
        get(target, key) {
            var value = getValue(target, key)
            return observeObject(value)
        },
        set(target, key, value){
            setValue(target,key,value)
        }
    }); 
    return proxy
}


function calcuExpression(target, exp) {
    var $ = observeObject(target)
    return eval(exp)
}

function fireEvent(target, exp,eventInfo) {
    var $ = observeObject(target)
    var $eventInfo = observeObject(eventInfo);
    return eval(exp)
}