BIN ?= bashutil
PREFIX ?= /usr/local
CMDS = log error trim retry bgo bgowait

install: uninstall
	#install $(BIN) $(PREFIX)/bin
	for cmd in $(CMDS); do cp $${cmd} $(PREFIX)/bin/$${cmd}; done

uninstall:
	#rm -f $(PREFIX)/bin/$(BIN)
	for cmd in $(CMDS); do rm -f $(PREFIX)/bin/$${cmd}; done

link: uninstall
	#ln -s $(BIN) $(PREFIX)/bin/$(BIN)
	for cmd in $(CMDS); do ln -s $${cmd} $(PREFIX)/bin/$${cmd}; done

unlink: uninstall
