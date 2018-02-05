> 作者：*Mark*　　来源：*原创*　　同步发布：*[www.jsin.net](http://www.jsin.net)*  
> *转载请注明出处*

纯CSS红绿交通信号灯的实现基本上大同小异，网上的实例也不少，此篇主要是对网上实例精简后，对其原理加以说明。  
实例来自于：[CSS 红绿灯效果 | 菜鸟工具](https://c.runoob.com/codedemo/3122)

##观察红绿灯  
红绿灯的过程为：红灯亮 => 红灯亮，黄灯亮 => 红、黄熄灭，绿灯亮 => 绿灯闪烁并熄灭 => 从头开始  

##实现分析  
用纯CSS实现该效果，不像JS可以整体形式来处理，更没有定时器。而CSS样式具有独立性，因此这里将红、黄、绿灯独立开来，三者的亮度变化处于同步进行中，现用13秒的时间完成一个过程，之后不断重复，而又将一个过程分为5段，每20%为一段，如图。  
综上，实现这个过程，这里当然需要用到CSS的`animation`属性，并用`@keyframes`为每个灯自定义一个动画过程，再通过`infinite`不断重复此过程。  
更多CSS的`animation`用法：[animation - CSS - MDN - Mozilla](https://developer.mozilla.org/en-US/docs/Web/CSS/animation)  
CSS代码大概是下面这样子：
```html
.灯 {
	animation: 13s 灯对应的动画过程名 infinite;
}

@keyframes 灯对应的动画过程名 {
  0%{opacity: 1;}
  20%{opacity: 1;}
  40%{opacity: 1;}
  60%{opacity: .1;}
  80%{opacity: .1;}
  100%{opacity: .1;}
}
```

##具体实现  
这里需要实现三个灯的动画过程，因绿灯存在闪烁动画，具体实现稍有区别，具体代码如下：
```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>纯css红绿灯</title>
	<style type="text/css" media="screen">
		/* 维持形状的基本样式 */
		.trafficlight {
			border: 1px solid #ccc;
	    width: 100px;
	    padding: 20px;
	    margin: 0 auto;
		}
		
		.trafficlight>div {
			width: 100px;
		  height: 100px;
		  border-radius: 50%;
		}

		/* 关键代码 */
		.red {
			background: red;
			animation: 13s red infinite; /* 应用动画 */
		}
		.yellow {
			background: yellow;
			animation: 13s yellow infinite; /* 应用动画 */
		}
		.green {
			background: green;
			animation: 13s green infinite; /* 应用动画 */
		}
		

		/* 作用于红灯的动画 */
		@keyframes red{
		  0%{opacity: 1;}
		  20%{opacity: 1;}
		  40%{opacity: 1;}
		  60%{opacity: .1;}
		  80%{opacity: .1;}
		  100%{opacity: .1;}
		}

		/* 作用于黄灯的动画 */
		@keyframes yellow{
		  0%{opacity: .1;}
		  20%{opacity: .1;}
		  40%{opacity: 1;}
		  50%{opacity: .1;}
		  60%{opacity: .1;}
		  80%{opacity: .1;}
		  100%{opacity: .1;}
		}

		/* 作用于绿灯的动画 */
		@keyframes green{
		  0%{opacity: .1;}
		  20%{opacity: .1;}
		  40%{opacity: .1;}
		  60%{opacity: 1;}
		  80%{opacity: 1;}
		  85%{opacity: .1;}
		  90%{opacity: 1;}
		  95%{opacity: .1;}
		  100%{opacity: 1;}
		}
	</style>
</head>
	<body>
		<div class="trafficlight">
			<div class="red"></div>
			<div class="yellow"></div>
			<div class="green"></div>
		</div>
	</body>
</html>
```