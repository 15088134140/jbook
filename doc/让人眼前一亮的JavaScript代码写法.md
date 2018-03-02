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
## ES6中变量重命名
当运行上文中已存在一个名为`name`的变量时，如果运用ES6的解构赋值`let { name } = book`将会出现重复定义的错误。
```js
  let name = 'Mark';
  let book = {name: '《JavaScript从入门到放弃》', author: '张三'};
 	
  let { name: bookName, author } = book;
  // 相当于
  // let bookName = book.name;
  // let author = book.author;
  // 可能需要更多变量...

  console.log(`${ name }读了${ author }写的${ bookName }受益匪浅。`);
  // => Mark读了张三写的《JavaScript从入门到放弃》受益匪浅。
```
