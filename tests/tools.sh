#!/bin/sh

suite="tools"

failed=0
tested=0

echo "Running suite(s): gtk-doc-$suite";

# we can use which here as we override the path in TEST_ENVIRONMENT

# test perl scripts
for file in gtkdoc-check gtkdoc-fixxref gtkdoc-mkdb gtkdoc-mktmpl gtkdoc-rebase gtkdoc-scan gtkdoc-scangobj gtkdoc-scanobj ; do
  f:/lang/perl5/bin/perl -cwT `which $file`
  if test $? = 1 ; then failed=`expr $failed + 1`; fi
  tested=`expr $tested + 1`
done


# test shell scripts
for file in gtkdoc-mkhtml gtkdoc-mkman gtkdoc-mkpdf gtkdocize; do
  sh -n `which $file`
  if test $? != 0 ; then failed=`expr $failed + 1`; fi
  tested=`expr $tested + 1`
done


# test xsl files
for file in $ABS_TOP_SRCDIR/*.xsl; do
  xmllint --noout --noent $file
  if test $? != 0 ; then failed=`expr $failed + 1`; fi
  tested=`expr $tested + 1`
done

# summary
successes=`expr $tested - $failed`

rate=`expr 100 \* $successes / $tested`;
echo "$rate %: Checks $tested, Failures: $failed"

test $failed = 0
exit $?
