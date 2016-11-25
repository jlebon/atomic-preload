# Copyright (C) 2016 Red Hat, Inc.
#
# This file is part of atomic-preload.
#
# atomic-devmode is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General
# Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# atomic-devmode is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU Lesser General Public License for
# more details.
#
# You should have received a copy of the GNU Lesser General
# Public License along with atomic-devmode. If not, see
# <http://www.gnu.org/licenses/>.

.PHONY: all
all:
	@echo "Nothing to make."

LIBEXECDIR = $(DESTDIR)/usr/libexec
UNITDIR = $(DESTDIR)/usr/lib/systemd/system
STATEDIR = $(DESTDIR)/var/lib/atomic/preload

.PHONY: install
install:
	install -d -m 755 $(UNITDIR)
	install -m 644 atomic-preload.service $(UNITDIR)
	install -d -m 755 $(LIBEXECDIR)
	install -m 755 atomic-preload $(LIBEXECDIR)
	install -d -m 755 $(STATEDIR)

.PHONY: archive
archive:
	@if ! git diff-index --quiet HEAD; then \
		echo "WARNING: not all changes have been committed."; \
	fi
	@REF=$${REF:-HEAD}; \
	git archive --format=tar.gz --prefix=atomic-preload/ \
		$$REF > atomic-preload-$$REF.tar.gz && \
	echo "$$REF > atomic-preload-$$REF.tar.gz"
