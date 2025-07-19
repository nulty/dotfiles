# name=$(docker ps -l --format '{{.Names}}')
# d stop $name
drm() {
docker rm $(docker ps -aq)
docker rmi $(docker images -f"dangling=true" -q)
docker rmi dotfiles-test:latest
# docker run -it dotfiles-test:latest /bin/bash
}



dr() {
name=$(docker ps -l --format '{{.Names}}')
echo STARTING $name ...
d cp .bashrc $name:/home/dotty/contents/.bashrc.new
d cp setup.sh $name:/home/dotty/contents/.setup.sh
docker start $name
docker attach $name
}
# docker exec -it $name /bin/bash
#
#
#
# mv .bashrc.new .bashrc
