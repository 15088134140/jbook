> 作者：*Mark*　　来源：*翻译*　　原文地址：*[YouTube视频](https://www.youtube.com/watch?v=-3Lu3t3R3mg)*　　同步发布：*[www.jsin.net](http://www.jsin.net)*  
> *转载请注明出处*   
## 问题描述   
最近（2018年4月）发现Sublime Text3(版本3143)会弹出“Your license key is no longer valid, and has been removed”后已注册的License会被自动移除。虽然可以再次成功输入License，但几分钟后又会弹出弹框，License会被再次移除，如图：
![GitHub](https://github.com/15088134140/jbook/blob/master/assets/imgs/1.png "问题弹窗")
## 问题解决   
今天(2018年5月2日)终于在Google上找到了答案，但该答案是YouTube上的英语视频资源。按照步骤，确实可以解决该问题，因此将内容翻译，希望能帮助更多遇到此问题的朋友。   
1.以管理员权限打开并编辑windows系统的hosts文件。*[附：windows系统下快速打开该文件的bat脚本](https://github.com/15088134140/jbook/blob/master/assets/others/EditHosts.bat)*    
hosts的文件位置:    
C:\Windows\System32\drivers\etc (Windows)   
/etc/hosts (Linux / Mac)   
   
2.在hosts文件末尾追加如下映射后保存。
```
# Sublime Text 3
0.0.0.0 license.sublimehq.com
0.0.0.0 45.55.255.55
0.0.0.0 45.55.41.223
```
注意：系统防火墙的影响.   
   
3.打开Sublime Text 3,打开工具栏`Help>Enter License`，复制下面注册码。
```
—– BEGIN LICENSE —–
TwitterInc
200 User License
EA7E-890007
1D77F72E 390CDD93 4DCBA022 FAF60790
61AA12C0 A37081C5 D0316412 4584D136
94D7F7D4 95BC8C1C 527DA828 560BB037
D1EDDD8C AE7B379F 50C9D69D B35179EF
2FE898C4 8E4277A8 555CE714 E1FB0E43
D5D52613 C3D12E98 BC49967F 7652EED2
9D2D2E61 67610860 6D338B72 5CF95C69
E36B85CC 84991F19 7575D828 470A92AB
—— END LICENSE ——
```   
   
4.完成
