import ftplib
import os
from datetime import datetime, timedelta

# FTP connection details
ftp_host = 'ftp.example.com'
ftp_user = 'username'
ftp_passwd = 'password'

# Remote and local directories
remote_dir = '/path/to/remote/directory/'
local_dir = '/path/to/local/directory/'

# Create new sub-directory with current date and time
current_time = datetime.now().strftime('%Y-%m-%d %H-%M-%S')
local_subdir = local_dir + current_time + '/'
os.makedirs(local_subdir)

# Connect to FTP server
ftp = ftplib.FTP(ftp_host)
ftp.login(ftp_user, ftp_passwd)
ftp.cwd(remote_dir)

# Get list of files in remote directory
files = ftp.nlst()

# Loop through files and download to local sub-directory
for file in files:
    # Get file timestamp
    timestamp = ftp.sendcmd('MDTM ' + file).split()[1]
    file_time = datetime.strptime(timestamp, "%Y%m%d%H%M%S")
    # Check if file is no older than 20 hours
    if (datetime.now() - file_time) < timedelta(hours=20):
        with open(local_subdir + file, 'wb') as f:
            ftp.retrbinary('RETR ' + file, f.write)

# Close FTP connection
ftp.quit()
