import platform
import psutil


def info():
print('System:', platform.system(), platform.release())
print('CPU:', psutil.cpu_percent(interval=1))
print('Memory:', psutil.virtual_memory())
print('Disk:', psutil.disk_usage('/'))


if __name__ == '__main__':
info()