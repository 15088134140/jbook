@echo 现在请修改Hosts文件，并保存；如果你被提示因为权限问题而拒绝保存，请以管理员身份运行此程序
@notepad "%SystemRoot%\system32\drivers\etc\hosts"

@ipconfig /flushdns
@echo 正在刷新缓存，程序会自动退出。。
@exit