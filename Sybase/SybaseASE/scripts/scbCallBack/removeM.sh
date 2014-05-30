#! /etc/ksh
# in vi ^M is CRTL+V  CRTL+M
# in emacs ^M is CRTL+Q CRTL+M
cat $1 | sed -e 's/ //' > $1.newmv $1.new $1
exit 0
