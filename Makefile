SRC_DIR := lambda
APP_NAME := lambda_example
ARCHIVE_NAME := lambda_example.zip
MD5 := openssl md5 -hex < $(ARCHIVE_NAME)
MD5_FILE := lastbuild.md5
SHA := openssl sha256 -binary < $(ARCHIVE_NAME)
SHA_FILE := lastbuild.sha256
NO_TRAIL := tr -d '\n'

gobuild:
	cd $(SRC_DIR) && GOOS=linux go build -o $(APP_NAME)

archive:
	cd $(SRC_DIR) && zip $(ARCHIVE_NAME) $(APP_NAME)

build: clean gobuild archive
	cd $(SRC_DIR) && $(MD5) | $(NO_TRAIL) > $(MD5_FILE)
	cd $(SRC_DIR) && $(SHA) > $(SHA_FILE)
	@printf 'new "$(APP_NAME)" build ready, you might want to apply Terraform now\n'

clean:
	cd $(SRC_DIR) && rm -f $(APP_NAME) $(ARCHIVE_NAME)
