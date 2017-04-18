docker stop hhc
docker rm hhc
docker build -t hhc ./
docker run -d -p 8888:443 --name hhc hhc

