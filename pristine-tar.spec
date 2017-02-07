Name: pristine-tar
Version: 1.37
Release: 2%{?dist}
Summary: Regenerate pristine tarballs

Group: System Tools
License: GPLv2
Url: http://kitenet.net/~joey/code/pristine-tar/
Source0: http://ftp.debian.org/debian/pool/main/p/pristine-tar/%{name}_%{version}.tar.gz

Requires:   tar
Requires:   gzip
Requires:   bzip2
%if 0%{?suse_version} || 0%{?fedora}
Recommends: pbzip2
%endif
Requires:   git
%if 0%{?suse_version}
Requires:   perl-base
%else
Requires:   perl
%endif
%if 0%{?fedora} || 0%{?centos_ver} >= 7
Requires:   xdelta1
%else
Requires:   xdelta < 3
%endif
BuildRequires:  pkgconfig(zlib)
BuildRequires:  perl(ExtUtils::MakeMaker)
%if 0%{?suse_version}
BuildRequires:  fdupes
%endif

%description
pristine-tar can regenerate a pristine upstream tarball using only a
small binary delta file and a copy of the source which can be a revision
control checkout.

The package also includes a pristine-gz command, which can regenerate
a pristine .gz file.

The delta file is designed to be checked into revision control along-side
the source code, thus allowing the original tarball to be extracted from
revision control.

pristine-tar is available in git at git://git.kitenet.net/pristine-tar/


%prep
%setup -q -n %{name}


%build
%if 0%{?fedora} || 0%{?centos_ver} >= 7
%define makemaker_extraopts XDELTA_PROGRAM=xdelta1
%endif
perl Makefile.PL INSTALLDIRS=vendor PREFIX=%{_prefix} %{?makemaker_extraopts}
make %{?_smp_mflags}


%install
rm -rf %{buildroot}
%make_install

find %{buildroot}/usr/lib/pristine-tar/ -name '*.a' | xargs rm

# Run fdupes if building in openSUSE
%if 0%{?suse_version}
%fdupes -s %{buildroot}/usr/lib/pristine-tar/
%endif


%files
%defattr(-,root,root,-)
%doc GPL TODO delta-format.txt
%{_bindir}/*
%{_mandir}/*
/usr/lib/pristine-tar
%{perl_vendorlib}/*
%{perl_archlib}/*
%exclude %{perl_vendorarch}


%changelog
* Tue Feb 24 2009 Jimmy Tang <jtang@tchpc.tcd.ie> - 0.21-1
- initial package

