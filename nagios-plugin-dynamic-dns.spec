Name:           nagios-plugin-dynamic-dns
Version:        1.0.0
Release:        1
Summary:        Nagios probe script for Dynamic DNS service

License:        MIT
URL:            https://github.com/tdviet/DDNS-probe
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
#BuildRequires:  
Requires:       bash,bind-utils,curl

%description
This is a script for monitoring status of Dynamic DNS service. The script 
should detect various possible issues of the service during operation and 
give corresponding error or warning message.

%prep
%setup -q


%build


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/libexec/argo-monitoring/probes/nagios-plugin-dynamic-dns/
cp usr/libexec/argo-monitoring/probes/nagios-plugin-dynamic-dns/nagios-plugin-dynamic-dns.sh  $RPM_BUILD_ROOT/usr/libexec/argo-monitoring/probes/nagios-plugin-dynamic-dns/

%files
/usr/libexec/argo-monitoring/probes/nagios-plugin-dynamic-dns/nagios-plugin-dynamic-dns.sh

%clean
rm -rf $RPM_BUILD_ROOT


%changelog
* Wed Mar 10 2021 Viet Tran <tdviet@gmail.com>
- First release
