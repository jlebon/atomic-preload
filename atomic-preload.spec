Name: atomic-preload
Version: 0.3
Release: 1%{?dist}
Summary: Atomic Preload

License: LGPLv3+
URL: http://github.com/jlebon/atomic-preload

# From `make archive REF=v${VERSION}`
Source: %{name}-v%{version}.tar.gz
BuildArch: noarch

Requires: cloud-init
Requires: atomic

%description
Atomic Preload description.

%prep
%setup -qn atomic-preload

%build
# Nothing to build

%install
rm -rf "%{buildroot}"
make install DESTDIR="%{buildroot}"

%files
%{_unitdir}/atomic-preload.service
%{_sharedstatedir}/atomic/preload
%{_libexecdir}/atomic-preload
%doc README.md
%license COPYING COPYING.LESSER
