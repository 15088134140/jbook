> 作者：*Mark*　　来源：*原创*　　同步发布：*[www.jsin.net](http://www.jsin.net)*  GitHub：*[jbook](https://github.com/15088134140/jbook/tree/master/doc)*  
> *转载请注明出处*

## 使用场景
存在一个长度为1000的坐标数组，现需要遍历每个坐标值。

通过复杂的计算(单个计算时间较长)得到另一组相同长度的计算结果。

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
将上述代码复制到控制台，运行后，发现浏览器长时间没有响应，甚至卡死、崩溃。

因为在浏览器的一个页面中，该页面的JS程序只有一个线程。

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
    
    // 执行处理函数
    process.call(content, item);
    
    // 如果数组没有处理完，继续调用
    if(array.length > 0){
      setTimeout(() => {
        chunk(array, process, content);
      }, 10);
    }
  }, 10);
}

var result = [];

function processFn(chunkItem) {
  // 模拟大量计算
  for (var i = 0; i < 10000000; i++) {
    if(chunkItem) {
    	chunkItem.x += 1;
      chunkItem.y += 1;
    }
  }

  result.push(chunkItem);
  console.log('正在执行...');
}

// 调用分块处理函数，开始处理数组
chunk(coordinates, processFn, this);

// 该处无法获取到result
console.log(result);
```
当然使用`setInterval`可达到的一致的效果。但《JavaScript高级程序设计 第3版》提到，该方法存在两个问题：

> 某些间隔会被跳过   
> 多个定时器的代码执行间的间隔可能比预期的小

而上述`setTimeout`为该书实现的一个“高级定时器”，至于详细内容这里不再赘述。

上述代码虽然解决了浏览器长时间无响应的问题，但对于`result`却无法在`chunk`函数调用之后获得。

改用`Promise`可以解决此问题。

## Promise分块处理

```js
function runChunck(array, process, content) {
  return new Promise((resolve, reject) => {
    var result = [];

    var chunk = (array, process, content) => {
      var item = array.shift();
      var resultItem = process.call(content, item);
      result.push(resultItem);

      if(array.length > 0){
        setTimeout(() => {
          chunk(array, process, content);
        }, 10);
      } else {
        resolve(result);
      }
    }

    try {
      chunk(array, process, content);
    } catch (e) {
      throw e;
      reject(e);
    }
  });
}

function processFn(chunkItem) {
  // 模拟大量计算
  for (var i = 0; i < 10000000; i++) {
    if (chunkItem) {
      chunkItem.x += 1;
      chunkItem.y += 1;
    }
  }
  console.log('正在执行...');

  // result.push(chunkItem);
 	// 处理后的单元需要返回 
  return chunkItem;
}

runChunck(coordinates, processFn, this).then(result => {
  // 拿到结果做一些操作
  console.log('result', result);
  // success
}, error => {
  console.log(error);
  // failure
});
```
