> 作者：*Mark*　　来源：*原创*　　同步发布：*[www.jsin.net](http://www.jsin.net)*   GitHub：*[jbook](https://github.com/15088134140/jbook/tree/master/doc)*  
> *转载请注明出处*   

因为浏览器为显示页面而进行的重排和重绘是不可避免且非常耗资源的，所以前端性能的优化其主要工作就是优化重排和重绘。   

## 减少DOM操作
原生的JS和传统的JS库（如JQ），都是直接对页面DOM元素进行操作，而对DOM的操作可能会引起重排和重绘，因此，减少DOM操作的次数是一个很好的优化手段。  

假如我们要为`ul`添加100个`li`，方法有两种：  

方法1：一个一个`li`加进去。（100次重排100次重绘）   
方法2：准备100个`li`批量加进去。（1次重排1次重绘）   

显而易见，方法2更加高效，将100次DOM操作缩减为了1次
```js
let ul = document.querySelector('ul');

// bad
for(let i = 0; i < 100; i++) {
  let li = document.createElement('li');
  ul.appendChild(li);
}

// good
let fragment = document.createDocumentFragment();
for(let i = 0; i < 100; i++) {
  let li = document.createElement('li');
  fragment.appendChild(li);
}
ul.appendChild(fragment);

// good
let lis = []
for(let i = 0; i < 100; i++) {
  let li = document.createElement('li');
  lis.push(li);
}
$(ul).append(lis);
```   

通过文档碎片`fragment`可以打包一组待添加的元素，然后将整体添加到真实DOM树中。   

*[fragment](https://developer.mozilla.org/zh-CN/docs/Web/API/DocumentFragment)*  了解一下。

很多JS库都提供批量操作DOM的接口，如上述代码所示的`append`，在实际开发过程中可以多加使用。    

另外`MVVM`框架（如vue，angular等）增加了 `ViewModel` 层，通过双向数据绑定把 `View` 层和 `Model` 层连接了起来，用数据来驱动界面显示，很大程度的减少了对DOM的直接操作。   

*[MVVM双向绑定原理](https://juejin.im/entry/5996654451882524382f43db)*  了解一下。   

## 适当保存变量
对于一些在上下文反复使用的计算结果，最好使用变量将结果保存下来，避免重复计算时间开销和内存消耗。
```js
// bad
let sum = 0;
let array = [-1, 1, 2, 3];
if(array.filter(item => item > 0).length > 0) {
  sum = array.filter(item => item > someValue).reduce((acc, curr) => {
    return acc += curr;
  }, 0);
}

// good
let sum = 0;
let array = [-1, 1, 2, 3];
let computedArray = array.filter(item => item > 0);

if(computedArray.length > 0) {
  sum = computedArray.reduce((acc, curr) => {
    return acc += curr;
  }, 0);
}
```   
当然对于反复使用的DOM元素也可以先用变量保存下来，避免每次使用都重新获取。   
```js
// bad
$('ul').append(li);
$('ul').addClass('className');

// good
let $ul = $('ul');
$ul.addClass('className');
$ul.append(li);

// good 链式调用
$('ul').addClass('className').append(li);
```   

## 减少全局变量
虽然对于一些在上下文需要使用的计算结果最后用定义出变量来保存，但是若非必要，不要把变量定义成全局变量，而应该定义为局部变量。    

全局变量是不会被回收释放的，太多的全局变量会占用浏览器的内存，而局部变量一般在函数执行结束后会通过浏览器的回收机制进行释放。   

全局变量会引起全局变量污染，造成很多意外的结果。   
```js 
// bad
var value = 'something';

function doSomeThing() {
  console.log(value); // => 'something'
}

console.log(value); // => 'something'

// good
function doSomeThing() {
  var value = 'something';
  console.log(value); // => 'something'
}

console.log(value); // => 报错
```
当然 模块化思想 和使用 严格模式 在一定程度上都可以解决这个问题。   

*[知乎回答](https://zhuanlan.zhihu.com/p/25489604)* 了解一下。

## 减少不必要DOM元素和嵌套
浏览器在渲染页面有一个很重要的过程就是根据HTML生成DOM树，当然这颗树越小、枝叶越少生成和渲染的速度就会越快。   

所以我们可以通过减少不必要的DOM元素和嵌套关系来精简这棵树，有时我们可以使用一些CSS伪元素来代替DOM元素节点。      

另外对于一些随便上万的列表，当然没必要把列表项的DOM节点一次全部加入到页面。（即使一次加入页面也是卡得没法用）    

这时分页当然是最简单的解决方案。    

但为了保证阅读的连续性，滚动加载也是一个可选方案，不过滚动加载随着滚动得越多页面列表项的DOM元素也会越来越多，最终也难逃卡顿的结局。   

当然最好的思路应该是：只渲染视野能看到的DOM元素，移除视野外的DOM元素，即DOM的回收功能。   

*[用 Vue 实现带 Dom 回收功能的无尽滚动列表组件](https://juejin.im/entry/58bd3a33a22b9d005ef15ca0)* 了解一下。

## DOM的读写操作不要交替进行
以下代码来自于阮一峰老师的网络日志，基础上加入注释。    

```js
// bad
// 读取div的offsetLeft后修改（写）div的left
div.style.left = div.offsetLeft + 10 + "px";

// 读取div的offsetTop后修改（写）div的top
div.style.top = div.offsetTop + 10 + "px";

// good
// 读取div的offsetLeft和offsetTop
var left = div.offsetLeft;
var top  = div.offsetTop;

// 修改（写）div的left和top
div.style.left = left + 10 + "px";
div.style.top = top + 10 + "px";
```

## 批量改变样式
一条一条的改变样式会不断的触发浏览器渲染，批量改变会减少渲染触发的频率，而且使代码便于维护，推荐使用增减class的方式批量改变元素样式。   

以下代码来自于阮一峰老师的网络日志。   

```js
// bad
var left = 10;
var top = 10;
el.style.left = left + "px";
el.style.top  = top  + "px";

// good 
el.className += " theclassname";

// good
el.style.cssText += "; left: " + left + "px; top: " + top + "px;";
```
## 尽量避免复杂选择器的使用
关于常用的部分CSS选择器效率从高到低的排序如下，对于一些不常用的选择器应尽量减少使用。   

引用自Steve Souders的Even Faster网站。   

1. ID选择器 比如 `#header`
2. 类选择器 比如 `.promo`
3. 元素选择器 比如 `div`
4. 兄弟选择器 比如 `h2 + p`
5. 子选择器 比如 `li > ul`
6. 后代选择器 比如 `ul a` 
7. 通用选择器 比如 `*`
8. 属性选择器 比如 `type = 'text'`
9. 伪类/伪元素选择器 比如 `a:hover`

更详细的说明 *[CSS selector performance](http://ecss.io/appendix1.html)* 了解一下。   

当然JS选择器也类似。

## 减少HTTP请求
减少HTTP请求最大的作用是为服务器减压，当然在一定程度上对前端性能的提高也有一定作用。

资源合并是减少HTTP请求的一个重要方法。    

方法1：将页面原本引入的多个JS和多个CSS文件合并成一个。   
方法2：采用字体图标来替换图片图标。   
方法3：图片采用Base64编码。    
方法4：采用CSS图片整合（CSS Sprites、 CSS精灵图、雪碧图），将页面里所涉及到的所有的零星的图片都整合到一张大图中去，然后利用`background-position`来决定显示的图片。   
...

`webpack`等前端编译工具已经很好的整合了上述功能。

## 规范使用HTTP请求
最常用的HTTP请求有`GET`、`POST`、`PUT`、`DELETE`等。    

不同的服务器对不同的请求的处理方式有所差异，当然也体现在处理速度上面。     

因此规范使用HTTP也是很重要的。     

一般获取数据使用`GET`、提交数据使用`POST`、修改数据使用`PUT`、删除数据使用`DELETE`。   

更详细的说明 *[你敢在post和get上刁难我，就别怪我装逼了 - 掘金](https://juejin.im/post/59fc04ecf265da4317697f26)* 了解一下，原文随可能存在部分错误，但在文章首部提供了正确参考地址。   

## 延迟或异步加载资源
对于`<script>`标签，有`defer`和`async`两个属性可选。也是平时延迟或异步加载脚本的主要方法。但是使用时请注意浏览器及其版本是否支持该属性。   

```js
// 页面将停止解析HTML开始下载脚本，下载完成后执行，执行完成后继续解析未解析完的HTML。
<script src="test.js" />
// 页面将在解析HTML时异步下载脚本，等HTML全部解析完成后，执行脚本。
<script src="test.js" defer />
// 页面将在解析HTML时异步下载脚本，下载完成后，停止解析HTML，开始执行脚本，执行完成后继续解析未解析完的HTML。
<script src="test.js" async />
```

然后再补充一张图    

蓝色线代表网络读取，红色线代表执行时间，这俩都是针对脚本的；绿色线代表 HTML 解析。（图片来源于网络，侵删）   

![GitHub](https://raw.githubusercontent.com/15088134140/jbook/master/assets/imgs/2.jpg "延迟或异步加载资源")  

另外webpack等前端工具整合的按需加载也可以达到延迟加载资源的效果。    

## 压缩资源大小
无论是JS、CSS、HTML都可以才用去除空行、空格、换行符、注释等方法来压缩资源的大小。     

当然JS还可以采用缩短变量或方法名来减小资源的大小。    

以上均是`webpack`等前端编译工具的基本做法。   

当然`webpack`采用打包成块的方式，所以应该尽量减小最后块的大小，因此对于一些公共资源可以打包成公共块来减小最后结果块的体积。

## 避免用cookie存储数据
前端存储有多种方式，如`localstorage`、`cookie`、`IndexedDB`等。    

其中`cookie`虽然可用于前端存储数据，早期的WEB开发也确实如此使用，但是存储在`cookie`中的数据每次请求都会被浏览器自动放在`http`请求中，而且存储的数据越多，增加的不必要网络开销也就越大。   

因此，除了如用户会话标识等身份认证信息可以存储在`cookie`中外，其它信息不要存储在`cookie`中。    

另外为`cookie`设置适当的过期日期也是不可少的。

## HTML标签语义化
虽然很多时候我们使用`div+span+css`已经足以实现所有的样式效果，但是HTML还是提供了很多语义化的标签，如：`article`、`nav`、`section`、`button`、`i`、`strong`、`address`、`mark`等。     

这些语义化的标签本身就具有其默认的样式效果，如`strong`标签以加粗的形式展现，表示这个文本的重要性。    

HTML语义化能让浏览器更容易“理解”页面的结构，有利于搜索引擎优化（SEO），同时也使HTML代码结构化，便于后期维护。     

## 参考
*[网页性能管理详解 - 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2015/09/web-page-performance-in-depth.html)*   

*[浏览器前端优化](https://juejin.im/entry/59105474ac502e0065505aca)*
     
     
     
未完……