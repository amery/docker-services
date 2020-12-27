USER = $(shell id -urn)
MAINTAINER = $(shell git config user.name) <$(shell git config user.email)>
PREFIX ?= $(USER)/
