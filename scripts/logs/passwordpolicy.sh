#!/bin/bash

cd /var/log/dnsrout

# Generate Username and Password Files
touch  userpass.txt password.txt
grep -i "USERNAME" /var/log/auth.log > userpass.txt
awk '{print "USERNAME: " $10  " PASSWORD: "$12} END{print "\n"}'  userpass.txt > password.txt

# Password Policy Generation
touch passpol.txt

cat password.txt | cut -d " " -f4 | tr -d "'" > passpol.txt
cat passpol.txt | sort | uniq -cid | sort -r | head -10 | cut -c 9- > passpol.txt
filename="passpol.txt"

longest_length=0
greatest_special_count=0
greatest_digit_count=0

while IFS= read -r word; do

    # Find the number of special characters
    special_count=$(echo "$word" | grep -oE '[^[:alnum:]]' | wc -l)

    # Find the number of digits
    digit_count=$(echo "$word" | grep -oE '[[:digit:]]' | wc -l)

    # Find the length of the word
    length=$(echo -n "$word" | wc -m)

    # # Print the results
    # echo "Special Characters: $special_count"
    # echo "Digits: $digit_count"
    # echo "Length: $length"
    # echo "---"

    # Check for longest length
    if (( length > longest_length )); then
        longest_length=$length
    fi

    # Check for greatest special character count
    if (( special_count > greatest_special_count )); then
        greatest_special_count=$special_count
    fi

    # Check for greatest digit count
    if (( digit_count > greatest_digit_count )); then
        greatest_digit_count=$digit_count
    fi

done < "$filename"


# Print the overall results
echo "Longest Length: $longest_length" > passwordpolicy.txt
echo "Greatest Special Character Count: $greatest_special_count" >> passwordpolicy.txt
echo "Greatest Digit Count: $greatest_digit_count" >> passwordpolicy.txt

rm passpol.txt password.txt
