> 作者：*Mark*　　来源：*原创*　　同步发布：*[www.jsin.net](http://www.jsin.net)*   GitHub：*[jbook](https://github.com/15088134140/jbook/tree/master/doc)*  
> *转载请注明出处*   

## 使用场景
在一些应用场景中，我们需要监听一些在短时间可能高频触发的事件后进行些处理。

如我们可能：

监听`input`事件，通过获取输入值后通过接口模糊查询并显示候选值。

监听`resize`事件，在浏览器窗口大小变化时，改变一些元素的高度或宽度，使之永远充满全屏。

监听`scroll`事件，在滚动页面时，获取滚动的距离来操作一些元素属性，以达到特定的效果。

以`input`事件为例：
```html 
 <input id="my-text-box-1"/>
 <div id="messages" style="white-space:pre;"></div>
```
```js
var input = document.querySelector('#my-text-box');
var messages = document.querySelector('#messages');

input.addEventListener('input', function(){
  messages.textContent += '请求数据: ' + input.value + '\n';
});

```
上述代码在向`input`输入框中输入内容时，会不断触发`input`事件，并不断调用`handleInput`函数请求接口，直接对服务器造成不必要的压力。

## 解决方法
对于解决场景所述问题，可以采用节流函数。

节流函数：当第一次触发一个事件时，先`setTimout`让这个事件延迟一定时间后再执行，如果在这个时间间隔内又触发了该事件，那我们就`clear`掉原来的定时器，再`setTimeout`一个新的定时器延迟一会执行。

```js
function throttle(method, context, args) {
  //清除执行函数的定时器，第一次进入为空
  clearTimeout(method.tId); 
  
  //设置一个500ms后在指定上下文中执行传入的method方法的定时器。
  method.tId = setTimeout(function () {
    method.call(context, args);
  }, 500);
}
```

## 详细代码
*[代码演示地址](https://jsfiddle.net/qq352593779/0ytxsc7q/28/)*

```html 
未使用节流的输入框：<input id="my-text-box-1"/>
使用节流的输入框：<input id="my-text-box-2"/>
<div id="messages" style="white-space:pre;"></div>
```

```js
var input1 = document.querySelector('#my-text-box-1');
var input2 = document.querySelector('#my-text-box-2');

var messages = document.querySelector('#messages');

function handleInput(e) {
  messages.textContent += '请求数据: ' + e.target.value + '\n';
}

function throttle(method, context, args) {
  //清除执行函数的定时器，第一次进入为空
  clearTimeout(method.tId); 
  
  //设置一个500ms后在指定上下文中执行传入的method方法的定时器。
  method.tId = setTimeout(function () {
    method.call(context, args);
  }, 500);
}

input1.addEventListener('input', function(e){
  handleInput(e);
});

input2.addEventListener('input', function(e){
  // 使用节流函数
  throttle(handleInput, this, arguments);
});
```
