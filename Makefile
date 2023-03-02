all: build zip

build:
	rm -f bin/main 2> /dev/null
	rm -f demo-function.zip 2> /dev/null
	GOOS=linux GOARCH=amd64 go build -ldflags '-s -w' -a -o bin/main main.go

zip:
	zip -j -D -r demo-function.zip bin/bootstrap bin/main

clear:
	rm -f bin/main 2> /dev/null
	rm -f demo-function.zip 2> /dev/null