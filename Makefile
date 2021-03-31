
docker:
	docker build -f ./.project_metadata/circleci_base_image/Dockerfile \
		-t docker.pkg.github.com/abrahamvarricatt/personal_terraform_infra/circle_base_image:1.0 \
		.

push_circle_base:
	cat ~/.ssh/037_personal_terraform_infra.txt | docker login https://docker.pkg.github.com -u abrahamvarricatt --password-stdin
	docker push docker.pkg.github.com/abrahamvarricatt/personal_terraform_infra/circle_base_image:1.0

