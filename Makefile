
docker:
	./.project_metadata/docker/build_docker_image.sh

push_circle_base:
	./.project_metadata/docker/push_image_to_github.sh

