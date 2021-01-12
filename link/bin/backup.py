import os
import time
import shutil

# backup files in mac env to icloud drive

base_dir = '/Users/qiang/Library/Mobile Documents/com~apple~CloudDocs/'
backup_dir = base_dir + 'backup/'
files_to_backup = [
        base_dir + 'personal/qiang.kdbx',
        base_dir + 'personal/money/Home.xlsx'
]

for file_path in files_to_backup:
    if not os.path.isfile(file_path):
        raise Exception(file_path + ' not exist')

    dest_file_path = backup_dir + os.path.basename(file_path) + '.' + time.strftime('%Y%m%d')
    shutil.copyfile(file_path, dest_file_path)
