####添加密码策略
afile="slapd.conf"
a=`grep -e "^\s*overlay\s*ppolicy\s*" $afile`
b=`grep -e "^\s*ppolicy_default.*" $afile`
#####

sed -i 's/\s*#*\s*\(include.*ppolicy.*\)/\1/g' /etc/openldap/slapd.conf
sed -i 's/\s*#*\s*\(moduleload.*ppolicy.*\)/\1/g' slapd.conf


if [[ $a =~ [[:space:]]*overlay[[:space:]]*ppolicy[[:space:]]* ]]
then
:
else
echo "overlay ppolicy" >> $afile
fi

if [[ $b =~ ([[:space:]]*)ppolicy_default(.*) ]]
then
:
else
echo 'ppolicy_default "cn=pwdDefault,ou=policies,dc=test,dc=com"' >> $afile
fi

ldapadd -w Manager1 -D "cn=Manager,dc=test,dc=com" -f policies.ldif

ldapadd -w Manager1 -D "cn=Manager,dc=test,dc=com" -f pwd_def_policy.ldif


#####添加用户
ldapadd -w Manager1 -D "cn=Manager,dc=test,dc=com" -f test_user3.ldif

####锁定用户
ldapmodify -w Manager1 -D "cn=Manager,dc=test,dc=com" -f lock_test_user3.ldif

####解锁用户
ldapmodify -w Manager1 -D "cn=Manager,dc=test,dc=com" -f unlock_test_user3.ldif

####添加组
ldapadd  -x -w Manager1  -D  "cn=Manager,dc=test,dc=com" -f test_group1.ldif

####向组内添加用户

ldapmodify -x -w Manager1 -D "cn=Manager,dc=test,dc=com" -f add_test_user2_to_test_group1.ldif

####从组中删除用户$
ldapmodify -x -w Manager1 -D "cn=Manager,dc=test,dc=com" -f remove_test_user2_from_test_group1.ldif
