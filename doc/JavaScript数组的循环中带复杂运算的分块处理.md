> 作者：*Mark*　　来源：*原创*　　同步发布：*[www.jsin.net](http://www.jsin.net)*  GitHub：*[jbook](https://github.com/15088134140/jbook/tree/master/doc)*  
> *转载请注明出处*

## 使用场景
存在一个长度为1000的坐标数组，现需要遍历每个坐标值，通过计算得到另一组相同长度的计算结果。  
当然这里坐标数组的长度可能更大。

## 一般解决方法
```js
// 构建一个1000长度的坐标数组
var coordinates = new Array(1e3).fill(0).map(item => {
  return { x: Math.random() * 1000,  y: Math.random() * 1000 }
});

// 得到计算的结果
var result = coordinates.map(coo => {
  // 模拟大量计算
  for (var i = 0; i < 10000000; i++) {
    Math.random();
  }
  return coo;
});
```
将上述代码复制到控制台，运行后，发现浏览器长时间没有响应，甚至卡死、崩溃。因为在浏览器的一个页面中，该页面的JS程序只有一个线程。
## 分块处理
还是原来的数组，但这里将数组分成一块一块依次处理。

```js
/**
 * 数组分块函数
 * @param  {Array} array   [待分块的数组]
 * @param  {Function} process [处理块的函数]
 * @param  {Object} content [执行上下文]
 * @return {Array}         [计算结果]
 */
function chunk(array, process, content) {
  setTimeout(() => {
    var item = array.shift();
    process.call(content, item);

    if(array.length > 0){
      // console.log('arguments.callee', arguments.callee)
      setTimeout(() => {
        arguments.callee && arguments.callee(array, process, content);
      }, 100);
    }
  }, 100);
}

var result = [];

function processFn(chunkItem) {
  // 模拟大量计算
  for (var i = 0; i < 10000000; i++) {
    Math.random();
  }
  console.log(result.push(chunkItem));
}
// 调用分块处理函数，开始处理数组
chunk(coordinates, processFn, this);
```
当然使用`setInterval`可达到的一致的效果
上述代码虽然解决了浏览器长时间无响应的问题，但对于`result`却无法在`chunk`函数调用之后获得。改用`Promise`可以解决此问题。