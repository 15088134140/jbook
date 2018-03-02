> 作者：*Mark*　　来源：*原创*　　同步发布：*[www.jsin.net](http://www.jsin.net)*  
> *转载请注明出处*

## Array.filter去重
```js
  [1, 2, 2, 4, 4].filter((item, index, arr) => arr.indexOf(item) === index); // => [1, 2, 4]
```
## ES6中使用Set去重
```js
  [...new Set([1, 2, 2, 4, 4])] // => [1, 2, 4]
```