# deploy.ps1
Set-Location C:\Users\User\desktop\HUGO\fuzaze\
hugo
docker stop fuzaze-site 2>$null
docker rm fuzaze-site 2>$null
docker run -d --name fuzaze-site -p 8081:80 -v C:/Users/User/desktop/HUGO/fuzaze/public:/usr/share/nginx/html:ro nginx
Write-Host "Site available at http://localhost:8081"