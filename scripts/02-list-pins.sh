source b9y.conf

echo "keys lab" | b9y-cli -h $b9y_host -u $b9y_user -p $b9y_password | grep lab | sed "s/:/_/;" | grep -v ":" | sed "s/.*_//;"
