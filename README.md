# ATWebViewBridge
功能
1.保证了JS和OC代码中方法名的统一，便于两端开发配合。
2.支持OC回调参数到JS。
3.支持OC直接以返回值的形式将值传递到JS。


JS端使用注意：
参数写法
第一个：arguments.callee.toString()  即该方法的方法名
第二个：params   需要传递到OC的参数
第三个：匿名函数   从OC获取的回调
第四个：匿名函数   从OC获取的返回值

注：如不需要该参数可写 null
如：ATWebViewBridge.callNativeFunction(arguments.callee.toString(), params, null, function(data) {
//返回值
});

